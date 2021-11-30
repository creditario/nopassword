import { TurboDriveTestCase } from "../helpers/turbo_drive_test_case";
export declare class PausableRenderingTests extends TurboDriveTestCase {
    setup(): Promise<void>;
    "test pauses and resumes rendering"(): Promise<void>;
    "test aborts rendering"(): Promise<void>;
}
