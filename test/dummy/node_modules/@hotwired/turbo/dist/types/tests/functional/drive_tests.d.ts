import { TurboDriveTestCase } from "../helpers/turbo_drive_test_case";
export declare class DriveTests extends TurboDriveTestCase {
    path: string;
    setup(): Promise<void>;
    "test drive enabled by default; click normal link"(): Promise<void>;
    "test drive to external link"(): Promise<void>;
    "test drive enabled by default; click link inside data-turbo='false'"(): Promise<void>;
}
