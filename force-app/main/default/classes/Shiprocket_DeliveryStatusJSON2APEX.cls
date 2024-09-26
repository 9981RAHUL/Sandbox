public class Shiprocket_DeliveryStatusJSON2APEX {
    public tracking_data tracking_data{get;set;}
    public class tracking_data{
        public list<shipment_track> shipment_track{get;set;}
    }
    public class shipment_track_activities{
    }
    public class shipment_track{
        public String current_status{get;set;}
        public String awb_code{get;set;}
    }
    public class qc_response{
    }
}