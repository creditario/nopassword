import { IntersectionComposableController } from './intersection-controller';
export interface IntersectionOptions extends IntersectionObserverInit {
    element?: Element;
    dispatchEvent?: boolean;
    eventPrefix?: boolean | string;
}
export declare const useIntersection: (controller: IntersectionComposableController, options?: IntersectionOptions) => readonly [() => void, () => void];
