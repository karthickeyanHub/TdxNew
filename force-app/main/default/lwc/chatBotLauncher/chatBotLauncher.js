// chatBotLauncher.js
import { LightningElement } from 'lwc';

export default class ChatBotLauncher extends LightningElement {
    connectedCallback() {
        // Wait for the liveagent script to be loaded
        this.loadChatBot();
    }

    loadChatBot() {
        const script = document.createElement('script');
        script.src = 'https://yourdomain.lightning.force.com/embeddedservice/yourdeploymentId/embeddedService.js';
        script.onload = () => {
            embedded_svc.boot({
                baseLiveAgentContentURL: 'https://c.la2-c1cs-phx.salesforceliveagent.com/content',
                deploymentId: '04IdL000000E4jhUAC',
                buttonId: '0MjdL000000CwY5SAK',
                orgId: '00DdL00000OPMxB',
                baseLiveAgentURL: 'https://d.la2-c1cs-phx.salesforceliveagent.com/chat',
                eswLiveAgentDevName: 'EmbeddedServiceLiveAgent_Parent04I3x000000L3LdEAK_17d0c6e7a3f',
                isOfflineSupportEnabled: false
            });
        };
        document.body.appendChild(script);
    }
}