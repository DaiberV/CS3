﻿//------------------------------------------------------------------------------
// <auto-generated>
//     Este código fue generado por una herramienta.
//     Versión de runtime:4.0.30319.34014
//
//     Los cambios en este archivo podrían causar un comportamiento incorrecto y se perderán si
//     se vuelve a generar el código.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CS3ComparationClient.SetStrucs {
    using System.Runtime.Serialization;
    using System;
    
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Runtime.Serialization", "4.0.0.0")]
    [System.Runtime.Serialization.DataContractAttribute(Name="SDTClient_SetStrucs", Namespace="CS3HQ")]
    [System.SerializableAttribute()]
    public partial class SDTClient_SetStrucs : object, System.Runtime.Serialization.IExtensibleDataObject, System.ComponentModel.INotifyPropertyChanged {
        
        [System.NonSerializedAttribute()]
        private System.Runtime.Serialization.ExtensionDataObject extensionDataField;
        
        private string TipoField;
        
        private string EstructurasField;
        
        [global::System.ComponentModel.BrowsableAttribute(false)]
        public System.Runtime.Serialization.ExtensionDataObject ExtensionData {
            get {
                return this.extensionDataField;
            }
            set {
                this.extensionDataField = value;
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute(IsRequired=true, EmitDefaultValue=false)]
        public string Tipo {
            get {
                return this.TipoField;
            }
            set {
                if ((object.ReferenceEquals(this.TipoField, value) != true)) {
                    this.TipoField = value;
                    this.RaisePropertyChanged("Tipo");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute(IsRequired=true, EmitDefaultValue=false, Order=1)]
        public string Estructuras {
            get {
                return this.EstructurasField;
            }
            set {
                if ((object.ReferenceEquals(this.EstructurasField, value) != true)) {
                    this.EstructurasField = value;
                    this.RaisePropertyChanged("Estructuras");
                }
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(Name="HQ.BasesDatos.PrcClient_SetEstructurasSoapPort", Namespace="CS3HQ", ConfigurationName="SetStrucs.HQBasesDatosPrcClient_SetEstructurasSoapPort")]
    public interface HQBasesDatosPrcClient_SetEstructurasSoapPort {
        
        // CODEGEN: Se está generando un contrato de mensaje, ya que el nombre de contenedor (HQ.BasesDatos.PrcClient_SetEstructuras.Execute) del mensaje ExecuteRequest no coincide con el valor predeterminado (Execute)
        [System.ServiceModel.OperationContractAttribute(Action="CS3HQaction/hq.basesdatos.APRCCLIENT_SETESTRUCTURAS.Execute", ReplyAction="*")]
        CS3ComparationClient.SetStrucs.ExecuteResponse Execute(CS3ComparationClient.SetStrucs.ExecuteRequest request);
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(WrapperName="HQ.BasesDatos.PrcClient_SetEstructuras.Execute", WrapperNamespace="CS3HQ", IsWrapped=true)]
    public partial class ExecuteRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="CS3HQ", Order=0)]
        public CS3ComparationClient.SetStrucs.SDTClient_SetStrucs[] Sdtclient_setstrucs;
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="CS3HQ", Order=1)]
        public string Cliecod;
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="CS3HQ", Order=2)]
        public string Prodcod;
        
        public ExecuteRequest() {
        }
        
        public ExecuteRequest(CS3ComparationClient.SetStrucs.SDTClient_SetStrucs[] Sdtclient_setstrucs, string Cliecod, string Prodcod) {
            this.Sdtclient_setstrucs = Sdtclient_setstrucs;
            this.Cliecod = Cliecod;
            this.Prodcod = Prodcod;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(WrapperName="HQ.BasesDatos.PrcClient_SetEstructuras.ExecuteResponse", WrapperNamespace="CS3HQ", IsWrapped=true)]
    public partial class ExecuteResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="CS3HQ", Order=0)]
        public string retval;
        
        public ExecuteResponse() {
        }
        
        public ExecuteResponse(string retval) {
            this.retval = retval;
        }
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface HQBasesDatosPrcClient_SetEstructurasSoapPortChannel : CS3ComparationClient.SetStrucs.HQBasesDatosPrcClient_SetEstructurasSoapPort, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class HQBasesDatosPrcClient_SetEstructurasSoapPortClient : System.ServiceModel.ClientBase<CS3ComparationClient.SetStrucs.HQBasesDatosPrcClient_SetEstructurasSoapPort>, CS3ComparationClient.SetStrucs.HQBasesDatosPrcClient_SetEstructurasSoapPort {
        
        public HQBasesDatosPrcClient_SetEstructurasSoapPortClient() {
        }
        
        public HQBasesDatosPrcClient_SetEstructurasSoapPortClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public HQBasesDatosPrcClient_SetEstructurasSoapPortClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public HQBasesDatosPrcClient_SetEstructurasSoapPortClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public HQBasesDatosPrcClient_SetEstructurasSoapPortClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        CS3ComparationClient.SetStrucs.ExecuteResponse CS3ComparationClient.SetStrucs.HQBasesDatosPrcClient_SetEstructurasSoapPort.Execute(CS3ComparationClient.SetStrucs.ExecuteRequest request) {
            return base.Channel.Execute(request);
        }
        
        public string Execute(CS3ComparationClient.SetStrucs.SDTClient_SetStrucs[] Sdtclient_setstrucs, string Cliecod, string Prodcod) {
            CS3ComparationClient.SetStrucs.ExecuteRequest inValue = new CS3ComparationClient.SetStrucs.ExecuteRequest();
            inValue.Sdtclient_setstrucs = Sdtclient_setstrucs;
            inValue.Cliecod = Cliecod;
            inValue.Prodcod = Prodcod;
            CS3ComparationClient.SetStrucs.ExecuteResponse retVal = ((CS3ComparationClient.SetStrucs.HQBasesDatosPrcClient_SetEstructurasSoapPort)(this)).Execute(inValue);
            return retVal.retval;
        }
    }
}