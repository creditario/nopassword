import { ClickOutsideComposableController } from './click-outside-controller';
export interface ClickOutsideOptions {
    element?: Element;
    events?: string[];
    onlyVisible?: boolean;
    dispatchEvent?: boolean;
    eventPrefix?: boolean | string;
}
export declare const useClickOutside: (controller: ClickOutsideComposableController, options?: ClickOutsideOptions) => readonly [() => void, () => void];
