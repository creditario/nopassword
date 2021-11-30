import { Renderer } from "./renderer";
import { Snapshot } from "./snapshot";
import { Position } from "./types";
export interface ViewDelegate<S extends Snapshot> {
    allowsImmediateRender(snapshot: S, resume: (value: any) => void): boolean;
    viewRenderedSnapshot(snapshot: S, isPreview: boolean): void;
    viewInvalidated(): void;
}
export declare abstract class View<E extends Element, S extends Snapshot<E> = Snapshot<E>, R extends Renderer<E, S> = Renderer<E, S>, D extends ViewDelegate<S> = ViewDelegate<S>> {
    readonly delegate: D;
    readonly element: E;
    renderer?: R;
    abstract readonly snapshot: S;
    renderPromise?: Promise<void>;
    private resolveRenderPromise;
    private resolveInterceptionPromise;
    constructor(delegate: D, element: E);
    scrollToAnchor(anchor: string | undefined): void;
    scrollToAnchorFromLocation(location: URL): void;
    scrollToElement(element: Element): void;
    focusElement(element: Element): void;
    scrollToPosition({ x, y }: Position): void;
    scrollToTop(): void;
    get scrollRoot(): {
        scrollTo(x: number, y: number): void;
    };
    render(renderer: R): Promise<void>;
    invalidate(): void;
    prepareToRenderSnapshot(renderer: R): void;
    markAsPreview(isPreview: boolean): void;
    renderSnapshot(renderer: R): Promise<void>;
    finishRenderingSnapshot(renderer: R): void;
}
