/**
 * ドメイン型定義
 * リアルタイム共同編集ボードで使用するデータ型
 */

/** 図形の種類 */
export type ShapeType = "rectangle" | "circle";

/**
 * 図形データ
 * キャンバス上に配置される図形を表現
 */
export interface Shape {
  /** 図形の一意識別子 (UUID) */
  id: string;
  /** 図形の種類 */
  type: ShapeType;
  /** X座標 */
  x: number;
  /** Y座標 */
  y: number;
  /** 幅 */
  width: number;
  /** 高さ */
  height: number;
  /** 色 (CSS color形式) */
  color: string;
  /** LWW用タイムスタンプ (Unixミリ秒) */
  timestamp: number;
  /** クライアントID (タイムスタンプが同じ場合のタイブレーカー) */
  clientId: string;
}

/**
 * CRDT状態における図形エントリ
 * 論理削除をサポート
 */
export interface ShapeEntry {
  /** 図形データ */
  shape: Shape;
  /** エントリのタイムスタンプ */
  timestamp: number;
  /** 削除フラグ */
  deleted: boolean;
}

/**
 * CRDT状態
 * LWW-Element-Setの実装
 */
export interface CRDTState {
  /** 図形ID -> エントリのマップ */
  shapes: Record<string, ShapeEntry>;
}

/** 操作の種類 */
export type OperationType = "upsert" | "delete";

/**
 * 操作データ
 * クライアント間で同期される変更操作
 */
export interface Operation {
  /** 操作の種類 */
  type: OperationType;
  /** 対象の図形 */
  shape: Shape;
  /** 操作のタイムスタンプ */
  timestamp: number;
  /** 操作を行ったクライアントID */
  clientId: string;
}

/** 同期メッセージの種類 */
export type SyncMessageType = "sync" | "operation";

/**
 * WebSocket同期メッセージ
 * クライアント-サーバー間の通信に使用
 */
export interface SyncMessage {
  /** メッセージの種類 */
  type: SyncMessageType;
  /** 全状態 (type=sync の場合) */
  state?: CRDTState;
  /** 操作 (type=operation の場合) */
  op?: Operation;
}
