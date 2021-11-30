import { FrameElement } from "../../elements";
import { Snapshot } from "../snapshot";
import { View } from "../view";
export declare class FrameView extends View<FrameElement> {
    invalidate(): void;
    get snapshot(): Snapshot<FrameElement>;
}
