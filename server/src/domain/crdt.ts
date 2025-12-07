/**
 * CRDT操作モジュール
 * LWW-Element-Set の実装
 */

import type { CRDTState, Operation, ShapeEntry } from "./types";

/**
 * 空のCRDT状態を作成
 * @returns 空のCRDT状態
 */
export function createEmptyState(): CRDTState {
  return { shapes: {} };
}

/**
 * タイムスタンプとクライアントIDで優先順位を比較
 * LWWの競合解決ロジック
 *
 * @param newTimestamp - 新しい操作のタイムスタンプ
 * @param newClientId - 新しい操作のクライアントID
 * @param existingTimestamp - 既存エントリのタイムスタンプ
 * @param existingClientId - 既存エントリのクライアントID
 * @returns 新しい操作が優先される場合true
 */
function shouldOverwrite(
  newTimestamp: number,
  newClientId: string,
  existingTimestamp: number,
  existingClientId: string
): boolean {
  // タイムスタンプが新しい方が優先
  if (newTimestamp > existingTimestamp) {
    return true;
  }
  // タイムスタンプが同じ場合、クライアントIDで決定（辞書順で大きい方が優先）
  if (newTimestamp === existingTimestamp && newClientId > existingClientId) {
    return true;
  }
  return false;
}

/**
 * CRDT状態に操作を適用
 * 状態を直接変更する（破壊的操作）
 *
 * @param state - 適用先のCRDT状態
 * @param op - 適用する操作
 */
export function applyOperation(state: CRDTState, op: Operation): void {
  const existing = state.shapes[op.shape.id];

  switch (op.type) {
    case "upsert": {
      // 既存エントリがない、または新しい操作が優先される場合に更新
      if (
        !existing ||
        shouldOverwrite(
          op.timestamp,
          op.clientId,
          existing.timestamp,
          existing.shape.clientId
        )
      ) {
        state.shapes[op.shape.id] = {
          shape: op.shape,
          timestamp: op.timestamp,
          deleted: false,
        };
      }
      break;
    }
    case "delete": {
      // 既存エントリがあり、新しい操作が優先される場合に削除フラグを立てる
      if (
        existing &&
        shouldOverwrite(
          op.timestamp,
          op.clientId,
          existing.timestamp,
          existing.shape.clientId
        )
      ) {
        state.shapes[op.shape.id] = {
          ...existing,
          timestamp: op.timestamp,
          deleted: true,
        };
      }
      break;
    }
  }
}

/**
 * 2つのCRDT状態をマージ
 * 各図形について、より新しいエントリを採用
 * 状態を直接変更する（破壊的操作）
 *
 * @param state - マージ先のCRDT状態（この状態が変更される）
 * @param other - マージ元のCRDT状態
 */
export function mergeState(state: CRDTState, other: CRDTState): void {
  for (const [id, entry] of Object.entries(other.shapes)) {
    const existing = state.shapes[id];

    if (
      !existing ||
      shouldOverwrite(
        entry.timestamp,
        entry.shape.clientId,
        existing.timestamp,
        existing.shape.clientId
      )
    ) {
      state.shapes[id] = entry;
    }
  }
}

/**
 * CRDT状態から削除されていない図形のリストを取得
 *
 * @param state - CRDT状態
 * @returns 有効な図形エントリの配列
 */
export function getActiveShapes(state: CRDTState): ShapeEntry[] {
  return Object.values(state.shapes).filter((entry) => !entry.deleted);
}

/**
 * CRDT状態のディープクローンを作成
 *
 * @param state - クローン元のCRDT状態
 * @returns 新しいCRDT状態
 */
export function cloneState(state: CRDTState): CRDTState {
  return structuredClone(state);
}
