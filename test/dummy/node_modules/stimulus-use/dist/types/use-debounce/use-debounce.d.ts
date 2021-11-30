import { Controller } from '@hotwired/stimulus';
export interface DebounceOptions {
    wait?: number;
    name?: string;
}
declare class DebounceController extends Controller {
    static debounces: string[] | DebounceOptions[];
}
export declare const useDebounce: (controller: DebounceController, options: DebounceOptions) => void;
export {};
