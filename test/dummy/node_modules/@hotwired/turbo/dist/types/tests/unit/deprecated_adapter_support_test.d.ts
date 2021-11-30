import { VisitOptions, Visit } from "../../core/drive/visit";
import { FormSubmission } from "../../core/drive/form_submission";
import { Adapter } from "../../core/native/adapter";
import { DOMTestCase } from "../helpers/dom_test_case";
export declare class DeprecatedAdapterSupportTest extends DOMTestCase implements Adapter {
    locations: any[];
    originalAdapter: Adapter;
    setup(): Promise<void>;
    teardown(): Promise<void>;
    "test visit proposal location includes deprecated absoluteURL property"(): Promise<void>;
    "test visit start location includes deprecated absoluteURL property"(): Promise<void>;
    visitProposedToLocation(location: URL, options?: Partial<VisitOptions>): void;
    visitStarted(visit: Visit): void;
    visitCompleted(visit: Visit): void;
    visitFailed(visit: Visit): void;
    visitRequestStarted(visit: Visit): void;
    visitRequestCompleted(visit: Visit): void;
    visitRequestFailedWithStatusCode(visit: Visit, statusCode: number): void;
    visitRequestFinished(visit: Visit): void;
    visitRendered(visit: Visit): void;
    formSubmissionStarted(formSubmission: FormSubmission): void;
    formSubmissionFinished(formSubmission: FormSubmission): void;
    pageInvalidated(): void;
}
