import { IdleComposableController } from './idle-controller';
export interface IdleOptions {
    ms?: number;
    initialState?: boolean;
    events?: string[];
    dispatchEvent?: boolean;
    eventPrefix?: boolean | string;
}
export declare const useIdle: (controller: IdleComposableController, options?: IdleOptions) => readonly [() => void, () => void];
