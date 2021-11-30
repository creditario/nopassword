import { View, ViewDelegate } from "../view";
import { ErrorRenderer } from "./error_renderer";
import { PageRenderer } from "./page_renderer";
import { PageSnapshot } from "./page_snapshot";
import { SnapshotCache } from "./snapshot_cache";
export interface PageViewDelegate extends ViewDelegate<PageSnapshot> {
    viewWillCacheSnapshot(): void;
}
declare type PageViewRenderer = PageRenderer | ErrorRenderer;
export declare class PageView extends View<Element, PageSnapshot, PageViewRenderer, PageViewDelegate> {
    readonly snapshotCache: SnapshotCache;
    lastRenderedLocation: URL;
    renderPage(snapshot: PageSnapshot, isPreview?: boolean, willRender?: boolean): Promise<void>;
    renderError(snapshot: PageSnapshot): Promise<void>;
    clearSnapshotCache(): void;
    cacheSnapshot(): Promise<PageSnapshot | undefined>;
    getCachedSnapshotForLocation(location: URL): PageSnapshot | undefined;
    get snapshot(): PageSnapshot;
    get shouldCacheSnapshot(): boolean;
}
export {};
