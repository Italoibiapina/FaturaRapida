class UtilModel {
  static getNmIniciais(texto) {
    var palavras = texto.split(' ');
    var vIniciais = palavras.length > 1
        ? palavras[0].substring(0, 1).toString().toUpperCase() + palavras[1].substring(0, 1).toString().toUpperCase()
        : palavras[0].substring(0, 2).toString().toUpperCase();
    return vIniciais;
  }
}
