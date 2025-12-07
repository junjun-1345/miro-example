/**
 * ドメイン層のエクスポート
 */

// 型定義
export type {
  CRDTState,
  Operation,
  OperationType,
  Shape,
  ShapeEntry,
  ShapeType,
  SyncMessage,
  SyncMessageType,
} from "./types";

// CRDT操作
export {
  applyOperation,
  cloneState,
  createEmptyState,
  getActiveShapes,
  mergeState,
} from "./crdt";
