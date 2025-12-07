/**
 * MemoryRepositoryのテスト
 */

import { describe, expect, it } from "bun:test";
import type { Operation, Shape } from "../domain";
import { MemoryRepository } from "./memory";

// テスト用のヘルパー関数
function createShape(overrides: Partial<Shape> = {}): Shape {
  return {
    id: "shape-1",
    type: "rectangle",
    x: 100,
    y: 100,
    width: 50,
    height: 50,
    color: "#ff0000",
    timestamp: 1000,
    clientId: "client-a",
    ...overrides,
  };
}

describe("MemoryRepository", () => {
  it("初期状態は空", async () => {
    const repo = new MemoryRepository();
    const state = await repo.getState();

    expect(state.shapes).toEqual({});
  });

  it("操作を適用できる", async () => {
    const repo = new MemoryRepository();
    const shape = createShape();
    const op: Operation = {
      type: "upsert",
      shape,
      timestamp: 1000,
      clientId: "client-a",
    };

    await repo.applyOperation(op);
    const state = await repo.getState();

    expect(state.shapes["shape-1"]).toBeDefined();
    expect(state.shapes["shape-1"].shape.x).toBe(100);
  });

  it("getStateは状態のコピーを返す", async () => {
    const repo = new MemoryRepository();
    const shape = createShape();

    await repo.applyOperation({
      type: "upsert",
      shape,
      timestamp: 1000,
      clientId: "client-a",
    });

    const state1 = await repo.getState();
    const state2 = await repo.getState();

    // 参照が異なることを確認
    expect(state1).not.toBe(state2);
    expect(state1.shapes).not.toBe(state2.shapes);

    // 返された状態を変更してもリポジトリに影響しない
    state1.shapes["shape-1"].shape.x = 999;
    const state3 = await repo.getState();
    expect(state3.shapes["shape-1"].shape.x).toBe(100);
  });

  it("状態をマージできる", async () => {
    const repo = new MemoryRepository();

    // リポジトリに shape-1 を追加
    await repo.applyOperation({
      type: "upsert",
      shape: createShape({ id: "shape-1" }),
      timestamp: 1000,
      clientId: "client-a",
    });

    // 別の状態（shape-2を持つ）をマージ
    await repo.mergeState({
      shapes: {
        "shape-2": {
          shape: createShape({ id: "shape-2" }),
          timestamp: 1000,
          deleted: false,
        },
      },
    });

    const state = await repo.getState();
    expect(Object.keys(state.shapes)).toHaveLength(2);
    expect(state.shapes["shape-1"]).toBeDefined();
    expect(state.shapes["shape-2"]).toBeDefined();
  });

  it("遅延を挿入できる", async () => {
    const delayMs = 50;
    const repo = new MemoryRepository(delayMs);

    const start = Date.now();
    await repo.getState();
    const elapsed = Date.now() - start;

    // 遅延が適用されていることを確認（多少の誤差を許容）
    expect(elapsed).toBeGreaterThanOrEqual(delayMs - 10);
  });

  it("複数の操作を順番に適用できる", async () => {
    const repo = new MemoryRepository();

    // 図形を追加
    await repo.applyOperation({
      type: "upsert",
      shape: createShape({ x: 100 }),
      timestamp: 1000,
      clientId: "client-a",
    });

    // 図形を移動
    await repo.applyOperation({
      type: "upsert",
      shape: createShape({ x: 200 }),
      timestamp: 2000,
      clientId: "client-a",
    });

    // 図形を削除
    await repo.applyOperation({
      type: "delete",
      shape: createShape(),
      timestamp: 3000,
      clientId: "client-a",
    });

    const state = await repo.getState();
    expect(state.shapes["shape-1"].deleted).toBe(true);
  });
});
