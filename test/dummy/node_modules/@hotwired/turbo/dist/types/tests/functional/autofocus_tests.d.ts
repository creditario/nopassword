import { TurboDriveTestCase } from "../helpers/turbo_drive_test_case";
export declare class AutofocusTests extends TurboDriveTestCase {
    setup(): Promise<void>;
    "test autofocus first autofocus element on load"(): Promise<void>;
    "test autofocus first [autofocus] element on visit"(): Promise<void>;
    "test navigating a frame with a descendant link autofocuses [autofocus]:first-of-type"(): Promise<void>;
    "test navigating a frame with a link targeting the frame autofocuses [autofocus]:first-of-type"(): Promise<void>;
    "test navigating a frame with a turbo-frame targeting the frame autofocuses [autofocus]:first-of-type"(): Promise<void>;
}
