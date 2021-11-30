import { TurboDriveTestCase } from "../helpers/turbo_drive_test_case";
export declare class PausableRequestsTests extends TurboDriveTestCase {
    setup(): Promise<void>;
    "test pauses and resumes request"(): Promise<void>;
    "test aborts request"(): Promise<void>;
}
