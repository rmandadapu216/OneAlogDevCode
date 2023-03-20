import { LightningElement } from 'lwc';
import ForeCastAlert from "lightning/alert";
import InforForsecastAlert from '@salesforce/label/c.Alert';

export default class ChildComp extends LightningElement {
   // label={Alert};
    handlealert(){
        ForeCastAlert.open({
        //message: "Please Enter Number Other than Zero",
        message: InforForsecastAlert,
        theme: "error",
        label: "Alert"
     });
    }
}