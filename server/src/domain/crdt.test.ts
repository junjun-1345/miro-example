/**
 * CRDT操作のテスト
 */

import { describe, expect, it } from "bun:test";
import {
  applyOperation,
  cloneState,
  createEmptyState,
  getActiveShapes,
  mergeState,
} from "./crdt";
import type { CRDTState, Operation, Shape } from "./types";

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

describe("createEmptyState", () => {
  it("空の状態を作成する", () => {
    const state = createEmptyState();
    expect(state.shapes).toEqual({});
  });
});

describe("applyOperation - upsert", () => {
  it("新しい図形を追加できる", () => {
    const state = createEmptyState();
    const shape = createShape();
    const op: Operation = {
      type: "upsert",
      shape,
      timestamp: 1000,
      clientId: "client-a",
    };

    applyOperation(state, op);

    expect(state.shapes["shape-1"]).toEqual({
      shape,
      timestamp: 1000,
      deleted: false,
    });
  });

  it("タイムスタンプが新しい場合に図形を更新できる", () => {
    const state = createEmptyState();
    const shape1 = createShape({ timestamp: 1000 });
    const shape2 = createShape({ x: 200, timestamp: 2000 });

    applyOperation(state, {
      type: "upsert",
      shape: shape1,
      timestamp: 1000,
      clientId: "client-a",
    });

    applyOperation(state, {
      type: "upsert",
      shape: shape2,
      timestamp: 2000,
      clientId: "client-a",
    });

    expect(state.shapes["shape-1"].shape.x).toBe(200);
    expect(state.shapes["shape-1"].timestamp).toBe(2000);
  });

  it("タイムスタンプが古い場合は更新されない", () => {
    const state = createEmptyState();
    const shape1 = createShape({ x: 100, timestamp: 2000 });
    const shape2 = createShape({ x: 200, timestamp: 1000 });

    applyOperation(state, {
      type: "upsert",
      shape: shape1,
      timestamp: 2000,
      clientId: "client-a",
    });

    applyOperation(state, {
      type: "upsert",
      shape: shape2,
      timestamp: 1000,
      clientId: "client-a",
    });

    // 古いタイムスタンプの操作は無視される
    expect(state.shapes["shape-1"].shape.x).toBe(100);
    expect(state.shapes["shape-1"].timestamp).toBe(2000);
  });

  it("タイムスタンプが同じ場合、clientIdで決定する", () => {
    const state = createEmptyState();
    const shapeA = createShape({ x: 100, clientId: "client-a" });
    const shapeB = createShape({ x: 200, clientId: "client-b" });

    // client-a が先に操作
    applyOperation(state, {
      type: "upsert",
      shape: shapeA,
      timestamp: 1000,
      clientId: "client-a",
    });

    // 同じタイムスタンプで client-b が操作
    // client-b > client-a なので client-b が優先
    applyOperation(state, {
      type: "upsert",
      shape: shapeB,
      timestamp: 1000,
      clientId: "client-b",
    });

    expect(state.shapes["shape-1"].shape.x).toBe(200);
    expect(state.shapes["shape-1"].shape.clientId).toBe("client-b");
  });
});

describe("applyOperation - delete", () => {
  it("図形を削除できる", () => {
    const state = createEmptyState();
    const shape = createShape();

    applyOperation(state, {
      type: "upsert",
      shape,
      timestamp: 1000,
      clientId: "client-a",
    });

    applyOperation(state, {
      type: "delete",
      shape,
      timestamp: 2000,
      clientId: "client-a",
    });

    expect(state.shapes["shape-1"].deleted).toBe(true);
    expect(state.shapes["shape-1"].timestamp).toBe(2000);
  });

  it("古いタイムスタンプでは削除されない", () => {
    const state = createEmptyState();
    const shape = createShape({ timestamp: 2000 });

    applyOperation(state, {
      type: "upsert",
      shape,
      timestamp: 2000,
      clientId: "client-a",
    });

    applyOperation(state, {
      type: "delete",
      shape,
      timestamp: 1000,
      clientId: "client-a",
    });

    expect(state.shapes["shape-1"].deleted).toBe(false);
  });

  it("存在しない図形の削除は無視される", () => {
    const state = createEmptyState();
    const shape = createShape();

    applyOperation(state, {
      type: "delete",
      shape,
      timestamp: 1000,
      clientId: "client-a",
    });

    // 何も追加されない
    expect(state.shapes["shape-1"]).toBeUndefined();
  });
});

