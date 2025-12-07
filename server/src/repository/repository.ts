/**
 * Repositoryインターフェース
 * 状態管理の抽象化層。将来の永続化に備えた設計。
 */

import type { CRDTState, Operation } from "../domain";

/**
 * 状態リポジトリのインターフェース
 * 異なるストレージバックエンドを差し替え可能にする
 */
export interface StateRepository {
  /**
   * 現在のCRDT状態を取得
   * @returns CRDT状態のコピー
   */
  getState(): Promise<CRDTState>;

  /**
   * 操作を状態に適用
   * 将来のDB書き込みを想定した遅延ポイント
   * @param op 適用する操作
   */
  applyOperation(op: Operation): Promise<void>;

  /**
   * 別の状態をマージ
   * クライアント再接続時の状態同期に使用
   * @param state マージする状態
   */
  mergeState(state: CRDTState): Promise<void>;
}
