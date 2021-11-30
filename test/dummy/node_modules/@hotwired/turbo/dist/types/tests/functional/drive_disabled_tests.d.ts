import { TurboDriveTestCase } from "../helpers/turbo_drive_test_case";
export declare class DriveDisabledTests extends TurboDriveTestCase {
    path: string;
    setup(): Promise<void>;
    "test drive disabled by default; click normal link"(): Promise<void>;
    "test drive disabled by default; click link inside data-turbo='true'"(): Promise<void>;
    "test drive disabled by default; submit form inside data-turbo='true'"(): Promise<void>;
    get formSubmitted(): Promise<boolean>;
}
