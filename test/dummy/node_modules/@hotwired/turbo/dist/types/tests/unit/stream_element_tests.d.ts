import { DOMTestCase } from "../helpers/dom_test_case";
export declare class StreamElementTests extends DOMTestCase {
    beforeTest(): Promise<void>;
    "test action=append"(): Promise<void>;
    "test action=append with children ID already present in target"(): Promise<void>;
    "test action=prepend"(): Promise<void>;
    "test action=prepend with children ID already present in target"(): Promise<void>;
    "test action=remove"(): Promise<void>;
    "test action=replace"(): Promise<void>;
    "test action=update"(): Promise<void>;
    "test action=after"(): Promise<void>;
    "test action=before"(): Promise<void>;
}
