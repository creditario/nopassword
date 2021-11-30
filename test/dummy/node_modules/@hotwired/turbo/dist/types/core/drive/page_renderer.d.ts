import { Renderer } from "../renderer";
import { PageSnapshot } from "./page_snapshot";
export declare class PageRenderer extends Renderer<HTMLBodyElement, PageSnapshot> {
    get shouldRender(): boolean;
    prepareToRender(): void;
    render(): Promise<void>;
    finishRendering(): void;
    get currentHeadSnapshot(): import("./head_snapshot").HeadSnapshot;
    get newHeadSnapshot(): import("./head_snapshot").HeadSnapshot;
    get newElement(): HTMLBodyElement;
    mergeHead(): void;
    replaceBody(): void;
    get trackedElementsAreIdentical(): boolean;
    copyNewHeadStylesheetElements(): void;
    copyNewHeadScriptElements(): void;
    removeCurrentHeadProvisionalElements(): void;
    copyNewHeadProvisionalElements(): void;
    activateNewBody(): void;
    activateNewBodyScriptElements(): void;
    assignNewBody(): void;
    get newHeadStylesheetElements(): Element[];
    get newHeadScriptElements(): Element[];
    get currentHeadProvisionalElements(): Element[];
    get newHeadProvisionalElements(): Element[];
    get newBodyScriptElements(): NodeListOf<HTMLScriptElement>;
}
