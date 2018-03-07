/* 
 * Objetos y variables para la pantalla de ecommerce
 */
var strTitulo10 = "Color:";
var strTitulo11 = "Talla:";
var strTitulo12 = "No se encontro un sku con las caracteristicas del producto especificado";

/**
 *Representa un importe calculado para la venta
 *@dblImporte es el importe de venta
 **/
function _ImporteVta(){
   this.dblImporte = 0;
   this.dblImpuesto1 = 0;
   this.dblImpuesto2 = 0;
   this.dblImpuesto3 = 0;
   this.dblImpuestoReal1 = 0;
   this.dblImpuestoReal2 = 0;
   this.dblImpuestoReal3 = 0;
   this.dblCantidad = 0;
   this.dblPrecio = 0;
   this.dblPorcDesc = 0;
   this.dblPorcDescGlobal = 0;
   this.dblPrecFijo = 0;
   this.dblExento1 = 0;
   this.dblExento2 = 0;
   this.dblExento3 = 0;
   this.dblImporteReal = 0;
   this.dblPrecioReal = 0;
   this.intDevo = 0;
   this.dblPorcAplica = 0;
   this.intPrecioZeros = 0;
   this.dblImporteDescuento= 0;
   //MLM
   this.dblPuntos= 0;
   this.dblVNegocio= 0;
   this.dblPuntosAplica= 0;
   this.dblVNegocioAplica= 0;
   this.dblPuntosImporte= 0;
   this.dblVNegocioImporte= 0;
   this.bolAplicDescPrec= true;
   this.bolAplicDescPto= true;
   this.bolAplicDescVNego= true;
   this.bolUsoMLM= true;
   //MLM
   this.CalculaImporte = function CalculaImporte(){
      //Calculamos el importe
      this.dblPorcDescGlobal = parseFloat(this.dblPorcDescGlobal);
      this.dblPorcDesc = parseFloat(this.dblPorcDesc);
      var dblPrecioAplica = parseFloat(this.dblPrecio);
      //MLM
      this.dblPuntosAplica= this.dblPuntos;
      this.dblVNegocioAplica= this.dblVNegocio;
      //MLM
      //if(this.dblPrecFijo == 0 || this.intPrecioZeros == 1){
      this.dblPorcAplica = 0;
      if(this.dblPorcDescGlobal> 0 && this.dblPorcDesc > 0){
         if(this.dblPorcDescGlobal> this.dblPorcDesc)this.dblPorcAplica = this.dblPorcDescGlobal;
         if(this.dblPorcDesc> this.dblPorcDescGlobal)this.dblPorcAplica = this.dblPorcDesc;
         if(this.dblPorcDesc == this.dblPorcDescGlobal)this.dblPorcAplica = this.dblPorcDesc;
      }else{
         if(this.dblPorcDescGlobal>0)this.dblPorcAplica = this.dblPorcDescGlobal;
         if(this.dblPorcDesc>0)this.dblPorcAplica = this.dblPorcDesc;
      }
      if(this.dblPorcAplica> 0){
         if(this.bolAplicDescPrec){
            dblPrecioAplica = dblPrecioAplica - (dblPrecioAplica * (this.dblPorcAplica/100));
         }
         //Calculo de descuento en MLM
         if(this.bolAplicDescPto){
            this.dblPuntosAplica= this.dblPuntosAplica - (this.dblPuntosAplica * (this.dblPorcAplica/100));
         }
         if(this.bolAplicDescVNego){
            this.dblVNegocioAplica= this.dblVNegocioAplica - (this.dblVNegocioAplica * (this.dblPorcAplica/100));
         }
      //Calculo de descuento en MLM
      }
      //}
      this.dblImporte = parseFloat(this.dblCantidad) * parseFloat(dblPrecioAplica);
      this.dblImporteReal =parseFloat(this.dblCantidad) * parseFloat(this.dblPrecioReal);
      //Calculamos el descuento
      if(this.dblImporteReal > 0 && (this.dblImporteReal > this.dblImporte)){
         this.dblImporteDescuento=this.dblImporteReal - this.dblImporte;
      }
      //Si es una devolucion
      if(parseInt(this.intDevo) == 1){
         this.dblImporte = this.dblImporte * -1;
      }
      //MLM
      if(this.bolUsoMLM){
         this.dblPuntosImporte= parseFloat(this.dblCantidad) * parseFloat(this.dblPuntosAplica);
         this.dblVNegocioImporte= parseFloat(this.dblCantidad) * parseFloat(this.dblVNegocioAplica);         
      }
      //MLM
      //Validamos si aplica o no el impuesto
      var dblBase1 = this.dblImporte;
      var dblBase2 = this.dblImporte;
      var dblBase3 = this.dblImporte;
      if(parseInt(this.dblExento1) == 1)dblBase1 = 0;
      if(parseInt(this.dblExento2) == 1)dblBase2 = 0;
      if(parseInt(this.dblExento3) == 1)dblBase3 = 0;
      //Calculamos el impuesto
      var tax = new Impuestos(dblTasaVta1,dblTasaVta2,dblTasaVta3,intSImpVta1_2,intSImpVta1_3,intSImpVta2_3);//Objeto para calculo de impuestos
      //Validamos si los precios incluyen impuestos
      if(intPreciosconImp == 1){
         tax.CalculaImpuesto(dblBase1,dblBase2,dblBase3);
      }else{
         tax.CalculaImpuestoMas(dblBase1,dblBase2,dblBase3);
      }
      if(parseInt(this.dblExento1) == 0)this.dblImpuesto1 = tax.dblImpuesto1;
      if(parseInt(this.dblExento2) == 0)this.dblImpuesto2 = tax.dblImpuesto2;
      if(parseInt(this.dblExento3) == 0)this.dblImpuesto3 = tax.dblImpuesto3;
      //Calculamos impuestos de los importes reales
      //Validamos si aplica o no el impuesto para el importe REAL
      var dblBaseReal1 = this.dblImporteReal;
      var dblBaseReal2 = this.dblImporteReal;
      var dblBaseReal3 = this.dblImporteReal;
      if(parseInt(this.dblExento1) == 1)dblBaseReal1 = 0;
      if(parseInt(this.dblExento2) == 1)dblBaseReal2 = 0;
      if(parseInt(this.dblExento3) == 1)dblBaseReal3 = 0;
      //Calculamos el impuesto
      //Validamos si los precios incluyen impuestos
      if(intPreciosconImp == 1){
         tax.CalculaImpuesto(dblBaseReal1,dblBaseReal2,dblBaseReal3);
      }else{
         tax.CalculaImpuestoMas(dblBaseReal1,dblBaseReal2,dblBaseReal3);
      }
      if(parseInt(this.dblExento1) == 0)this.dblImpuestoReal1 = tax.dblImpuesto1;
      if(parseInt(this.dblExento2) == 0)this.dblImpuestoReal2 = tax.dblImpuesto2;
      if(parseInt(this.dblExento3) == 0)this.dblImpuestoReal3 = tax.dblImpuesto3;

      
      if(this.intPrecioZeros == 1){
         this.dblImporteReal =parseFloat(this.dblCantidad) * parseFloat(this.dblPrecio);
      }
      if(intPreciosconImp == 0){
         this.dblImporteReal += this.dblImpuestoReal1 + this.dblImpuestoReal2 + this.dblImpuestoReal3;
         this.dblImporte += this.dblImpuesto1 + this.dblImpuesto2 + this.dblImpuesto3;
      }
      //Quitamos el impuesto al descuento
      if(intPreciosconImp == 1){
         if(this.dblImporteReal > 0){
            var dblTotImpuesto = tax.dblImpuesto1 + tax.dblImpuesto2 + tax.dblImpuesto3;
            var dblTotImpuestoReal = tax.dblImpuestoReal1 + tax.dblImpuestoReal2 + tax.dblImpuestoReal3;
            if(this.dblImporteReal > 0 && (this.dblImporteReal > this.dblImporte)){
               this.dblImporteDescuento= (this.dblImporteReal -  dblTotImpuestoReal) - (this.dblImporte  - dblTotImpuesto);            
            }
         }
      }
   }
}