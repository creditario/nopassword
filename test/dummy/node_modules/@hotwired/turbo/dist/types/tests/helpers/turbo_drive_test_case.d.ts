import { FunctionalTestCase } from "./functional_test_case";
import { RemoteChannel } from "./remote_channel";
import { Element } from "@theintern/leadfoot";
declare type EventLog = [string, any, string | null];
declare type MutationLog = [string, string | null, string | null];
export declare class TurboDriveTestCase extends FunctionalTestCase {
    eventLogChannel: RemoteChannel<EventLog>;
    mutationLogChannel: RemoteChannel<MutationLog>;
    lastBody?: Element;
    beforeTest(): Promise<void>;
    get nextWindowHandle(): Promise<string>;
    nextEventNamed(eventName: string): Promise<any>;
    noNextEventNamed(eventName: string): Promise<boolean>;
    nextEventOnTarget(elementId: string, eventName: string): Promise<any>;
    nextAttributeMutationNamed(elementId: string, attributeName: string): Promise<string | null>;
    get nextBody(): Promise<Element>;
    get changedBody(): Promise<Element | undefined>;
    get visitAction(): Promise<string>;
    drainEventLog(): Promise<void>;
}
export {};
