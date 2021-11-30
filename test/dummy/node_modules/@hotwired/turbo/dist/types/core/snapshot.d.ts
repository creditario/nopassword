export declare class Snapshot<E extends Element = Element> {
    readonly element: E;
    constructor(element: E);
    get children(): Element[];
    hasAnchor(anchor: string | undefined): boolean;
    getElementForAnchor(anchor: string | undefined): Element | null;
    get isConnected(): boolean;
    get firstAutofocusableElement(): Element | null;
    get permanentElements(): Element[];
    getPermanentElementById(id: string): Element | null;
    getPermanentElementMapForSnapshot(snapshot: Snapshot): Record<string, [Element, Element]>;
}
export declare type PermanentElementMap = Record<string, [Element, Element]>;
