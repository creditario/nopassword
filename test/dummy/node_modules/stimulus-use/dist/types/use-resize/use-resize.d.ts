import { ResizeComposableController } from './resize-controller';
export interface ResizeOptions {
    element?: Element;
    dispatchEvent?: boolean;
    eventPrefix?: boolean | string;
}
export declare const useResize: (controller: ResizeComposableController, options?: ResizeOptions) => readonly [() => void, () => void];
