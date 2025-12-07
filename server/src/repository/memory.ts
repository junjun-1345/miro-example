/**
 * インメモリRepository実装
 * MVP用の揮発性ストレージ。テスト用の遅延シミュレーション機能付き。
 */

import {
  type CRDTState,
  type Operation,
  applyOperation,
  cloneState,
  createEmptyState,
  mergeState,
} from "../domain";
import type { StateRepository } from "./repository";

/**
 * インメモリRepository
 * サーバー再起動で状態は消える
 */
export class MemoryRepository implements StateRepository {
  private state: CRDTState;
  private readonly delayMs: number;

  /**
   * @param delayMs 各操作に挿入する遅延（ミリ秒）。DB書き込みのシミュレーション用。
   */
  constructor(delayMs = 0) {
    this.state = createEmptyState();
    this.delayMs = delayMs;
  }

  /**
   * 遅延を挿入するヘルパー
   */
  private async delay(): Promise<void> {
    if (this.delayMs > 0) {
      await new Promise((resolve) => setTimeout(resolve, this.delayMs));
    }
  }

  async getState(): Promise<CRDTState> {
    await this.delay();
    // 呼び出し元が状態を変更しないようディープコピーを返す
    return cloneState(this.state);
  }

  async applyOperation(op: Operation): Promise<void> {
    await this.delay();
    applyOperation(this.state, op);
  }

  async mergeState(other: CRDTState): Promise<void> {
    await this.delay();
    mergeState(this.state, other);
  }
}
