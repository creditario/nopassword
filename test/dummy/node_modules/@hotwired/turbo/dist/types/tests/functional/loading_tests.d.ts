import { TurboDriveTestCase } from "../helpers/turbo_drive_test_case";
declare global {
    interface Window {
        savedElement: Element | null;
    }
}
export declare class LoadingTests extends TurboDriveTestCase {
    setup(): Promise<void>;
    "test eager loading within a details element"(): Promise<void>;
    "test lazy loading within a details element"(): Promise<void>;
    "test changing loading attribute from lazy to eager loads frame"(): Promise<void>;
    "test navigating a visible frame with loading=lazy navigates"(): Promise<void>;
    "test changing src attribute on a frame with loading=lazy defers navigation"(): Promise<void>;
    "test changing src attribute on a frame with loading=eager navigates"(): Promise<void>;
    "test reloading a frame reloads the content"(): Promise<void>;
    "test navigating away from a page does not reload its frames"(): Promise<void>;
    "test disconnecting and reconnecting a frame does not reload the frame"(): Promise<void>;
}
