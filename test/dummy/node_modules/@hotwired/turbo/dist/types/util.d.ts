export declare type DispatchOptions = {
    target: EventTarget;
    cancelable: boolean;
    detail: any;
};
export declare function dispatch(eventName: string, { target, cancelable, detail }?: Partial<DispatchOptions>): CustomEvent<any>;
export declare function nextAnimationFrame(): Promise<void>;
export declare function nextEventLoopTick(): Promise<void>;
export declare function nextMicrotask(): Promise<void>;
export declare function parseHTMLDocument(html?: string): Document;
export declare function unindent(strings: TemplateStringsArray, ...values: any[]): string;
export declare function uuid(): string;
export declare function getAttribute(attributeName: string, ...elements: (Element | undefined)[]): string | null;
export declare function markAsBusy(...elements: Element[]): void;
export declare function clearBusyState(...elements: Element[]): void;
