import { StimulusUse } from '../stimulus-use';
export class UseVisibility extends StimulusUse {
    constructor(controller, options = {}) {
        super(controller, options);
        this.observe = () => {
            this.controller.isVisible = !document.hidden;
            document.addEventListener('visibilitychange', this.handleVisibilityChange);
            // triggers initial callback on observe
            this.handleVisibilityChange();
        };
        this.unobserve = () => {
            document.removeEventListener('visibilitychange', this.handleVisibilityChange);
        };
        // private
        this.becomesInvisible = (event) => {
            this.controller.isVisible = false;
            this.call('invisible', event);
            this.log('invisible', { isVisible: false });
            this.dispatch('invisible', { event, isVisible: false });
        };
        this.becomesVisible = (event) => {
            this.controller.isVisible = true;
            this.call('visible', event);
            this.log('visible', { isVisible: true });
            this.dispatch('visible', { event, isVisible: true });
        };
        this.handleVisibilityChange = (event) => {
            if (document.hidden) {
                this.becomesInvisible(event);
            }
            else {
                this.becomesVisible(event);
            }
        };
        this.controller = controller;
        this.enhanceController();
        this.observe();
    }
    enhanceController() {
        const controllerDisconnect = this.controllerDisconnect;
        const disconnect = () => {
            this.unobserve();
            controllerDisconnect();
        };
        Object.assign(this.controller, { disconnect });
    }
}
export const useVisibility = (controller, options = {}) => {
    const observer = new UseVisibility(controller, options);
    return [observer.observe, observer.unobserve];
};
//# sourceMappingURL=use-visibility.js.map