describe("mergeState", () => {
  it("2つの状態をマージできる", () => {
    const state1 = createEmptyState();
    const state2 = createEmptyState();

    const shape1 = createShape({ id: "shape-1" });
    const shape2 = createShape({ id: "shape-2" });

    applyOperation(state1, {
      type: "upsert",
      shape: shape1,
      timestamp: 1000,
      clientId: "client-a",
    });

    applyOperation(state2, {
      type: "upsert",
      shape: shape2,
      timestamp: 1000,
      clientId: "client-b",
    });

    mergeState(state1, state2);

    expect(Object.keys(state1.shapes)).toHaveLength(2);
    expect(state1.shapes["shape-1"]).toBeDefined();
    expect(state1.shapes["shape-2"]).toBeDefined();
  });

  it("競合時は新しいタイムスタンプが優先される", () => {
    const state1 = createEmptyState();
    const state2 = createEmptyState();

    const shape1 = createShape({ x: 100, timestamp: 1000 });
    const shape2 = createShape({ x: 200, timestamp: 2000 });

    applyOperation(state1, {
      type: "upsert",
      shape: shape1,
      timestamp: 1000,
      clientId: "client-a",
    });

    applyOperation(state2, {
      type: "upsert",
      shape: shape2,
      timestamp: 2000,
      clientId: "client-b",
    });

    mergeState(state1, state2);

    expect(state1.shapes["shape-1"].shape.x).toBe(200);
  });

  it("マージは可換である（順序に依存しない）", () => {
    const stateA1 = createEmptyState();
    const stateA2 = createEmptyState();
    const stateB1 = createEmptyState();
    const stateB2 = createEmptyState();

    const shape1 = createShape({ id: "s1", x: 100, timestamp: 1000, clientId: "c1" });
    const shape2 = createShape({ id: "s2", x: 200, timestamp: 2000, clientId: "c2" });

    // パターンA: state1にマージ後state2をマージ
    applyOperation(stateA1, { type: "upsert", shape: shape1, timestamp: 1000, clientId: "c1" });
    applyOperation(stateA2, { type: "upsert", shape: shape2, timestamp: 2000, clientId: "c2" });
    mergeState(stateA1, stateA2);

    // パターンB: state2にマージ後state1をマージ
    applyOperation(stateB1, { type: "upsert", shape: shape1, timestamp: 1000, clientId: "c1" });
    applyOperation(stateB2, { type: "upsert", shape: shape2, timestamp: 2000, clientId: "c2" });
    mergeState(stateB2, stateB1);

    // 結果が同じであることを確認
    expect(stateA1.shapes).toEqual(stateB2.shapes);
  });
});

describe("getActiveShapes", () => {
  it("削除されていない図形のみを返す", () => {
    const state = createEmptyState();

    const shape1 = createShape({ id: "shape-1" });
    const shape2 = createShape({ id: "shape-2" });
    const shape3 = createShape({ id: "shape-3" });

    applyOperation(state, { type: "upsert", shape: shape1, timestamp: 1000, clientId: "c" });
    applyOperation(state, { type: "upsert", shape: shape2, timestamp: 1000, clientId: "c" });
    applyOperation(state, { type: "upsert", shape: shape3, timestamp: 1000, clientId: "c" });

    // shape2を削除
    applyOperation(state, { type: "delete", shape: shape2, timestamp: 2000, clientId: "c" });

    const active = getActiveShapes(state);
    expect(active).toHaveLength(2);
    expect(active.map((e) => e.shape.id).sort()).toEqual(["shape-1", "shape-3"]);
  });
});

describe("cloneState", () => {
  it("状態のディープクローンを作成する", () => {
    const state = createEmptyState();
    const shape = createShape();

    applyOperation(state, { type: "upsert", shape, timestamp: 1000, clientId: "c" });

    const cloned = cloneState(state);

    // 値は同じ
    expect(cloned).toEqual(state);

    // 参照は異なる
    expect(cloned).not.toBe(state);
    expect(cloned.shapes).not.toBe(state.shapes);

    // 元を変更してもクローンには影響しない
    applyOperation(state, {
      type: "upsert",
      shape: createShape({ x: 999 }),
      timestamp: 3000,
      clientId: "c",
    });

    expect(cloned.shapes["shape-1"].shape.x).toBe(100);
    expect(state.shapes["shape-1"].shape.x).toBe(999);
  });
});
