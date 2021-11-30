import { StimulusUse, StimulusUseOptions } from '../stimulus-use';
import { HoverComposableController } from './hover-controller';
export interface HoverOptions extends StimulusUseOptions {
    element?: Element;
}
export declare class UseHover extends StimulusUse {
    controller: HoverComposableController;
    constructor(controller: HoverComposableController, options?: HoverOptions);
    observe: () => void;
    unobserve: () => void;
    private onEnter;
    private onLeave;
    private enhanceController;
}
export declare const useHover: (controller: HoverComposableController, options?: HoverOptions) => readonly [() => void, () => void];
