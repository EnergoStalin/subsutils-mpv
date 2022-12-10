import { Config } from './Config';
import { Average } from './modules/Average';
import { Translator } from './modules/Translator';
import { Overlay } from './Overlay';

export class SubtitleView {
    private average: Average
    constructor(private overlay: Overlay, private translator: Translator, private config: Config) {
        this.average = new Average(-0.5, mp.get_time)
    }
    
    onSubChanged() {
        let value = mp.get_property('sub-text-ass')

        if (value === null || value === '') {
            this.overlay.hide()
            return
        }

        value = value!.replace(/\\([nN])/, '\\$1')
        let data: string

        try {
            data = this.translator.translate(value)
        } catch (ex) {
            dump(ex)
            return
        }

        this.average.tick()
        this.overlay.setTranslation(data, value)

        mp.set_property_number('sub-delay', this.config.defaultDelay - this.average.tick())

        this.overlay.reveal()
    }
}