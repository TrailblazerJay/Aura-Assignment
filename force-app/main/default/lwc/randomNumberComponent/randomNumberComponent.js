import { LightningElement } from 'lwc';
export default class RandomNumberComponent extends LightningElement 
{
    randomNumber=Math.floor((Math.random()*1000000)+1);
}