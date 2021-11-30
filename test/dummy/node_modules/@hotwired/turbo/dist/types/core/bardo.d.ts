import { PermanentElementMap } from "./snapshot";
export declare class Bardo {
    readonly permanentElementMap: PermanentElementMap;
    static preservingPermanentElements(permanentElementMap: PermanentElementMap, callback: () => void): void;
    constructor(permanentElementMap: PermanentElementMap);
    enter(): void;
    leave(): void;
    replaceNewPermanentElementWithPlaceholder(permanentElement: Element): void;
    replaceCurrentPermanentElementWithClone(permanentElement: Element): void;
    replacePlaceholderWithPermanentElement(permanentElement: Element): void;
    getPlaceholderById(id: string): HTMLMetaElement | undefined;
    get placeholders(): HTMLMetaElement[];
}
