import { PageSnapshot } from "./page_snapshot";
import { Renderer } from "../renderer";
export declare class ErrorRenderer extends Renderer<HTMLBodyElement, PageSnapshot> {
    render(): Promise<void>;
    replaceHeadAndBody(): void;
    activateScriptElements(): void;
    get newHead(): HTMLHeadElement;
    get scriptElements(): HTMLScriptElement[];
}
