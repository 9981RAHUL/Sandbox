import { LightningElement, api,wire } from 'lwc';
import {fireEvent} from 'c/pubSub';
import {CurrentPageReference} from 'lightning/navigation';

export default class MeetingRoom extends LightningElement {
 //@api meetingRoomInfo;

 @api meetingRoomInfo = {roomName:'A-01', roomCapacity:'12'}

 @api showRoomInfo = false;

 @wire(CurrentPageReference) pageReference;

 titleClickHandler(){
    const tileClicked = new CustomEvent('tileclick',{detail : this.meetingRoomInfo, bubbles:true});

    this.dispatchEvent(tileClicked);
    fireEvent(this.pageReference,'pubsubtitleclick',this.meetingRoomInfo)
 }
}