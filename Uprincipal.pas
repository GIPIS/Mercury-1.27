unit Uprincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ShellAPI, LCLIntf, PuertoSerie,
  ImgList, StdCtrls, Buttons, UUtiles, UEquipo, MaskEdit, UPresentacion, UExpansion,
  USensor, UPreferencias, ExtCtrls, UDataModule, UCalculoParam,
  UConexionesRemotas, UConexionAuto, UConfiguracionInternet, Types;

const
  WM_ICONTRAY = WM_USER + 1;

type

  { TFprincipal }

  TFprincipal = class(TForm)
    Bevel10: TBevel;
    Bevel102: TBevel;
    Bevel103: TBevel;
    Bevel104: TBevel;
    Bevel105: TBevel;
    Bevel106: TBevel;
    Bevel107: TBevel;
    Bevel108: TBevel;
    Bevel109: TBevel;
    Bevel11: TBevel;
    Bevel110: TBevel;
    Bevel111: TBevel;
    Bevel112: TBevel;
    Bevel113: TBevel;
    Bevel114: TBevel;
    Bevel115: TBevel;
    Bevel116: TBevel;
    Bevel12: TBevel;
    Bevel126: TBevel;
    Bevel127: TBevel;
    Bevel128: TBevel;
    Bevel129: TBevel;
    Bevel13: TBevel;
    Bevel130: TBevel;
    Bevel131: TBevel;
    Bevel132: TBevel;
    Bevel133: TBevel;
    Bevel134: TBevel;
    Bevel135: TBevel;
    Bevel136: TBevel;
    Bevel137: TBevel;
    Bevel138: TBevel;
    Bevel139: TBevel;
    Bevel14: TBevel;
    Bevel140: TBevel;
    Bevel141: TBevel;
    Bevel142: TBevel;
    Bevel143: TBevel;
    Bevel144: TBevel;
    Bevel145: TBevel;
    Bevel146: TBevel;
    Bevel147: TBevel;
    Bevel148: TBevel;
    Bevel149: TBevel;
    Bevel15: TBevel;
    Bevel150: TBevel;
    Bevel151: TBevel;
    Bevel152: TBevel;
    Bevel153: TBevel;
    Bevel154: TBevel;
    Bevel155: TBevel;
    Bevel156: TBevel;
    Bevel157: TBevel;
    Bevel158: TBevel;
    Bevel159: TBevel;
    Bevel16: TBevel;
    Bevel160: TBevel;
    Bevel161: TBevel;
    Bevel162: TBevel;
    Bevel163: TBevel;
    Bevel164: TBevel;
    Bevel165: TBevel;
    Bevel166: TBevel;
    Bevel167: TBevel;
    Bevel168: TBevel;
    Bevel169: TBevel;
    Bevel17: TBevel;
    Bevel170: TBevel;
    Bevel171: TBevel;
    Bevel172: TBevel;
    Bevel173: TBevel;
    Bevel174: TBevel;
    Bevel175: TBevel;
    Bevel176: TBevel;
    Bevel177: TBevel;
    Bevel178: TBevel;
    Bevel179: TBevel;
    Bevel18: TBevel;
    Bevel180: TBevel;
    Bevel181: TBevel;
    Bevel182: TBevel;
    Bevel183: TBevel;
    Bevel184: TBevel;
    Bevel185: TBevel;
    Bevel186: TBevel;
    Bevel187: TBevel;
    Bevel188: TBevel;
    Bevel189: TBevel;
    Bevel19: TBevel;
    Bevel190: TBevel;
    Bevel191: TBevel;
    Bevel192: TBevel;
    Bevel193: TBevel;
    Bevel194: TBevel;
    Bevel195: TBevel;
    Bevel196: TBevel;
    Bevel197: TBevel;
    Bevel198: TBevel;
    Bevel199: TBevel;
    Bevel20: TBevel;
    Bevel200: TBevel;
    Bevel201: TBevel;
    Bevel202: TBevel;
    Bevel203: TBevel;
    Bevel204: TBevel;
    Bevel205: TBevel;
    Bevel206: TBevel;
    Bevel207: TBevel;
    Bevel208: TBevel;
    Bevel209: TBevel;
    Bevel21: TBevel;
    Bevel210: TBevel;
    Bevel211: TBevel;
    Bevel212: TBevel;
    Bevel213: TBevel;
    Bevel214: TBevel;
    Bevel215: TBevel;
    Bevel216: TBevel;
    Bevel217: TBevel;
    Bevel218: TBevel;
    Bevel219: TBevel;
    Bevel22: TBevel;
    Bevel220: TBevel;
    Bevel221: TBevel;
    Bevel222: TBevel;
    Bevel223: TBevel;
    Bevel224: TBevel;
    Bevel225: TBevel;
    Bevel226: TBevel;
    Bevel227: TBevel;
    Bevel228: TBevel;
    Bevel229: TBevel;
    Bevel23: TBevel;
    Bevel230: TBevel;
    Bevel231: TBevel;
    Bevel232: TBevel;
    Bevel233: TBevel;
    Bevel234: TBevel;
    Bevel235: TBevel;
    Bevel236: TBevel;
    Bevel237: TBevel;
    Bevel238: TBevel;
    Bevel239: TBevel;
    Bevel24: TBevel;
    Bevel240: TBevel;
    Bevel241: TBevel;
    Bevel242: TBevel;
    Bevel243: TBevel;
    Bevel244: TBevel;
    Bevel245: TBevel;
    Bevel246: TBevel;
    Bevel247: TBevel;
    Bevel248: TBevel;
    Bevel249: TBevel;
    Bevel25: TBevel;
    Bevel250: TBevel;
    Bevel251: TBevel;
    Bevel252: TBevel;
    Bevel253: TBevel;
    Bevel254: TBevel;
    Bevel255: TBevel;
    Bevel256: TBevel;
    Bevel257: TBevel;
    Bevel258: TBevel;
    Bevel259: TBevel;
    Bevel26: TBevel;
    Bevel260: TBevel;
    Bevel261: TBevel;
    Bevel262: TBevel;
    Bevel263: TBevel;
    Bevel264: TBevel;
    Bevel265: TBevel;
    Bevel266: TBevel;
    Bevel267: TBevel;
    Bevel268: TBevel;
    Bevel269: TBevel;
    Bevel27: TBevel;
    Bevel270: TBevel;
    Bevel271: TBevel;
    Bevel272: TBevel;
    Bevel273: TBevel;
    Bevel274: TBevel;
    Bevel275: TBevel;
    Bevel276: TBevel;
    Bevel277: TBevel;
    Bevel278: TBevel;
    Bevel279: TBevel;
    Bevel28: TBevel;
    Bevel280: TBevel;
    Bevel281: TBevel;
    Bevel282: TBevel;
    Bevel283: TBevel;
    Bevel284: TBevel;
    Bevel285: TBevel;
    Bevel286: TBevel;
    Bevel287: TBevel;
    Bevel288: TBevel;
    Bevel289: TBevel;
    Bevel29: TBevel;
    Bevel290: TBevel;
    Bevel291: TBevel;
    Bevel292: TBevel;
    Bevel293: TBevel;
    Bevel294: TBevel;
    Bevel295: TBevel;
    Bevel296: TBevel;
    Bevel297: TBevel;
    Bevel298: TBevel;
    Bevel299: TBevel;
    Bevel3: TBevel;
    Bevel30: TBevel;
    Bevel300: TBevel;
    Bevel301: TBevel;
    Bevel302: TBevel;
    Bevel303: TBevel;
    Bevel304: TBevel;
    Bevel305: TBevel;
    Bevel306: TBevel;
    Bevel307: TBevel;
    Bevel308: TBevel;
    Bevel309: TBevel;
    Bevel31: TBevel;
    Bevel310: TBevel;
    Bevel311: TBevel;
    Bevel312: TBevel;
    Bevel313: TBevel;
    Bevel314: TBevel;
    Bevel315: TBevel;
    Bevel316: TBevel;
    Bevel317: TBevel;
    Bevel318: TBevel;
    Bevel319: TBevel;
    Bevel32: TBevel;
    Bevel320: TBevel;
    Bevel321: TBevel;
    Bevel322: TBevel;
    Bevel323: TBevel;
    Bevel324: TBevel;
    Bevel325: TBevel;
    Bevel326: TBevel;
    Bevel327: TBevel;
    Bevel328: TBevel;
    Bevel329: TBevel;
    Bevel33: TBevel;
    Bevel330: TBevel;
    Bevel331: TBevel;
    Bevel332: TBevel;
    Bevel333: TBevel;
    Bevel334: TBevel;
    Bevel335: TBevel;
    Bevel34: TBevel;
    Bevel35: TBevel;
    Bevel36: TBevel;
    Bevel37: TBevel;
    Bevel38: TBevel;
    Bevel39: TBevel;
    Bevel4: TBevel;
    Bevel40: TBevel;
    Bevel41: TBevel;
    Bevel42: TBevel;
    Bevel43: TBevel;
    Bevel44: TBevel;
    Bevel45: TBevel;
    Bevel46: TBevel;
    Bevel47: TBevel;
    Bevel48: TBevel;
    Bevel49: TBevel;
    Bevel5: TBevel;
    Bevel50: TBevel;
    Bevel51: TBevel;
    Bevel52: TBevel;
    Bevel53: TBevel;
    Bevel54: TBevel;
    Bevel55: TBevel;
    Bevel56: TBevel;
    Bevel57: TBevel;
    Bevel58: TBevel;
    Bevel59: TBevel;
    Bevel6: TBevel;
    Bevel60: TBevel;
    Bevel61: TBevel;
    Bevel62: TBevel;
    Bevel63: TBevel;
    Bevel64: TBevel;
    Bevel65: TBevel;
    Bevel7: TBevel;
    Bevel75: TBevel;
    Bevel76: TBevel;
    Bevel77: TBevel;
    Bevel78: TBevel;
    Bevel79: TBevel;
    Bevel8: TBevel;
    Bevel80: TBevel;
    Bevel84: TBevel;
    Bevel85: TBevel;
    Bevel86: TBevel;
    Bevel87: TBevel;
    Bevel88: TBevel;
    Bevel89: TBevel;
    Bevel9: TBevel;
    Bevel90: TBevel;
    Bevel91: TBevel;
    Bevel92: TBevel;
    Bevel93: TBevel;
    Bevel94: TBevel;
    Bevel95: TBevel;
    Bevel96: TBevel;
    Bevel97: TBevel;
    Bevel98: TBevel;
    cbSensores: TComboBox;
    cbSensores1: TComboBox;
    cbSensores2: TComboBox;
    cbSensores3: TComboBox;
    GroupBox10: TGroupBox;
    GroupBox11: TGroupBox;
    GroupBox12: TGroupBox;
    GroupBox13: TGroupBox;
    GroupBox14: TGroupBox;
    GroupBox15: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox9: TGroupBox;
    GroupBoxCan14: TGroupBox;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    LConfig00: TLabel;
    LConfig01: TLabel;
    LConfig02: TLabel;
    LConfig03: TLabel;
    LConfig04: TLabel;
    LConfig05: TLabel;
    LConfig06: TLabel;
    LConfig07: TLabel;
    LConfig08: TLabel;
    LConfig09: TLabel;
    LConfig10: TLabel;
    LConfig11: TLabel;
    LConfig12: TLabel;
    LConfig13: TLabel;
    LConfig14: TLabel;
    LConfig15: TLabel;
    LConfig16: TLabel;
    LConfig23: TLabel;
    LConfig24: TLabel;
    LConfig18: TLabel;
    LConfig19: TLabel;
    LConfig20: TLabel;
    LConfig21: TLabel;
    LConfig22: TLabel;
    LConfig25: TLabel;
    LConfig26: TLabel;

    LConfig27: TLabel;
    LConfig28: TLabel;
    LConfig29: TLabel;
    LConfig30: TLabel;
    LConfig31: TLabel;
    LConfig32: TLabel;
    LConfig33: TLabel;
    LConfig34: TLabel;
    LConfig35: TLabel;
    LConfig17: TLabel;
    LDescConfig00: TLabel;
    LDescConfig01: TLabel;
    LDescConfig02: TLabel;
    LDescConfig03: TLabel;
    LDescConfig04: TLabel;
    LDescConfig05: TLabel;
    LDescConfig06: TLabel;
    LDescConfig07: TLabel;
    LDescConfig08: TLabel;
    LDescConfig09: TLabel;
    LDescConfig26: TLabel;
    LDescConfig25: TLabel;
    LDescConfig24: TLabel;
    LDescConfig23: TLabel;
    LDescConfig18: TLabel;
    LDescConfig19: TLabel;

    LDescConfig20: TLabel;
    LDescConfig21: TLabel;
    LDescConfig22: TLabel;
    LDescConfig35: TLabel;
    LDescConfig10: TLabel;
    LDescConfig34: TLabel;
    LDescConfig33: TLabel;
    LDescConfig32: TLabel;
    LDescConfig27: TLabel;
    LDescConfig28: TLabel;
    LDescConfig29: TLabel;
    LDescConfig30: TLabel;
    LDescConfig31: TLabel;
    LDescConfig11: TLabel;
    LDescConfig12: TLabel;
    LDescConfig13: TLabel;
    LDescConfig14: TLabel;
    LDescConfig15: TLabel;
    LDescConfig16: TLabel;
    LDescConfig17: TLabel;
    LDescripcionCan00: TLabel;
    LDescripcionCan01: TLabel;
    LDescripcionCan02: TLabel;
    LDescripcionCan03: TLabel;
    LDescripcionCan04: TLabel;
    LDescripcionCan05: TLabel;
    LDescripcionCan06: TLabel;
    LDescripcionCan07: TLabel;
    LDescripcionCanDig00: TLabel;
    LDescripcionCan08: TLabel;
    LDescripcion16: TLabel;
    LDescripcion17: TLabel;
    LDescripcion18: TLabel;
    LDescripcionCan17: TLabel;
    LDescripcionCan09: TLabel;
    LDescripcionCan18: TLabel;
    LDescripcionCan19: TLabel;
    LDescripcionCan20: TLabel;
    LDescripcionCan21: TLabel;
    LDescripcionCan22: TLabel;
    LDescripcionCan23: TLabel;
    LDescripcionCan24: TLabel;
    LDescripcionCan25: TLabel;
    LDescripcionCan26: TLabel;
    LDescripcionCan27: TLabel;
    LDescripcionCan10: TLabel;
    LDescripcionCan28: TLabel;
    LDescripcionCan29: TLabel;
    LDescripcionCan30: TLabel;
    LDescripcionCan31: TLabel;
    LDescripcionCan11: TLabel;
    LDescripcionCan12: TLabel;
    LDescripcionCan13: TLabel;
    LDescripcionCan14: TLabel;
    LDescripcionCan15: TLabel;
    LDescripcionCan16: TLabel;
    LDescripcionCanDig02: TLabel;
    LDescripcionCanDig03: TLabel;
    LDescripcionCanDig01: TLabel;
    LDescripcionParam1: TLabel;
    LDescripcionParam2: TLabel;
    LDescripcionParam3: TLabel;
    LDescripcionParam4: TLabel;
    LDescripcionParam5: TLabel;
    LNombreCanal09: TLabel;
    LNombreCanal10: TLabel;
    LNombreCanal11: TLabel;
    LNombreCanal12: TLabel;
    LNombreCanal13: TLabel;
    LNombreCanal14: TLabel;
    LNombreCanal15: TLabel;
    LNombreCanal16: TLabel;
    LNombreCanal17: TLabel;
    LNombreCanal18: TLabel;
    LNombreCanal19: TLabel;
    LNombreCanal20: TLabel;
    LNombreCanal21: TLabel;
    LNombreCanal22: TLabel;
    LNombreCanal23: TLabel;
    LNombreCanal24: TLabel;
    LNombreCanal25: TLabel;
    LNombreCanal26: TLabel;
    LNombreCanal27: TLabel;
    LNombreCanal28: TLabel;
    LNombreCanal29: TLabel;
    LNombreCanal30: TLabel;
    LNombreCanal31: TLabel;
    LNombreCanal32: TLabel;
    LNombreCanal33: TLabel;
    LNombreCanal34: TLabel;
    LNombreCanal35: TLabel;
    LNombreCanal36: TLabel;
    LUnidad10: TLabel;
    LUnidad11: TLabel;
    LUnidad12: TLabel;
    LUnidad13: TLabel;
    LUnidad14: TLabel;
    LUnidad15: TLabel;
    LUnidadCan00: TLabel;
    LUnidadCan01: TLabel;
    LUnidadCan02: TLabel;
    LUnidadCan03: TLabel;
    LUnidadCan04: TLabel;
    LUnidadCan05: TLabel;
    LUnidadCan06: TLabel;
    LUnidadCan07: TLabel;
    LUnidadCan24: TLabel;
    LUnidadCan25: TLabel;
    LUnidadCan26: TLabel;
    LUnidadCan27: TLabel;
    LUnidadCan28: TLabel;
    LUnidadCan29: TLabel;
    LUnidadCan30: TLabel;
    LUnidadCan31: TLabel;
    LUnidadDigCan00: TLabel;
    LUnidadCan08: TLabel;
    LUnidad16: TLabel;
    LUnidad17: TLabel;
    LUnidad18: TLabel;
    LUnidadCan17: TLabel;
    LUnidadCan09: TLabel;
    LUnidadCan18: TLabel;
    LUnidadCan19: TLabel;
    LUnidadCan20: TLabel;
    LUnidadCan21: TLabel;
    LUnidadCan22: TLabel;
    LUnidadCan23: TLabel;
    LUnidadCan10: TLabel;
    LUnidadCan11: TLabel;
    LUnidadCan12: TLabel;
    LUnidadCan13: TLabel;
    LUnidadCan14: TLabel;
    LUnidadCan15: TLabel;
    LUnidadCan16: TLabel;
    LUnidadDigCan01: TLabel;
    LUnidadDigCan02: TLabel;
    LUnidadDigCan03: TLabel;
    LUnidadParam1: TLabel;
    LUnidadParam2: TLabel;
    LUnidadParam3: TLabel;
    LUnidadParam4: TLabel;
    LUnidadParam5: TLabel;
    LValorCan00: TLabel;
    LValorCan01: TLabel;
    LValorCan02: TLabel;
    LValorCan03: TLabel;
    LValorCan04: TLabel;
    LValorCan05: TLabel;
    LValorCan06: TLabel;
    LValorCan07: TLabel;
    LValorCan24: TLabel;
    LValorCan25: TLabel;
    LValorCan26: TLabel;
    LValorCan27: TLabel;
    LValorCan28: TLabel;
    LValorCan29: TLabel;
    LValorCan30: TLabel;
    LValorCan31: TLabel;
    LValorCan08: TLabel;
    LValorCan15: TLabel;
    LValorCan14: TLabel;
    LValorCan13: TLabel;

    LValorCan09: TLabel;
    LValorCan10: TLabel;
    LValorCan11: TLabel;
    LValorCan12: TLabel;
    LValor16: TLabel;
    LValor17: TLabel;
    LValor18: TLabel;
    LValor19: TLabel;
    LValor20: TLabel;
    LValor21: TLabel;
    LValor22: TLabel;
    LValorCan23: TLabel;
    LValorCan22: TLabel;
    LValorCan21: TLabel;
    LValorCan16: TLabel;
    LValorCan17: TLabel;
    LValorCan18: TLabel;

    LValor6: TLabel;
    LValor7: TLabel;
    LValorCan19: TLabel;
    LValorCan20: TLabel;
    LValorCanDig00: TLabel;
    LValorCanDig01: TLabel;
    LValorCanDig02: TLabel;
    LValorCanDig03: TLabel;
    LValorParam1: TLabel;
    LValorParam2: TLabel;
    LValorParam3: TLabel;
    LValorParam4: TLabel;
    LValorParam5: TLabel;
    MenuPrincipal: TMainMenu;
    Archivo1: TMenuItem;
    mEquipo: TMenuItem;
    Opciones1: TMenuItem;
    Ayuda1: TMenuItem;
    mAcerca: TMenuItem;
    N1: TMenuItem;
    mSalir: TMenuItem;
    N2: TMenuItem;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    sbComentario00: TSpeedButton;
    sbComentario01: TSpeedButton;
    sbComentario02: TSpeedButton;
    sbComentario03: TSpeedButton;
    sbComentario04: TSpeedButton;
    sbComentario05: TSpeedButton;
    sbComentario06: TSpeedButton;
    sbComentario07: TSpeedButton;
    sbComentario08: TSpeedButton;
    sbComentario1: TSpeedButton;
    sbComentario16: TSpeedButton;
    sbComentario17: TSpeedButton;
    sbComentario18: TSpeedButton;
    sbComentario19: TSpeedButton;
    sbComentario2: TSpeedButton;
    sbComentario20: TSpeedButton;
    sbComentario21: TSpeedButton;
    sbComentario22: TSpeedButton;
    sbComentario23: TSpeedButton;
    sbComentario24: TSpeedButton;
    sbComentario25: TSpeedButton;
    sbComentario26: TSpeedButton;
    sbComentario27: TSpeedButton;
    sbComentario28: TSpeedButton;
    sbComentario29: TSpeedButton;
    sbComentario3: TSpeedButton;
    sbComentario30: TSpeedButton;
    sbComentario31: TSpeedButton;
    sbComentario32: TSpeedButton;
    sbComentario33: TSpeedButton;
    sbComentario4: TSpeedButton;
    sbComentario5: TSpeedButton;
    sbComentario6: TSpeedButton;
    sbComentario7: TSpeedButton;
    sbComentario8: TSpeedButton;
    sbComentario9: TSpeedButton;
    sbGrafico00: TSpeedButton;
    sbGrafico01: TSpeedButton;
    sbGrafico02: TSpeedButton;
    sbGrafico03: TSpeedButton;
    sbGrafico04: TSpeedButton;
    sbGrafico05: TSpeedButton;
    sbGrafico06: TSpeedButton;
    sbGrafico07: TSpeedButton;
    sbGrafico08: TSpeedButton;
    sbGrafico08_Dup: TSpeedButton;
    sbGrafico08_Dup1: TSpeedButton;
    sbGrafico08_Dup2: TSpeedButton;
    sbGrafico08_Dup3: TSpeedButton;
    sbGrafico09: TSpeedButton;
    sbGrafico09_Dup1: TSpeedButton;
    sbGrafico09_Dup2: TSpeedButton;
    sbGrafico10: TSpeedButton;
    sbGrafico11: TSpeedButton;
    sbGrafico12: TSpeedButton;
    sbGrafico13: TSpeedButton;
    sbGrafico14: TSpeedButton;
    sbGrafico15: TSpeedButton;
    sbGrafico16: TSpeedButton;
    sbGrafico17: TSpeedButton;
    sbGrafico18: TSpeedButton;
    sbGrafico19: TSpeedButton;
    sbGrafico20: TSpeedButton;
    sbGrafico21: TSpeedButton;
    sbGrafico22: TSpeedButton;
    sbGrafico23: TSpeedButton;
    sbGrafico24: TSpeedButton;
    sbGrafico25: TSpeedButton;
    sbGrafico26: TSpeedButton;
    sbGrafico27: TSpeedButton;
    sbGrafico28: TSpeedButton;
    sbGrafico29: TSpeedButton;
    sbGrafico30: TSpeedButton;
    sbGrafico31: TSpeedButton;
    sbGrafico32: TSpeedButton;
    sbGrafico33: TSpeedButton;
    sbGrafico34: TSpeedButton;
    sbGrafico35: TSpeedButton;
    sbGrafico36: TSpeedButton;
    sbGraficoParam1: TSpeedButton;
    sbGraficoParam2: TSpeedButton;
    sbGraficoParam3: TSpeedButton;
    sbGraficoParam4: TSpeedButton;
    sbGraficoParam5: TSpeedButton;
    ScrollBox1: TScrollBox;
    StatusBar: TStatusBar;
    mIraSystemtray: TMenuItem;
    PopupMenuST: TPopupMenu;
    N3: TMenuItem;
    Salir: TMenuItem;
    Restaurar: TMenuItem;
    N4: TMenuItem;
    CoolBar1: TCoolBar;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    tsExp2: TTabSheet;
    tsExp1: TTabSheet;
    tsMon: TTabSheet;
    tsExp0: TTabSheet;
    tbPreferencias1: TToolButton;
    ToolBar1: TToolBar;
    PageControl: TPageControl;
    tsMonitoreo: TTabSheet;
    tsConfiguracion: TTabSheet;
    mTAutomaticas: TMenuItem;
    mAutoConectar: TMenuItem;
    mAutoDescargarDatos: TMenuItem;
    mSalirDescarga: TMenuItem;
    N5: TMenuItem;
    mPuertoSerie: TMenuItem;
    COM1: TMenuItem;
    mAutoConfigurar: TMenuItem;
    mDescargarDatos: TMenuItem;
    mConexionesRemotas: TMenuItem;
    N6: TMenuItem;
    mPreferencias: TMenuItem;
    tsMonitorOnLine: TTabSheet;
    sbConfigurar: TSpeedButton;
    tbCerrar: TToolButton;
    ToolButton2: TToolButton;
    tbDescargar: TToolButton;
    tbIraSystemtray: TToolButton;
    tbPreferencias: TToolButton;
    TimerCierre: TTimer;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    LNombreEquipo: TLabel;
    LHoraEquipo: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    LNbytesEquipo: TLabel;
    LIniMuesEquipo: TLabel;
    Bevel1: TBevel;
    Gauge: TProgressBar;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    eNombre: TEdit;
    Label5: TLabel;
    Label7: TLabel;
    cbIntervalo: TComboBox;
    sbGrabar: TSpeedButton;
    ToolButton4: TToolButton;
    tbGrabar: TToolButton;
    tbParar: TToolButton;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label8: TLabel;
    cbIntervaloCaptura: TComboBox;
    Label9: TLabel;
    cbTipoArchivo: TComboBox;
    Label10: TLabel;
    cbFormatoReporte: TComboBox;
    GroupBox: TGroupBox;
    Label11: TLabel;
    sbDirDatos: TSpeedButton;
    EDirReporte: TEdit;
    GroupBox5: TGroupBox;
    cbReporte: TCheckBox;
    cbReporteWeb: TCheckBox;
    Label12: TLabel;
    Label13: TLabel;
    ImgCaptura: TImage;
    Bevel2: TBevel;
    Label14: TLabel;
    EdirNuevaWeb: TEdit;
    sbSaveWeb: TSpeedButton;
    mCalculos: TMenuItem;
    mSalinidad: TMenuItem;
    mDensidad: TMenuItem;
    mVelocidaddelSonido: TMenuItem;
    ScrollBox: TScrollBox;
    // Nuevos canales visuales (09-15)
    LDescripcion09: TLabel;
    LDescripcion10: TLabel;
    LDescripcion11: TLabel;
    LDescripcion12: TLabel;
    LDescripcion13: TLabel;
    LDescripcion14: TLabel;
    LDescripcion15: TLabel;
    // Nuevos SpeedButtons comentarios para canales 09-15
    sbComentario09: TSpeedButton;
    sbComentario10: TSpeedButton;
    sbComentario11: TSpeedButton;
    sbComentario12: TSpeedButton;
    sbComentario13: TSpeedButton;
    sbComentario14: TSpeedButton;
    sbComentario15: TSpeedButton;
    GroupBox8: TGroupBox;
    LDescripcionParam00: TLabel;
    LUnidadParam00: TLabel;
    LDescripcionParam01: TLabel;
    LUnidadParam01: TLabel;
    LDescripcionParam02: TLabel;
    LUnidadParam02: TLabel;
    sbGraficoParam00: TSpeedButton;
    sbGraficoParam01: TSpeedButton;
    sbGraficoParam02: TSpeedButton;
    LValorParam00: TLabel;
    Bevel66: TBevel;
    LValorParam01: TLabel;
    LValorParam02: TLabel;
    Bevel67: TBevel;
    Bevel68: TBevel;
    Bevel81: TBevel;
    Bevel82: TBevel;
    Bevel83: TBevel;
    Bevel99: TBevel;
    Bevel100: TBevel;
    Bevel101: TBevel;
    Bevel117: TBevel;
    Bevel118: TBevel;
    Bevel119: TBevel;
    Bevel120: TBevel;
    Bevel121: TBevel;
    Bevel122: TBevel;
    Bevel123: TBevel;
    Bevel124: TBevel;
    Bevel125: TBevel;
    SensacinTrmica1: TMenuItem;
    sbGraficoParam03: TSpeedButton;
    LUnidadParam03: TLabel;
    Bevel69: TBevel;
    LValorParam03: TLabel;
    Bevel70: TBevel;
    Bevel71: TBevel;
    LDescripcionParam03: TLabel;
    N7: TMenuItem;
    mTipoDeComunicacion: TMenuItem;
    mDirectaCableSERIE: TMenuItem;
    mTelefoniaCelular: TMenuItem;
    mConexionesTelefonicas: TMenuItem;
    mConexionAuto: TMenuItem;
    mConexionMan: TMenuItem;
    N8: TMenuItem;
    tbConexAutoEN: TToolButton;
    ToolButton7: TToolButton;
    tbDesconectar: TToolButton;
    N9: TMenuItem;
    mDesconectar: TMenuItem;
    mInternet: TMenuItem;
    mConfiguracionDeInternet: TMenuItem;
    N10: TMenuItem;
    tsInternet: TTabSheet;
    mHistorialInternet: TMemo;
    N11: TMenuItem;
    mBorrarHistorial: TMenuItem;
    mConductividadCorr: TMenuItem;
    LDescripcionParam04: TLabel;
    LValorParam04: TLabel;
    LUnidadParam04: TLabel;
    sbGraficoParam04: TSpeedButton;
    Bevel72: TBevel;
    Bevel73: TBevel;
    Bevel74: TBevel;
    procedure Bevel102ChangeBounds(Sender: TObject);
    procedure Bevel107ChangeBounds(Sender: TObject);
    procedure Bevel17ChangeBounds(Sender: TObject);
    procedure Bevel195ChangeBounds(Sender: TObject);
    procedure Bevel236ChangeBounds(Sender: TObject);
    procedure Bevel251ChangeBounds(Sender: TObject);
    procedure Bevel267ChangeBounds(Sender: TObject);
    procedure Bevel27ChangeBounds(Sender: TObject);
    procedure Bevel28ChangeBounds(Sender: TObject);
    procedure Bevel29ChangeBounds(Sender: TObject);
    procedure Bevel39ChangeBounds(Sender: TObject);
    procedure Bevel20ChangeBounds(Sender: TObject);
    procedure Bevel40ChangeBounds(Sender: TObject);
    procedure Bevel76ChangeBounds(Sender: TObject);
    procedure Bevel77ChangeBounds(Sender: TObject);
    procedure Bevel95ChangeBounds(Sender: TObject);
    procedure cbSensores2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GroupBox1Click(Sender: TObject);
    procedure GroupBox6Click(Sender: TObject);
    procedure GroupBox9Click(Sender: TObject);
    procedure GroupBoxCan14Click(Sender: TObject);
    procedure LDescripcionCan00Click(Sender: TObject);
    procedure LUnidadParam00Click(Sender: TObject);
    procedure LValorCan09Click(Sender: TObject);
    procedure LValorCan10Click(Sender: TObject);
    procedure LValorCan13Click(Sender: TObject);
    procedure LValorCan17Click(Sender: TObject);
    procedure LValorCan24Click(Sender: TObject);
    procedure LValorCan00Click(Sender: TObject);
    procedure LValorCan08Click(Sender: TObject);
    procedure mSalirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure IraSystemTray;
    procedure mIraSystemtrayClick(Sender: TObject);
    procedure RestaurarClick(Sender: TObject);
    procedure SalirClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ActualizarInfo(Sender: TObject);
    function CentrarTexto(texto: string; Ancho: integer): string;
    procedure ToolButton4Click(Sender: TObject);
    procedure tsConfiguracionShow(Sender: TObject);
    procedure cbSensoresCloseUp(Sender: TObject);
    procedure cbSensoresExit(Sender: TObject);
    procedure sbConfigurarClick(Sender: TObject);
    procedure CrearListaSensores;
    procedure mAcercaClick(Sender: TObject);
    procedure mDescargarDatosClick(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure ActualizarProgreso(Sender: TObject);
    procedure CargarDatosConfig;
    procedure mAutoDescargarDatosClick(Sender: TObject);
    procedure mAutoConfigurarClick(Sender: TObject);
    procedure mSalirDescargaClick(Sender: TObject);
    procedure PuertoSerieClick(Sender: TObject);
    procedure mPreferenciasClick(Sender: TObject);
    procedure tbExpansionClick(Sender: TObject);

    procedure TimerCierreTimer(Sender: TObject);
    procedure LimpiarMonitor;
    procedure sbGrabarClick(Sender: TObject);
    procedure tsMonitoreoContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: boolean);
    procedure tsMonitorOnLineShow(Sender: TObject);
    procedure sbDirDatosClick(Sender: TObject);
    procedure MonitoreoEnLinea;
    procedure GenerarReporteWeb;
    procedure BotonGraficoCanalClick(Sender: TObject);
    procedure sbComentarioClick(Sender: TObject);
    procedure sbSaveWebClick(Sender: TObject);
    procedure LConfigsClick(Sender: TObject);
    procedure mCalculosParam(Sender: TObject);
    procedure TipoDeComunicacionClick(Sender: TObject);
    procedure mConexionesTelefonicasClick(Sender: TObject);
    procedure mConexionAutoClick(Sender: TObject);
    procedure ConexionManualClick(Sender: TObject);
    procedure ConcectarConRemoto(index: integer;
      AutoDesconecDesc, AutoDesconecConf: boolean);
    procedure DesconcectarConRemoto;
    procedure mDesconectarClick(Sender: TObject);
    procedure ConexionAutomatica(Sender: TObject);
    procedure ONConexionRemota(Sender: TObject);
    procedure ONDesconexionRemota(Sender: TObject);
    procedure mConfiguracionDeInternetClick(Sender: TObject);
    procedure PageControlChanging(Sender: TObject; var AllowChange: boolean);
    procedure PageControlChange(Sender: TObject);
    procedure mHistorialInternetChange(Sender: TObject);
    procedure mBorrarHistorialClick(Sender: TObject);

    // Procedimientos para los nuevos canales visuales (09-15)
    procedure sbGrafico09Click(Sender: TObject);
    procedure sbGrafico10Click(Sender: TObject);
    procedure sbGrafico11Click(Sender: TObject);
    procedure sbGrafico12Click(Sender: TObject);
    procedure sbGrafico13Click(Sender: TObject);
    procedure sbGrafico14Click(Sender: TObject);
    procedure sbGrafico15Click(Sender: TObject);
    procedure sbComentario09Click(Sender: TObject);
    procedure sbComentario10Click(Sender: TObject);
    procedure sbComentario11Click(Sender: TObject);
    procedure sbComentario12Click(Sender: TObject);
    procedure sbComentario13Click(Sender: TObject);
    procedure sbComentario14Click(Sender: TObject);
    procedure sbComentario15Click(Sender: TObject);

  private
    TrayIconData: TNotifyIconData;
    { Private declarations }
  public
    ActualizarCHs: boolean;                  // Carga los sensores al Equipo
    { Public declarations }
    procedure TrayMessage(var Msg: TMessage); message WM_ICONTRAY;
    procedure ActualizarVisibilidadCanales(CantidadCanales: integer);
    procedure InstanciarComponentesFaltantes;
  end;

var
  Fprincipal: TFprincipal;
  PSerie: TPuertoSerie;
  PorPrimerVez: boolean;
  Cerrando: boolean;
  Creando: boolean;
  Equipo: TEquipo;
  // Objeto que realiza toda la intefaze con el equipo fisico
  //Server        : TServer;                  // Objeto que administra la conexin por Internet
  NCanal: integer;
  // Numero del Canal Activo por el ComboBox de Config
  TagOLD: integer;
  OnCambio: boolean;
  IniLine: integer;                  // Ultima linea del log guardada en file

implementation

uses UFormulas, UConexiones;

var
  ActualizarCHs: boolean;                  // Carga los sensores al Equipo

  {$R *.lfm}

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.FormCreate(Sender: TObject);
var
  NewItem: TMenuItem;
  i: integer;
  LComponent: TComponent;
begin
  //show;      

  // Creo la presentaci�n
  FPresentacion := TFPresentacion.Create(Self);
  FPresentacion.Show;
  FPresentacion.Repaint;

  // Configuro las variables globales
  DefaultFormatSettings.DateSeparator := '/';
  DefaultFormatSettings.DecimalSeparator := '.';
  DefaultFormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  DefaultFormatSettings.LongDateFormat := 'dd/mm/yyyy';
  PageControl.ActivePageIndex := 0;
  ScrollBox.VertScrollBar.Position := 0;
  TagOLD := 0;
  GraficosOpen := 0;
  PorPrimerVez := True;
  Cerrando := False;
  OnCambio := False;
  IniLine := 0;
  Creando := True;
  ActualizarCHs := True;
  //SE CREA EL OBJETO ADMINISTRATIVO GLOBAL
  Mercury := TMercury.Crear;
  Equipo := nil;
  //Server                           := nil;

  // Cargo la configuraci�n del programa guardada en el Archivo INI
  FPresentacion.LMensaje.Caption := 'Cargando Configuraci�n...';
  FPresentacion.Repaint;

  //ACA EL PROGRAMA LEE EL ARCHIVO MERCURY.INI Y SACA EL STRING "COM1" QUE SE VA A USAR MAS ADELANTE
  Mercury.CargarConfig;
  Retardo(200);

  // Cargo la config a la aplicaci�n, a las vantanas, etc
  CargarDatosConfig;

  // Inicializo la visibilidad de canales (8 por defecto)
  ActualizarVisibilidadCanales(8);

  // Cargo la configuraci�n de las Comuicaciones Telef�nicas guardada en el Archivo INI
  FPresentacion.LMensaje.Caption := 'Cargando conexiones remotas...';
  FPresentacion.Repaint;
  Mercury.ConexTelefon.CargarConexiones;
  Mercury.ConexAuto.pEnHora := ConexionAutomatica;

  // Cargo la lista de puertos serie en el men�
  mConexionMan.Clear;
  for i := 0 to Mercury.ConexTelefon.NumConex - 1 do
  begin
    NewItem := TMenuItem.Create(Self);
    NewItem.Tag := i;
    NewItem.Checked := False;
    NewItem.Caption := Mercury.ConexTelefon.AConexiones[i].Nombre;
    NewItem.OnClick := ConexionManualClick;
    mConexionMan.Add(NewItem);
  end;
  Retardo(200);

  // Creo la tabla de perioodos de muestreo del Monitoreo en Linea
  TablaTMonitor[0] := 0.45 / 86400;
  TablaTMonitor[1] := 0.9 / 86400;
  TablaTMonitor[2] := 4.9 / 86400;
  TablaTMonitor[3] := 9.9 / 86400;
  TablaTMonitor[4] := 29.9 / 86400;
  TablaTMonitor[5] := 1 / 1440;
  TablaTMonitor[6] := 2 / 1440;
  TablaTMonitor[7] := 5 / 1440;
  TablaTMonitor[8] := 10 / 1440;
  TablaTMonitor[9] := 15 / 1440;
  TablaTMonitor[10] := 20 / 1440;
  TablaTMonitor[11] := 30 / 1440;
  TablaTMonitor[12] := 1 / 24;

  // Creo la tabla de perioodos de muestreo.
  TablaT[0] := 0;
  TablaT[1] := 1;
  TablaT[2] := 2;
  TablaT[3] := 5;
  TablaT[4] := 10;
  TablaT[5] := 60;
  TablaT[6] := 120;
  TablaT[7] := 300;
  TablaT[8] := 600;
  TablaT[9] := 900;
  TablaT[10] := 1800;
  TablaT[11] := 3600;
  TablaT[12] := 5400;
  TablaT[13] := 7200;

  // Obtengo la lista de Puerto serie que tiene la PC
  FPresentacion.LMensaje.Caption := 'Buscando Puertos Serie...';
  FPresentacion.Repaint;
  PSerie := TPuertoSerie.Crear;
  PSerie.CrearListaPuertosSerie;
  Retardo(200);

  // Cargo la lista de puertos serie en el men�
  mPuertoSerie.Clear;
  for i := 0 to PSerie.ListaPorts.Count - 1 do
  begin
    NewItem := TMenuItem.Create(Self);
    NewItem.Checked := False;
    NewItem.Caption := PSerie.ListaPorts.Strings[i];
    NewItem.OnClick := PuertoSerieClick;
    if (PSerie.ListaPorts.Strings[i] = Mercury.PuertoSerie) then NewItem.Checked := True;
    mPuertoSerie.Add(NewItem);
  end;

  // Inicializo el Tipo de Comunicaci�n SERIE O CELULAR
  FPresentacion.LMensaje.Caption := 'Iniciando el motor de comunicaciones ...';
  FPresentacion.Repaint;
  mDirectaCableSERIE.Checked := False;
  mTelefoniaCelular.Checked := False;

  case Mercury.TipoDeComm of
    0: mDirectaCableSERIE.Checked := True;
    1: mTelefoniaCelular.Checked := True;
    2: mInternet.Checked := True;
    else
      mDirectaCableSERIE.Checked := True;
  end;
  Retardo(200);

  // Muestro la ventana de configuracion para seleccionar canales
  FExpansion := TFExpansion.Create(Self);
  try
    FExpansion.ShowModal;
  finally
    FExpansion.Free;
  end;

  // Creo y Configuro el Equipo con 10 canales si es necesario por el tipo de Comunicaci�n
  //VERIFICA SI VALE LA PENA CREAR EL OBJETO FISICO
  //SI TipoDeComm FUESE (SOLO Internet/TCP-IP) SE SALTA TODO ESTO Y NO TOCA LOS PUERTOS SERIE
  //SI ES 0 (CABLE SERIE DIRECTO) O  1 (MODEM) ENTRA 
  if (Mercury.TipoDeComm <> 2) then
  begin
    //TEquipo.crear, 1O ES LA CANTIDAD DE CANALES BASE, Mercury.PuertoSerie EL STRING "COM1"
    //Y TIPO DE COM, EL TIPO DE COMUNICACION
    Equipo :=
      TEquipo.crear(Mercury.NumCanales, Mercury.PuertoSerie, Mercury.TipoDeComm);
    Equipo.ThreadComm.pProgreso := @statusbar.Tag;
    Equipo.ThreadComm.pActualizar := ActualizarInfo;
    Equipo.ThreadComm.pActualProgres := ActualizarProgreso;
    Equipo.ThreadComm.POnConectRemoto := ONConexionRemota;
    Equipo.ThreadComm.POnDesConRemoto := ONDesconexionRemota;
  end;

  // Creo y configuro el Socket si es necesario para porder comunicarme por internet
  //if (Mercury.TipoDeComm = 2) then Server := TServer.Crear(Mercury.Puerto,@mHistorialInternet.Lines);

  // Creo la lista de los sensores que se encuentran el  DirSensores
  FPresentacion.LMensaje.Caption := 'Generando lista de Sensores...';
  FPresentacion.Repaint;
  CrearListaSensores;
  Retardo(200);

  // Configuro las opciones de captura
  tsMonitorOnLineShow(Sender);

  // Libero la Ventana de Presentaci�n (sola se libera despues de 500ms)
  FPresentacion.Timer1.Interval := 500;
  FPresentacion.Timer1.Enabled := True;
  Creando := False;


  // Estado inicial: Canales visibles segun configuracion
  InstanciarComponentesFaltantes;
  ActualizarVisibilidadCanales(Mercury.NumCanales);

  // Asignar eventos a los labels de configuracion (00-35)
  // ESTO ES NECESARIO PARA QUE RESPONDA AL CLICK
  for i := 0 to 35 do
  begin
    LComponent := FindComponent('LConfig' + Format('%.2d', [i]));
    if (LComponent is TLabel) then
    begin
      TLabel(LComponent).Tag := i;
      TLabel(LComponent).OnClick := LConfigsClick;
      TLabel(LComponent).Cursor := crHandPoint;
    end;
  end;

  // Manera de iniciar la ventana Principal Inicio
  if UpCase(Mercury.IniciarMinimizado) = 'S' then
  begin
    Fprincipal.WindowState := wsMinimized;
    Fprincipal.Show;
    exit;
  end;

  if UpCase(Mercury.IniciarTray) = 'S' then
  begin
    IraSystemTray;
    Fprincipal.WindowState := wsMinimized;
    exit;
  end;


  // Prueba de Ocultar la primera solapa
  //PageControl.Pages[0].TabVisible := false;
end;

procedure TFprincipal.GroupBox1Click(Sender: TObject);
begin

end;

procedure TFprincipal.GroupBox6Click(Sender: TObject);
begin

end;

procedure TFprincipal.GroupBox9Click(Sender: TObject);
begin

end;

procedure TFprincipal.GroupBoxCan14Click(Sender: TObject);
begin

end;

procedure TFprincipal.LDescripcionCan00Click(Sender: TObject);
begin

end;

procedure TFprincipal.LUnidadParam00Click(Sender: TObject);
begin

end;

procedure TFprincipal.LValorCan09Click(Sender: TObject);
begin

end;

procedure TFprincipal.LValorCan10Click(Sender: TObject);
begin

end;

procedure TFprincipal.LValorCan13Click(Sender: TObject);
begin
  // Click handler for LValorCan13
end;

procedure TFprincipal.LValorCan17Click(Sender: TObject);
begin

end;

procedure TFprincipal.LValorCan24Click(Sender: TObject);
begin

end;

procedure TFprincipal.LValorCan00Click(Sender: TObject);
begin

end;

procedure TFprincipal.LValorCan08Click(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel29ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel39ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel20ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel40ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel76ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel77ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel95ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.cbSensores2Change(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel107ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel17ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel195ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel236ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel251ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel267ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel27ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel102ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel28ChangeBounds(Sender: TObject);
begin

end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
  AFiles: AFilesOfDir;
begin
  Cerrando := True;

  // Borro todos los archivos del Directorio Temporal
  if DirectoryExists(Mercury.DirTemp) then
  begin
    SetLength(AFiles, 0); // Inicializar el array
    ExtractFilesOfDir(Mercury.DirTemp + '*.*', AFiles);
    for i := 0 to length(AFiles) - 1 do DeleteFile(PChar(Mercury.DirTemp + AFiles[i].Name));
  end;

  // Borro el icono de la barra de tareas
  Shell_NotifyIcon(NIM_DELETE, PNOTIFYICONDATAA(@TrayIconData));
  if (Equipo <> nil) then Equipo.Destruir;
  //if (Server <> nil) then Server.Destroy;
  Mercury.GuardarConfig;
  Mercury.Destruir;

  // Libero la lista de Sensores
  for i := length(ListaSensores) - 1 downto 0 do
  begin
    if Assigned(ListaSensores[i]) then
      ListaSensores[i].Destruir;
  end;
  SetLength(ListaSensores, 0);

  // Libero los Objetos Creados
  PSerie.Destruir;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.CargarDatosConfig;
begin
  if (UpCase(Mercury.AutoDescargarDatos) = 'S') then mAutoDescargarDatos.Checked := True;
  if (UpCase(Mercury.AutoConfigurar) = 'S') then mAutoConfigurar.Checked := True;
  if (UpCase(Mercury.SalirDescarga) = 'S') then mSalirDescarga.Checked := True;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mSalirClick(Sender: TObject);
begin
  Close;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.TrayMessage(var Msg: TMessage);
var
  CursorPos: TPoint;
begin
  case Msg.lParam of
    WM_LBUTTONDOWN:
    begin
      // Restore window on left click
      WindowState := wsNormal;
      Show;
      Shell_NotifyIcon(NIM_DELETE, PNOTIFYICONDATAA(@TrayIconData));
    end;

    WM_RBUTTONDOWN:
    begin
      GetCursorPos(CursorPos);
      PopupMenuST.Popup(CursorPos.X, CursorPos.Y);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.IraSystemTray;
begin
  with TrayIconData do
  begin
    cbSize := SizeOf(TrayIconData);
    hWnd := Handle;
    uID := 0;
    uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
    uCallbackMessage := WM_ICONTRAY;
    hIcon := Application.Icon.Handle;
    StrPCopy(szTip, Caption);
  end;

  Shell_NotifyIcon(NIM_ADD, PNOTIFYICONDATAA(@TrayIconData));
  Hide;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mIraSystemtrayClick(Sender: TObject);
begin
  IraSystemTray;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.RestaurarClick(Sender: TObject);
begin
  WindowState := wsNormal;
  Show;
  Shell_NotifyIcon(NIM_DELETE, PNOTIFYICONDATAA(@TrayIconData));
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.SalirClick(Sender: TObject);
begin
  Close;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.FormActivate(Sender: TObject);
begin
  if not PorPrimerVez then exit;
  PorPrimerVez := False;

  // habilito el bot�n para indicar que est� habilitada la conexi�n auto
  if (Mercury.ConexAuto.intervalo > 0) then
  begin
    tbConexAutoEN.Enabled := True;
    tbConexAutoEN.Hint := 'Conexiones automaticas habilitadas';
  end
  else
  begin
    tbConexAutoEN.Enabled := False;
    tbConexAutoEN.Hint := 'Conexiones automaticas deshabilitadas';
  end;

  // Si estoy en modalidad "Telefonia Celular" habilito los menus de conexiones remotas
  if (Mercury.TipoDeComm = 1) then
  begin
    mConexionesTelefonicas.Enabled := True;
    mConexionAuto.Enabled := True;
    mConexionMan.Enabled := True;
  end;

  // Chequeo los par�metros de la conexi�n autom�tica y habilito la timer para la conexi�n
  Mercury.ConexAuto.ChequearParam;
  Mercury.ConexAuto.CalcularFecha;
  Mercury.ConexAuto.CalcularMomentoConx;

  // Inicio la cuenta regreciva de ser necesario
  if (Mercury.TipoDeComm = 1) and (Mercury.ConexAuto.intervalo > 0) then
    Mercury.ConexAuto.IniciarCuentaRegreciva;

  // Si est� habilitada la conexi�n por internet desabilito todas la paginas.
  if (Mercury.TipoDeComm = 2) then
  begin
    PageControl.ActivePageIndex := 3;
    tsMonitoreo.Enabled := False;
    tsConfiguracion.Enabled := False;
    tsMonitorOnLine.Enabled := False;

    // Activo el Server para que se ponga a escuchar en el puerto predeterminado
    //Server.SrvSocket.Active     := true;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.ActualizarInfo(Sender: TObject);
var
  i, j, k      : integer;
  ExisteSensor : boolean;
  CompName, strDesc, strVal, strUnit, strGraph, strComm, LogFileName: string;
  Comp: TComponent;
  
  //variable que utilizo para poder asignar los valores a los labels de manera correcta
  numAsign: integer;
  TempConfig: array of integer;

begin
  if (Cerrando or Creando) then exit;
  numAsign := 0;

  // Procedimiento que actualiza la info del equipo en la pantalla
  if not Equipo.ThreadComm.ONLine then begin
    StatusBar.Panels[0].Text    := 'Equipo fuera de Linea';
    ActualizarCHs               := true;
   // LimpiarMonitor;
    // if (PageControl.ActivePageIndex = 2) then
    //   if PageControl.Pages[0].TabVisible then PageControl.ActivePageIndex := 0
    //   else PageControl.ActivePageIndex := 1;
    // Desabilito los botones del monitoreo en linea
    sbGrabar.Enabled := false;
    tbGrabar.Enabled := false;
    // Detengo el monitoreo en Linea
    if Mercury.Grabando then sbGrabarClick(Sender);
    exit;
  end;

  // Actualizo el cartel de la barra de estado
  if not Equipo.ThreadComm.DescargarDatos then
    StatusBar.Panels[0].Text := 'Conectado con "' + Equipo.Nombre + '"';

  // Cargo los sensores al equipo
  // DEBUG LOG REMOVED

  if ActualizarCHs and (not Equipo.ThreadComm.ConfigEquipo) then begin
    // DEBUG LOG REMOVED

    // BACKUP CONFIG
    SetLength(TempConfig, Equipo.NumCanales);
    for i := 0 to Equipo.NumCanales - 1 do
      TempConfig[i] := Equipo.Canales[i].Config;

    Equipo.CargarEquipo(Mercury.DirEquipos);

    // RESTORE CONFIG
    for i := 0 to Equipo.NumCanales - 1 do begin
       // Restore only if we had a valid config from serial, or just overwrite?
       // The serial source is the truth for "what is connected".
       // If serial says 12 and INI says 0, we want 12.
       if TempConfig[i] <> 0 then
         Equipo.Canales[i].Config := TempConfig[i];
    end;
    SetLength(TempConfig, 0);

    for i:=0 to Equipo.NumCanales-1 do begin
      ExisteSensor := false; //Flag para determinar si no existe el archivo del sensor
      for j:=0 to length(ListaSensores)-1 do begin
        if (Equipo.Canales[i].Config = ListaSensores[j].Config) then
        begin
          // Asigno el sensor al canal
          Equipo.Canales[i].Asignar(ListaSensores[j]);

          // Chequeo antes de asignar si el sensor no lo tengo en el dir del Equipo
          for k:=0 to length(Equipo.ListaSenDir)-1 do begin
            if Equipo.Canales[i].Config = Equipo.ListaSenDir[k].Config then begin
              Equipo.Canales[i].Asignar(Equipo.ListaSenDir[k]);
              break;
            end;
          end;

          // Me aseguro de no perder la posici�n en la lista
          Equipo.Canales[i].PosLista := ListaSensores[j].PosLista;
          if (i = 8) or (i = 9) then
          if (Equipo.Canales[i].Config = Equipo.Canales[i].ConfigINI) and
             (length(Equipo.Canales[i].DescrINI)>0) then
            Equipo.Canales[i].Descripcion := Equipo.Canales[i].DescrINI;

          // Cambio el flag para indicar que exite el archivo del sensor.
          ExisteSensor := true;
        end;
      end;
 
    ////DEBUG
      //Si no encuentro el archivo del sensor... asigno uno generico ("DATO ORIGINAL")
      if not ExisteSensor then begin
        // Asigno el sensor al canal
        Equipo.Canales[i].Asignar(ListaSensores[1]);

        // Me aseguro de no perder la posici�n en la lista
        Equipo.Canales[i].PosLista := ListaSensores[1].PosLista;
      end;
    end;
    // Me fijo que canal digital Uso para CADA bloque
    for j := 0 to (Equipo.NumCanales div 10) - 1 do begin
      if (j * 10 + 9 < Equipo.NumCanales) and (Equipo.Canales[j * 10 + 9].Config <> 0) then
        Equipo.UsarCH9[j] := True
      else
        Equipo.UsarCH9[j] := False;
    end;

    Equipo.GuardarEquipo(Mercury.DirEquipos);
    Equipo.CargarEquipo(Mercury.DirEquipos);
    ActualizarCHs := False;
    Equipo.ThreadComm.PendingUserConfig := False;  // Ahora LeerConfig puede actualizar de nuevo
  end;

  // Habilito los Botones
  tbDescargar.Enabled := True;
  mDescargarDatos.Enabled := True;
  mConfiguracionDeInternet.Enabled := True;

  // Habilito los Botones para el monitoreo en linea
  if not Mercury.Grabando then
  begin
    sbGrabar.Enabled := True;
    tbGrabar.Enabled := True;
  end;

  // Cargo la Info del Equipo en pantalla
  // Cargo la Info del Equipo en pantalla
  if Equipo.NumCanales > 7 then
    LNombreEquipo.Caption := Equipo.Nombre + Format(' [NC:%d C8:%d]', [Equipo.NumCanales, Equipo.Canales[7].Config])
  else
    LNombreEquipo.Caption := Equipo.Nombre + Format(' [NC:%d]', [Equipo.NumCanales]);
  LHoraEquipo.Caption := FormatDateTime('dd/mm/yyyy hh:nn:ss am/pm', Equipo.Hora);
  LNbytesEquipo.Caption := IntToStr(Equipo.Memoria) + ' bytes';
  Gauge.Position := (Equipo.Memoria * 100) div Equipo.CantMemory;
  LIniMuesEquipo.Caption := FormatDateTime('dd/mm/yyyy hh:nn:ss am/pm', Equipo.iniMuestr) + ' - (int ' + Mercury.GenerarStrTmuest(Equipo.Tmuestreo) + ')';
  //ActualizarCHs := False; // NO BORRAR FLAG AQUI -> Se borra dentro del IF cuando termina la carga


  //IntToStr(Equipo.Tmuestreo div 60)+' min

  // Cargo la info de los canales en pantalla
  // --- INICIO DE LA SECCIÓN DE CARGA DE CANALES ---
  
  // Cargo la info de los canales en pantalla
  // --- INICIO DE LA SECCIÓN DE CARGA DE CANALES ---
  
 
  
  for i := 0 to Equipo.NumCanales - 1 do begin
  
  //  
  //  try
  //    NombreArchivoDebuf := ExtractFilePath(ParamStr(0)) + 'debug_actualizarinfo.txt';
  //    AssignFile(ArchivoDebug, NombreArchivoDebuf); 
  //    try
  //      if FileExists(NombreArchivoDebuf) then Append(ArchivoDebug) else Rewrite(ArchivoDebug);
  //      WriteLn(ArchivoDebug, 'CH' + IntToStr(i) + ': ' + FloatToStr(Equipo.Canales[i].ValorSensor) + '  config: ' + intToStr( Equipo.Canales[i].Config));
  //      CloseFile(ArchivoDebug); 
  //    except
  //    end;
  //  except
  //  end;
    
    // 1. Calcular el valor real del canal
    if Equipo.Canales[i].Config <> 0 then begin
      Equipo.Canales[i].Escala := Equipo.Escala;
      Equipo.Canales[i].ComputarValor(Equipo.Canales[i].ValorSensor);
      
      strVal  := Equipo.Canales[i].ValorReal;
      // Las unidades las busco dinámicamente también, pero el Caption lleva corchetes
      strUnit := '[' + Equipo.Canales[i].Unidad + ']';
      strDesc := Equipo.Canales[i].Descripcion;
      
      // DEBUG: Loguear valores calculados
     
      
      // DEBUG: Mostrar valores calculados
      // if (i=8) or (i=9) then ShowMessage('CH'+IntToStr(i)+' Val:'+strVal+' Unit:'+strUnit+' Desc:'+strDesc);
 
      // DEBUG: Mostrar valores calculados
      // if (i=8) or (i=9) then ShowMessage('CH'+IntToStr(i)+' Val:'+strVal+' Unit:'+strUnit+' Desc:'+strDesc);
 
  end else begin
      strVal  := 'OFF';
      strUnit := '';
      strDesc := ''; // O mantener la anterior? Generalmente OFF implica vacio
    end;

    // LÓGICA DE MAPEO DE COMPONENTES
    // Determinamos si es un canal digital "Especial" (8/9, 18/19...) o Analogico normal
    
    // Indices base 0:
    // Bloque 0: 0-7 Analog, 8-9 Digital (Mapean a Dig00)
    // Bloque 1: 10-17 Analog, 18-19 Digital (Mapean a Dig01)
    
    // Es digital si termina en 8 o 9?
    if ((i mod 10) = 8) or ((i mod 10) = 9) then begin
       // ES CANAL DIGITAL (COMPARTIDO O EXCLUSIVO)
       
       // 1. PRIMERO: OCULTAR SIEMPRE LOS COMPONENTES "ANALOGICOS" CORRESPONDIENTES (08, 09, 18...)
       //    Para evitar que queden valores fantasmas (ej: 5000) si el usuario ve el label equivocado.
       CompName := Format('LValorCan%.2d', [i]);
       Comp := FindComponent(CompName);
       if (Comp is TLabel) then TLabel(Comp).Visible := False; // OCULTAR ANALOGICO

       CompName := Format('LUnidadCan%.2d', [i]);
       Comp := FindComponent(CompName);
       if (Comp is TLabel) then TLabel(Comp).Visible := False; // OCULTAR ANALOGICO

       CompName := Format('LDescripcionCan%.2d', [i]);
       Comp := FindComponent(CompName);
       if (Comp is TLabel) then TLabel(Comp).Visible := False; // OCULTAR ANALOGICO
       
       
       // 2. SEGUNDO: MOSTRAR Y ACTUALIZAR SOLO EL DIGITAL ACTIVO
       //    Si UsarCH9=True -> mostramos terminados en 9.
       //    Si UsarCH9=False -> mostramos terminados en 8.
       if (((i mod 10) =8) or ((i mod 10)=9)) then begin
                 numAsign := numAsign -1;
       end;
       if (((i mod 10) = 9) and Equipo.UsarCH9[i div 10]) or (((i mod 10) = 8) and (not Equipo.UsarCH9[i div 10])) then begin
          // Calculamos el Indice Digital (00, 01, 02...)
          CompName := Format('LValorCanDig%.2d', [i div 10]);
          // --- DEBUG VERBOSO ---
         
          Comp := FindComponent(CompName);
          if (Comp is TLabel) then begin
             TLabel(Comp).Caption := strVal;
             TLabel(Comp).Visible := True; // FORZAR VISIBLE
             TLabel(Comp).BringToFront;
          end else ShowMessage('NO SE ENCONTRO LABEL VALOR: ' + CompName);
          CompName := Format('LUnidadDigCan%.2d', [i div 10]);
          Comp := FindComponent(CompName);
          if (Comp is TLabel) then begin
             TLabel(Comp).Caption := strUnit;
             TLabel(Comp).Visible := True; // FORZAR VISIBLE
             TLabel(Comp).BringToFront;
          end else ShowMessage('NO SE ENCONTRO LABEL UNIDAD: ' + CompName);
          
          CompName := Format('LDescripcionCanDig%.2d', [i div 10]);
          Comp := FindComponent(CompName);
          if (Comp is TLabel) then begin
             TLabel(Comp).Caption := strDesc;
             TLabel(Comp).Visible := True; // FORZAR VISIBLE
             TLabel(Comp).BringToFront;
          end else ShowMessage('NO SE ENCONTRO LABEL DESCRIPCION: ' + CompName);
       end;
       
    end else begin
       // ES CANAL ANALOGICO NORMAL (0-7, 10-17, etc)
       // Aseguar que sean visibles por si acaso



       // VALOR
       
       CompName := Format('LValorCan%.2d', [numAsign]);
       Comp := FindComponent(CompName);
       if (Comp is TLabel) then begin
          TLabel(Comp).Caption := strVal;
          TLabel(Comp).Visible := True;
          TLabel(Comp).BringToFront;
       end;
       
       // UNIDAD
       CompName := Format('LUnidadCan%.2d', [numAsign]);
       Comp := FindComponent(CompName);
       if (Comp is TLabel) then begin
          TLabel(Comp).Caption := strUnit;
          TLabel(Comp).Visible := True;
          TLabel(Comp).BringToFront;
       end;
       
       // DESCRIPCION
       CompName := Format('LDescripcionCan%.2d', [numAsign]);
       Comp := FindComponent(CompName);
       if (Comp is TLabel) then begin
          TLabel(Comp).Caption := strDesc;
          TLabel(Comp).Visible := True;
          TLabel(Comp).BringToFront;
       end;
    end;
    numAsign:=numAsign + 1;
    
  end; // End For
  
 

  // --- FIN DE LA SECCIÓN DE CARGA DE CANALES ---

  // Actualizo la info y el valor de los parametros calculados
  for i:=0 to Equipo.CalcParam.CantParm-1 do begin
    with Equipo.CalcParam.Parametros[i] do begin
      if Calcular = 1 then begin
          // Cargo la info de los valores de entrada temp, cond, profundidad...
        for j:=0 to Nparam-1 do begin
          // me aseguro que el canal est� habilitado
          if (AParam[j].canal >= 0) then begin
            if (Equipo.Canales[AParam[j].canal].Config > 0) then
              AParam[j].valor := Equipo.Canales[AParam[j].canal].ValorNum
            else begin
              // Si falta un par�metro que no es necesario no importa
              if (j<NparamNecesa) then Calcular := 0
              else AParam[j].valor := 0;
            end;
          end
          // Si falta un par�metro que no es necesario no importa
          else AParam[j].valor := 0;
        end;

        // Calculo los par�metros salinidad, densidad.....
        Equipo.CalcParam.CalcularValorParam(i);
      end;

      // Muestro la info de los par�metros calculados cuando es necesario
      if (Calcular = 1) then begin
        case i of
          0 : begin LDescripcionParam00.Caption := Descripcion; LValorParam00.Caption:=ResultCalcStr; LUnidadParam00.Caption:='['+Unidad+']'; sbGraficoParam00.Enabled := false; end; //True
          1 : begin LDescripcionParam01.Caption := Descripcion; LValorParam01.Caption:=ResultCalcStr; LUnidadParam01.Caption:='['+Unidad+']'; sbGraficoParam01.Enabled := false; end; //True
          2 : begin LDescripcionParam02.Caption := Descripcion; LValorParam02.Caption:=ResultCalcStr; LUnidadParam02.Caption:='['+Unidad+']'; sbGraficoParam02.Enabled := false; end; //True
          3 : begin LDescripcionParam03.Caption := Descripcion; LValorParam03.Caption:=ResultCalcStr; LUnidadParam03.Caption:='['+Unidad+']'; sbGraficoParam03.Enabled := false; end; //True
          4 : begin LDescripcionParam04.Caption := Descripcion; LValorParam04.Caption:=ResultCalcStr; LUnidadParam04.Caption:='['+Unidad+']'; sbGraficoParam04.Enabled := false; end; //True
        end;
      end
      else begin
        case i of
          0 : begin LDescripcionParam00.Caption := ''; LValorParam00.Caption:=''; LUnidadParam00.Caption:=''; sbGraficoParam00.Enabled := false; end;
          1 : begin LDescripcionParam01.Caption := ''; LValorParam01.Caption:=''; LUnidadParam01.Caption:=''; sbGraficoParam01.Enabled := false; end;
          2 : begin LDescripcionParam02.Caption := ''; LValorParam02.Caption:=''; LUnidadParam02.Caption:=''; sbGraficoParam02.Enabled := false; end;
          3 : begin LDescripcionParam03.Caption := ''; LValorParam03.Caption:=''; LUnidadParam03.Caption:=''; sbGraficoParam03.Enabled := false; end;
          4 : begin LDescripcionParam04.Caption := ''; LValorParam04.Caption:=''; LUnidadParam04.Caption:=''; sbGraficoParam04.Enabled := false; end;          
        end;
      end;
    end;
  end;

  // Realizo la tareas Predetermindas
  // AutoDescargarDatos
  if Mercury.DescargarDatos then begin
    mDescargarDatosClick(nil);          // Llamo al procedure que tengo para descargar datos.
    Mercury.DescargarDatos := false;    // Borro el Flag.
  end;

  // AutoConfigurar 
  if (Mercury.Configurar and (not Equipo.ThreadComm.DescargarDatos)) then begin
    tsConfiguracionShow(nil);          // Cargo los datos para trasmitir al equipo
    sbConfigurarClick(nil);            // Transmito al equipo los nuevos datos
    Mercury.Configurar := false;
  end;

  // SalirDescarga
  if (Mercury.Salir and (not Equipo.ThreadComm.DescargarDatos)
  and (not Equipo.ThreadComm.ConfigEquipo)) then begin
    Mercury.Salir       := false;      // Me aseguro que no entre mas.
    TimerCierre.Enabled := true;       // Despues de 50ms se cierra la aplicaci�n.
  end;

  // Monitoreo en Linea
  if Mercury.Grabando and (not Mercury.Salir) then MonitoreoEnLinea;


  ///////////////////////////////////////////////////////
  // Actualizo los Graficos de los canales en tiempo real
{  if GraficosOpen >0 then begin
    FGraficoSensor.FechaActual                   := now;
    FGraficoSensor.TimerActualizarSeries.Enabled := true;
  end;}
end;


////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.LimpiarMonitor;
begin
  // Desabilito los botones
  tbDescargar.Enabled := False;
  //  tbGrabar.Enabled               := false;
  mDescargarDatos.Enabled := False;
  mConfiguracionDeInternet.Enabled := False;

  // Limpio la Info del Equipo en pantalla
  LNombreEquipo.Caption := '';
  LHoraEquipo.Caption := '';
  LNbytesEquipo.Caption := '';
  Gauge.Position := 0;
  LIniMuesEquipo.Caption := '';

  // ========= LIMPIEZA EXPLÍCITA DE CANALES 0-15 =========
  // Canales 0-7 (Monitoreo principal)
  LDescripcionCan00.Caption := '';
  LValorCan00.Caption := '';
  LUnidadCan00.Caption := '';
  LDescripcionCan01.Caption := '';
  LValorCan01.Caption := '';
  LUnidadCan01.Caption := '';
  LDescripcionCan02.Caption := '';
  LValorCan02.Caption := '';
  LUnidadCan02.Caption := '';
  LDescripcionCan03.Caption := '';
  LValorCan03.Caption := '';
  LUnidadCan03.Caption := '';
  LDescripcionCan04.Caption := '';
  LValorCan04.Caption := '';
  LUnidadCan04.Caption := '';
  LDescripcionCan05.Caption := '';
  LValorCan05.Caption := '';
  LUnidadCan05.Caption := '';
  LDescripcionCan06.Caption := '';
  LValorCan06.Caption := '';
  LUnidadCan06.Caption := '';
  LDescripcionCan07.Caption := '';
  LValorCan07.Caption := '';
  LUnidadCan07.Caption := '';

  // Canales 8-15 (Expansión 1 - GroupBoxCan14)
  LDescripcionCan08.Caption := '';
  LValorCan08.Caption := '';
  LUnidadCan08.Caption := '';
  LDescripcionCan09.Caption := '';
  LValorCan09.Caption := '';
  LUnidadCan09.Caption := '';
  LDescripcionCan10.Caption := '';
  LValorCan10.Caption := '';
  LUnidadCan10.Caption := '';
  LDescripcionCan11.Caption := '';
  LValorCan11.Caption := '';
  LUnidadCan11.Caption := '';
  LDescripcionCan12.Caption := '';
  LValorCan12.Caption := '';
  LUnidadCan12.Caption := '';
  LDescripcionCan13.Caption := '';
  LValorCan13.Caption := '';
  LUnidadCan13.Caption := '';
  LDescripcionCan14.Caption := '';
  LValorCan14.Caption := '';
  LUnidadCan14.Caption := '';
  LDescripcionCan15.Caption := '';
  LValorCan15.Caption := '';
  LUnidadCan15.Caption := '';
  // ========= FIN LIMPIEZA CANALES =========

  // Limpio la info de los valores calculados
  LDescripcionParam00.Caption := '';
  LValorParam00.Caption := '';
  LUnidadParam00.Caption := '';
  sbGraficoParam00.Enabled := False;
  LDescripcionParam01.Caption := '';
  LValorParam01.Caption := '';
  LUnidadParam01.Caption := '';
  sbGraficoParam01.Enabled := False;
  LDescripcionParam02.Caption := '';
  LValorParam02.Caption := '';
  LUnidadParam02.Caption := '';
  sbGraficoParam02.Enabled := False;
  LDescripcionParam03.Caption := '';
  LValorParam03.Caption := '';
  LUnidadParam03.Caption := '';
  sbGraficoParam03.Enabled := False;
  LDescripcionParam04.Caption := '';
  LValorParam04.Caption := '';
  LUnidadParam04.Caption := '';
  sbGraficoParam04.Enabled := False;

  // Limpio el equipo
  Equipo.Limpiar;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.InstanciarComponentesFaltantes;
var
  DeltaY, TopBase: integer;
begin
  // Asegurar que las pestañas de expansión existan
  if (tsExp2 = nil) and (tsMon.PageControl <> nil) then
  begin
    tsExp2 := TTabSheet.Create(Self);
    tsExp2.PageControl := tsMon.PageControl;
    tsExp2.Name := 'tsExp2';
    tsExp2.Caption := 'Exp 25-32';
    tsExp2.TabVisible := False;
  end;

  // Chequeo si faltan los componentes visuales (indicador de que no estan en el LFM)
  if LConfig09 = nil then
  begin
    // Calculo el espaciado basado en los canales anteriores (07 y 08)
    // Asumo 24 pixels si no puedo calcular, pero trataré de usar LConfig00 y 01
    DeltaY := 24;
    if (LConfig01 <> nil) and (LConfig00 <> nil) then
      DeltaY := LConfig01.Top - LConfig00.Top;

    // --- CONFIGURACION (LConfigXX y LDescConfigXX) ---
    // Uso LConfig07 como base si existe, sino LConfig00 (ajustando top)
    if LConfig08 <> nil then TopBase := LConfig08.Top
    else
      TopBase := 216; // Fallback

    // Canal 09
    LConfig09 := TLabel.Create(Self);
    LConfig09.Parent := LConfig00.Parent;
    LConfig09.Left := LConfig00.Left;
    LConfig09.Top := TopBase + DeltaY;
    LConfig09.AutoSize := False;
    LConfig09.Width := LConfig00.Width;
    LConfig09.Height := LConfig00.Height;
    LConfig09.Alignment := taCenter;
    LConfig09.Font := LConfig00.Font;

    LDescConfig09 := TLabel.Create(Self);
    LDescConfig09.Parent := LDescConfig00.Parent;
    LDescConfig09.Left := LDescConfig00.Left;
    LDescConfig09.Top := TopBase + DeltaY;
    LDescConfig09.AutoSize := False;
    LDescConfig09.Width := LDescConfig00.Width;
    LDescConfig09.Height := LDescConfig00.Height;
    LDescConfig09.Alignment := taCenter;
    LDescConfig09.Font := LDescConfig00.Font;
    LDescConfig09.Color := LDescConfig00.Color;
    LDescConfig09.Transparent := False;

    // Canal 10
    LConfig10 := TLabel.Create(Self);
    LConfig10.Parent := LConfig00.Parent;
    LConfig10.Left := LConfig00.Left;
    LConfig10.Top := TopBase + DeltaY * 2;
    LConfig10.AutoSize := False;
    LConfig10.Width := LConfig00.Width;
    LConfig10.Height := LConfig00.Height;
    LConfig10.Alignment := taCenter;
    LConfig10.Font := LConfig00.Font;

    LDescConfig26 := TLabel.Create(Self);
    LDescConfig26.Parent := LDescConfig00.Parent;
    LDescConfig26.Left := LDescConfig00.Left;
    LDescConfig26.Top := TopBase + DeltaY * 2;
    LDescConfig26.AutoSize := False;
    LDescConfig26.Width := LDescConfig00.Width;
    LDescConfig26.Height := LDescConfig00.Height;
    LDescConfig26.Alignment := taCenter;
    LDescConfig26.Font := LDescConfig00.Font;
    LDescConfig26.Color := LDescConfig00.Color;
    LDescConfig26.Transparent := False;

    // Canal 11
    LConfig11 := TLabel.Create(Self);
    LConfig11.Parent := LConfig00.Parent;
    LConfig11.Left := LConfig00.Left;
    LConfig11.Top := TopBase + DeltaY * 3;
    LConfig11.AutoSize := False;
    LConfig11.Width := LConfig00.Width;
    LConfig11.Height := LConfig00.Height;
    LConfig11.Alignment := taCenter;
    LConfig11.Font := LConfig00.Font;

    LDescConfig25 := TLabel.Create(Self);
    LDescConfig25.Parent := LDescConfig00.Parent;
    LDescConfig25.Left := LDescConfig00.Left;
    LDescConfig25.Top := TopBase + DeltaY * 3;
    LDescConfig25.AutoSize := False;
    LDescConfig25.Width := LDescConfig00.Width;
    LDescConfig25.Height := LDescConfig00.Height;
    LDescConfig25.Alignment := taCenter;
    LDescConfig25.Font := LDescConfig00.Font;
    LDescConfig25.Color := LDescConfig00.Color;
    LDescConfig25.Transparent := False;

    // Canal 12
    LConfig12 := TLabel.Create(Self);
    LConfig12.Parent := LConfig00.Parent;
    LConfig12.Left := LConfig00.Left;
    LConfig12.Top := TopBase + DeltaY * 4;
    LConfig12.AutoSize := False;
    LConfig12.Width := LConfig00.Width;
    LConfig12.Height := LConfig00.Height;
    LConfig12.Alignment := taCenter;
    LConfig12.Font := LConfig00.Font;

    LDescConfig24 := TLabel.Create(Self);
    LDescConfig24.Parent := LDescConfig00.Parent;
    LDescConfig24.Left := LDescConfig00.Left;
    LDescConfig24.Top := TopBase + DeltaY * 4;
    LDescConfig24.AutoSize := False;
    LDescConfig24.Width := LDescConfig00.Width;
    LDescConfig24.Height := LDescConfig00.Height;
    LDescConfig24.Alignment := taCenter;
    LDescConfig24.Font := LDescConfig00.Font;
    LDescConfig24.Color := LDescConfig00.Color;
    LDescConfig24.Transparent := False;

    // Canal 13
    LConfig13 := TLabel.Create(Self);
    LConfig13.Parent := LConfig00.Parent;
    LConfig13.Left := LConfig00.Left;
    LConfig13.Top := TopBase + DeltaY * 5;
    LConfig13.AutoSize := False;
    LConfig13.Width := LConfig00.Width;
    LConfig13.Height := LConfig00.Height;
    LConfig13.Alignment := taCenter;
    LConfig13.Font := LConfig00.Font;

    LDescConfig23 := TLabel.Create(Self);
    LDescConfig23.Parent := LDescConfig00.Parent;
    LDescConfig23.Left := LDescConfig00.Left;
    LDescConfig23.Top := TopBase + DeltaY * 5;
    LDescConfig23.AutoSize := False;
    LDescConfig23.Width := LDescConfig00.Width;
    LDescConfig23.Height := LDescConfig00.Height;
    LDescConfig23.Alignment := taCenter;
    LDescConfig23.Font := LDescConfig00.Font;
    LDescConfig23.Color := LDescConfig00.Color;
    LDescConfig23.Transparent := False;

    // Canal 14
    LConfig14 := TLabel.Create(Self);
    LConfig14.Parent := LConfig00.Parent;
    LConfig14.Left := LConfig00.Left;
    LConfig14.Top := TopBase + DeltaY * 6;
    LConfig14.AutoSize := False;
    LConfig14.Width := LConfig00.Width;
    LConfig14.Height := LConfig00.Height;
    LConfig14.Alignment := taCenter;
    LConfig14.Font := LConfig00.Font;

    LDescConfig18 := TLabel.Create(Self);
    LDescConfig18.Parent := LDescConfig00.Parent;
    LDescConfig18.Left := LDescConfig00.Left;
    LDescConfig18.Top := TopBase + DeltaY * 6;
    LDescConfig18.AutoSize := False;
    LDescConfig18.Width := LDescConfig00.Width;
    LDescConfig18.Height := LDescConfig00.Height;
    LDescConfig18.Alignment := taCenter;
    LDescConfig18.Font := LDescConfig00.Font;
    LDescConfig18.Color := LDescConfig00.Color;
    LDescConfig18.Transparent := False;

    // Canal 15
    LConfig15 := TLabel.Create(Self);
    LConfig15.Parent := LConfig00.Parent;
    LConfig15.Left := LConfig00.Left;
    LConfig15.Top := TopBase + DeltaY * 7;
    LConfig15.AutoSize := False;
    LConfig15.Width := LConfig00.Width;
    LConfig15.Height := LConfig00.Height;
    LConfig15.Alignment := taCenter;
    LConfig15.Font := LConfig00.Font;

    LDescConfig19 := TLabel.Create(Self);
    LDescConfig19.Parent := LDescConfig00.Parent;
    LDescConfig19.Left := LDescConfig00.Left;
    LDescConfig19.Top := TopBase + DeltaY * 7;
    LDescConfig19.AutoSize := False;
    LDescConfig19.Width := LDescConfig00.Width;
    LDescConfig19.Height := LDescConfig00.Height;
    LDescConfig19.Alignment := taCenter;
    LDescConfig19.Font := LDescConfig00.Font;
    LDescConfig19.Color := LDescConfig00.Color;
    LDescConfig19.Transparent := False;


    // --- VISUALIZACION (LValorXX, LUnidadXX, LDescripcionXX, sbGraficoXX, sbComentarioXX) ---
    // Uso LValorCanDig00 como base si existe.
    if LValorCanDig00 <> nil then TopBase := LValorCanDig00.Top
    else
      TopBase := 214;

    // Canal 09 (Visual) - COMENTADO: LValorCan08 ya existe en LFM con GroupBoxCan14 como Parent
    // LValorCan08 := TLabel.Create(Self); LValorCan08.Parent := LValorCan00.Parent;
    // LValorCan08.Left := LValorCan00.Left; LValorCan08.Top := TopBase + DeltaY;
    // LValorCan08.AutoSize := False; LValorCan08.Width := LValorCan00.Width; LValorCan08.Height := LValorCan00.Height;
    // LValorCan08.Alignment := taCenter; LValorCan08.Font := LValorCan00.Font; LValorCan08.Color := LValorCan00.Color; LValorCan08.Transparent := False;

    // COMENTADO: LUnidadCan08 ya existe en LFM con GroupBoxCan14 como Parent (Expansion 1)
    // Este código lo ponía incorrectamente en el parent de Canal 0 (Monitoreo)
    // LUnidadCan08 := TLabel.Create(Self); LUnidadCan08.Parent := LUnidadCan00.Parent;
    // LUnidadCan08.Left := LUnidadCan00.Left; LUnidadCan08.Top := TopBase + DeltaY;
    // LUnidadCan08.AutoSize := False; LUnidadCan08.Width := LUnidadCan00.Width; LUnidadCan08.Height := LUnidadCan00.Height;
    // LUnidadCan08.Alignment := taCenter; LUnidadCan08.Font := LUnidadCan00.Font;

    LDescripcion09 := TLabel.Create(Self);
    LDescripcion09.Parent := LDescripcionCan00.Parent;
    LDescripcion09.Left := LDescripcionCan00.Left;
    LDescripcion09.Top := TopBase + DeltaY;
    LDescripcion09.AutoSize := False;
    LDescripcion09.Width := LDescripcionCan00.Width;
    LDescripcion09.Height := LDescripcionCan00.Height;
    LDescripcion09.Alignment := taCenter;
    LDescripcion09.Font := LDescripcionCan00.Font;

    sbGrafico09 := TSpeedButton.Create(Self);
    sbGrafico09.Parent := sbGrafico00.Parent;
    sbGrafico09.Left := sbGrafico00.Left;
    sbGrafico09.Top := TopBase + DeltaY;
    sbGrafico09.Width := sbGrafico00.Width;
    sbGrafico09.Height := sbGrafico00.Height;
    sbGrafico09.NumGlyphs := sbGrafico00.NumGlyphs;
    sbGrafico09.Flat := sbGrafico00.Flat;

    sbComentario09 := TSpeedButton.Create(Self);
    sbComentario09.Parent := sbComentario00.Parent;
    sbComentario09.Left := sbComentario00.Left;
    sbComentario09.Top := TopBase + DeltaY;
    sbComentario09.Width := sbComentario00.Width;
    sbComentario09.Height := sbComentario00.Height;
    sbComentario09.NumGlyphs := sbComentario00.NumGlyphs;
    sbComentario09.Flat := sbComentario00.Flat;

    sbComentario09.NumGlyphs := sbComentario00.NumGlyphs;
    sbComentario09.Flat := sbComentario00.Flat;

    // Canal 10 - COMENTADO: Esto creaba LValorCan15 con Parent incorrecto (bug copia-pega)
    // LValorCan15 := TLabel.Create(Self); LValorCan15.Parent := LValorCan00.Parent;
    // LValorCan15.Left := LValorCan00.Left; LValorCan15.Top := TopBase + DeltaY*2;
    // LValorCan15.AutoSize := False; LValorCan15.Width := LValorCan00.Width; LValorCan15.Height := LValorCan00.Height;
    // LValorCan15.Alignment := taCenter; LValorCan15.Font := LValorCan00.Font; LValorCan15.Color := LValorCan00.Color; LValorCan15.Transparent := False;

    // COMENTADO: LUnidadCan10 ya existe en LFM
    // LUnidad10 := TLabel.Create(Self); LUnidad10.Parent := LUnidadCan00.Parent;
    // LUnidad10.Left := LUnidadCan00.Left; LUnidad10.Top := TopBase + DeltaY*2;
    // LUnidad10.AutoSize := False; LUnidad10.Width := LUnidadCan00.Width; LUnidad10.Height := LUnidadCan00.Height;
    // LUnidad10.Alignment := taCenter; LUnidad10.Font := LUnidadCan00.Font;

    LDescripcion10 := TLabel.Create(Self);
    LDescripcion10.Parent := LDescripcionCan00.Parent;
    LDescripcion10.Left := LDescripcionCan00.Left;
    LDescripcion10.Top := TopBase + DeltaY * 2;
    LDescripcion10.AutoSize := False;
    LDescripcion10.Width := LDescripcionCan00.Width;
    LDescripcion10.Height := LDescripcionCan00.Height;
    LDescripcion10.Alignment := taCenter;
    LDescripcion10.Font := LDescripcionCan00.Font;

    sbGrafico10 := TSpeedButton.Create(Self);
    sbGrafico10.Parent := sbGrafico00.Parent;
    sbGrafico10.Left := sbGrafico00.Left;
    sbGrafico10.Top := TopBase + DeltaY * 2;
    sbGrafico10.Width := sbGrafico00.Width;
    sbGrafico10.Height := sbGrafico00.Height;
    sbGrafico10.Flat := sbGrafico00.Flat; // Simplifico propiedades

    sbComentario10 := TSpeedButton.Create(Self);
    sbComentario10.Parent := sbComentario00.Parent;
    sbComentario10.Left := sbComentario00.Left;
    sbComentario10.Top := TopBase + DeltaY * 2;
    sbComentario10.Width := sbComentario00.Width;
    sbComentario10.Height := sbComentario00.Height;
    sbComentario10.Flat := sbComentario00.Flat;

    sbComentario10.Width := sbComentario00.Width;
    sbComentario10.Height := sbComentario00.Height;
    sbComentario10.Flat := sbComentario00.Flat;

    // Canal 11 - COMENTADO: Esto creaba LValorCan14 con Parent incorrecto (bug copia-pega)
    // LValorCan14 := TLabel.Create(Self); LValorCan14.Parent := LValorCan00.Parent;
    // LValorCan14.Left := LValorCan00.Left; LValorCan14.Top := TopBase + DeltaY*3;
    // LValorCan14.AutoSize := False; LValorCan14.Width := LValorCan00.Width; LValorCan14.Height := LValorCan00.Height;
    // LValorCan14.Alignment := taCenter; LValorCan14.Font := LValorCan00.Font; LValorCan14.Color := LValorCan00.Color; LValorCan14.Transparent := False;

    // COMENTADO: LUnidadCan11 ya existe en LFM
    // LUnidad11 := TLabel.Create(Self); LUnidad11.Parent := LUnidadCan00.Parent;
    // LUnidad11.Left := LUnidadCan00.Left; LUnidad11.Top := TopBase + DeltaY*3;
    // LUnidad11.AutoSize := False; LUnidad11.Width := LUnidadCan00.Width; LUnidad11.Height := LUnidadCan00.Height;
    // LUnidad11.Alignment := taCenter; LUnidad11.Font := LUnidadCan00.Font;

    LDescripcion11 := TLabel.Create(Self);
    LDescripcion11.Parent := LDescripcionCan00.Parent;
    LDescripcion11.Left := LDescripcionCan00.Left;
    LDescripcion11.Top := TopBase + DeltaY * 3;
    LDescripcion11.AutoSize := False;
    LDescripcion11.Width := LDescripcionCan00.Width;
    LDescripcion11.Height := LDescripcionCan00.Height;
    LDescripcion11.Alignment := taCenter;
    LDescripcion11.Font := LDescripcionCan00.Font;

    sbGrafico11 := TSpeedButton.Create(Self);
    sbGrafico11.Parent := sbGrafico00.Parent;
    sbGrafico11.Left := sbGrafico00.Left;
    sbGrafico11.Top := TopBase + DeltaY * 3;
    sbGrafico11.Width := sbGrafico00.Width;
    sbGrafico11.Height := sbGrafico00.Height;
    sbGrafico11.Flat := sbGrafico00.Flat;

    sbComentario11 := TSpeedButton.Create(Self);
    sbComentario11.Parent := sbComentario00.Parent;
    sbComentario11.Left := sbComentario00.Left;
    sbComentario11.Top := TopBase + DeltaY * 3;
    sbComentario11.Width := sbComentario00.Width;
    sbComentario11.Height := sbComentario00.Height;
    sbComentario11.Flat := sbComentario00.Flat;

    sbComentario11.Width := sbComentario00.Width;
    sbComentario11.Height := sbComentario00.Height;
    sbComentario11.Flat := sbComentario00.Flat;

    // Canal 12 - COMENTADO: Esto creaba LValorCan13 con Parent incorrecto (bug copia-pega)
    // LValorCan13 := TLabel.Create(Self); LValorCan13.Parent := LValorCan00.Parent;
    // LValorCan13.Left := LValorCan00.Left; LValorCan13.Top := TopBase + DeltaY*4;
    // LValorCan13.AutoSize := False; LValorCan13.Width := LValorCan00.Width; LValorCan13.Height := LValorCan00.Height;
    // LValorCan13.Alignment := taCenter; LValorCan13.Font := LValorCan00.Font; LValorCan13.Color := LValorCan00.Color; LValorCan13.Transparent := False;

    // COMENTADO: LUnidadCan12 ya existe en LFM
    // LUnidad12 := TLabel.Create(Self); LUnidad12.Parent := LUnidadCan00.Parent;
    // LUnidad12.Left := LUnidadCan00.Left; LUnidad12.Top := TopBase + DeltaY*4;
    // LUnidad12.AutoSize := False; LUnidad12.Width := LUnidadCan00.Width; LUnidad12.Height := LUnidadCan00.Height;
    // LUnidad12.Alignment := taCenter; LUnidad12.Font := LUnidadCan00.Font;

    LDescripcion12 := TLabel.Create(Self);
    LDescripcion12.Parent := LDescripcionCan00.Parent;
    LDescripcion12.Left := LDescripcionCan00.Left;
    LDescripcion12.Top := TopBase + DeltaY * 4;
    LDescripcion12.AutoSize := False;
    LDescripcion12.Width := LDescripcionCan00.Width;
    LDescripcion12.Height := LDescripcionCan00.Height;
    LDescripcion12.Alignment := taCenter;
    LDescripcion12.Font := LDescripcionCan00.Font;

    sbGrafico12 := TSpeedButton.Create(Self);
    sbGrafico12.Parent := sbGrafico00.Parent;
    sbGrafico12.Left := sbGrafico00.Left;
    sbGrafico12.Top := TopBase + DeltaY * 4;
    sbGrafico12.Width := sbGrafico00.Width;
    sbGrafico12.Height := sbGrafico00.Height;
    sbGrafico12.Flat := sbGrafico00.Flat;

    sbComentario12 := TSpeedButton.Create(Self);
    sbComentario12.Parent := sbComentario00.Parent;
    sbComentario12.Left := sbComentario00.Left;
    sbComentario12.Top := TopBase + DeltaY * 4;
    sbComentario12.Width := sbComentario00.Width;
    sbComentario12.Height := sbComentario00.Height;
    sbComentario12.Flat := sbComentario00.Flat;

    sbComentario12.Width := sbComentario00.Width;
    sbComentario12.Height := sbComentario00.Height;
    sbComentario12.Flat := sbComentario00.Flat;

    // Canal 13 - COMENTADO: LValorCan08 ya existe en LFM (esto era un bug - asignaba a LValorCan08 en lugar de LValorCan13)
    // LValorCan08 := TLabel.Create(Self); LValorCan08.Parent := LValorCan00.Parent;
    // LValorCan08.Left := LValorCan00.Left; LValorCan08.Top := TopBase + DeltaY*5;
    // LValorCan08.AutoSize := False; LValorCan08.Width := LValorCan00.Width; LValorCan08.Height := LValorCan00.Height;
    // LValorCan08.Alignment := taCenter; LValorCan08.Font := LValorCan00.Font; LValorCan08.Color := LValorCan00.Color; LValorCan08.Transparent := False;

    // COMENTADO: LUnidadCan13 ya existe en LFM
    // LUnidad13 := TLabel.Create(Self); LUnidad13.Parent := LUnidadCan00.Parent;
    // LUnidad13.Left := LUnidadCan00.Left; LUnidad13.Top := TopBase + DeltaY*5;
    // LUnidad13.AutoSize := False; LUnidad13.Width := LUnidadCan00.Width; LUnidad13.Height := LUnidadCan00.Height;
    // LUnidad13.Alignment := taCenter; LUnidad13.Font := LUnidadCan00.Font;

    LDescripcion13 := TLabel.Create(Self);
    LDescripcion13.Parent := LDescripcionCan00.Parent;
    LDescripcion13.Left := LDescripcionCan00.Left;
    LDescripcion13.Top := TopBase + DeltaY * 5;
    LDescripcion13.AutoSize := False;
    LDescripcion13.Width := LDescripcionCan00.Width;
    LDescripcion13.Height := LDescripcionCan00.Height;
    LDescripcion13.Alignment := taCenter;
    LDescripcion13.Font := LDescripcionCan00.Font;

    sbGrafico13 := TSpeedButton.Create(Self);
    sbGrafico13.Parent := sbGrafico00.Parent;
    sbGrafico13.Left := sbGrafico00.Left;
    sbGrafico13.Top := TopBase + DeltaY * 5;
    sbGrafico13.Width := sbGrafico00.Width;
    sbGrafico13.Height := sbGrafico00.Height;
    sbGrafico13.Flat := sbGrafico00.Flat;

    sbComentario13 := TSpeedButton.Create(Self);
    sbComentario13.Parent := sbComentario00.Parent;
    sbComentario13.Left := sbComentario00.Left;
    sbComentario13.Top := TopBase + DeltaY * 5;
    sbComentario13.Width := sbComentario00.Width;
    sbComentario13.Height := sbComentario00.Height;
    sbComentario13.Flat := sbComentario00.Flat;

    sbComentario13.Width := sbComentario00.Width;
    sbComentario13.Height := sbComentario00.Height;
    sbComentario13.Flat := sbComentario00.Flat;

    // Canal 14 - COMENTADO: LValorCan09 ya existe en LFM (esto era un bug - asignaba a LValorCan09 en lugar de LValorCan14)
    // LValorCan09 := TLabel.Create(Self); LValorCan09.Parent := LValorCan00.Parent;
    // LValorCan09.Left := LValorCan00.Left; LValorCan09.Top := TopBase + DeltaY*6;
    // LValorCan09.AutoSize := False; LValorCan09.Width := LValorCan00.Width; LValorCan09.Height := LValorCan00.Height;
    // LValorCan09.Alignment := taCenter; LValorCan09.Font := LValorCan00.Font; LValorCan09.Color := LValorCan00.Color; LValorCan09.Transparent := False;

    // COMENTADO: LUnidadCan14 ya existe en LFM
    // LUnidad14 := TLabel.Create(Self); LUnidad14.Parent := LUnidadCan00.Parent;
    // LUnidad14.Left := LUnidadCan00.Left; LUnidad14.Top := TopBase + DeltaY*6;
    // LUnidad14.AutoSize := False; LUnidad14.Width := LUnidadCan00.Width; LUnidad14.Height := LUnidadCan00.Height;
    // LUnidad14.Alignment := taCenter; LUnidad14.Font := LUnidadCan00.Font;

    LDescripcion14 := TLabel.Create(Self);
    LDescripcion14.Parent := LDescripcionCan00.Parent;
    LDescripcion14.Left := LDescripcionCan00.Left;
    LDescripcion14.Top := TopBase + DeltaY * 6;
    LDescripcion14.AutoSize := False;
    LDescripcion14.Width := LDescripcionCan00.Width;
    LDescripcion14.Height := LDescripcionCan00.Height;
    LDescripcion14.Alignment := taCenter;
    LDescripcion14.Font := LDescripcionCan00.Font;

    sbGrafico14 := TSpeedButton.Create(Self);
    sbGrafico14.Parent := sbGrafico00.Parent;
    sbGrafico14.Left := sbGrafico00.Left;
    sbGrafico14.Top := TopBase + DeltaY * 6;
    sbGrafico14.Width := sbGrafico00.Width;
    sbGrafico14.Height := sbGrafico00.Height;
    sbGrafico14.Flat := sbGrafico00.Flat;

    sbComentario14 := TSpeedButton.Create(Self);
    sbComentario14.Parent := sbComentario00.Parent;
    sbComentario14.Left := sbComentario00.Left;
    sbComentario14.Top := TopBase + DeltaY * 6;
    sbComentario14.Width := sbComentario00.Width;
    sbComentario14.Height := sbComentario00.Height;
    sbComentario14.Flat := sbComentario00.Flat;

    sbComentario14.Width := sbComentario00.Width;
    sbComentario14.Height := sbComentario00.Height;
    sbComentario14.Flat := sbComentario00.Flat;

    // Canal 15 - COMENTADO: LValorCan10 ya existe en LFM con GroupBoxCan14 como Parent
    // LValorCan10 := TLabel.Create(Self); LValorCan10.Parent := LValorCan00.Parent;
    // LValorCan10.Left := LValorCan00.Left; LValorCan10.Top := TopBase + DeltaY*7;
    // LValorCan10.AutoSize := False; LValorCan10.Width := LValorCan00.Width; LValorCan10.Height := LValorCan00.Height;
    // LValorCan10.Alignment := taCenter; LValorCan10.Font := LValorCan00.Font; LValorCan10.Color := LValorCan00.Color; LValorCan10.Transparent := False;

    // COMENTADO: LUnidadCan15 ya existe en LFM
    // LUnidad15 := TLabel.Create(Self); LUnidad15.Parent := LUnidadCan00.Parent;
    // LUnidad15.Left := LUnidadCan00.Left; LUnidad15.Top := TopBase + DeltaY*7;
    // LUnidad15.AutoSize := False; LUnidad15.Width := LUnidadCan00.Width; LUnidad15.Height := LUnidadCan00.Height;
    // LUnidad15.Alignment := taCenter; LUnidad15.Font := LUnidadCan00.Font;

    LDescripcion15 := TLabel.Create(Self);
    LDescripcion15.Parent := LDescripcionCan00.Parent;
    LDescripcion15.Left := LDescripcionCan00.Left;
    LDescripcion15.Top := TopBase + DeltaY * 7;
    LDescripcion15.AutoSize := False;
    LDescripcion15.Width := LDescripcionCan00.Width;
    LDescripcion15.Height := LDescripcionCan00.Height;
    LDescripcion15.Alignment := taCenter;
    LDescripcion15.Font := LDescripcionCan00.Font;

    sbGrafico15 := TSpeedButton.Create(Self);
    sbGrafico15.Parent := sbGrafico00.Parent;
    sbGrafico15.Left := sbGrafico00.Left;
    sbGrafico15.Top := TopBase + DeltaY * 7;
    sbGrafico15.Width := sbGrafico00.Width;
    sbGrafico15.Height := sbGrafico00.Height;
    sbGrafico15.Flat := sbGrafico00.Flat;

    sbComentario15 := TSpeedButton.Create(Self);
    sbComentario15.Parent := sbComentario00.Parent;
    sbComentario15.Left := sbComentario00.Left;
    sbComentario15.Top := TopBase + DeltaY * 7;
    sbComentario15.Width := sbComentario00.Width;
    sbComentario15.Height := sbComentario00.Height;
    sbComentario15.Flat := sbComentario00.Flat;

    sbComentario15.Width := sbComentario00.Width;
    sbComentario15.Height := sbComentario00.Height;
    sbComentario15.Flat := sbComentario00.Flat;

    // Force hide all new components by default
    LConfig09.Visible := False;
    LDescConfig09.Visible := False;
    LConfig10.Visible := False;
    LDescConfig26.Visible := False;
    LConfig11.Visible := False;
    LDescConfig25.Visible := False;
    LConfig12.Visible := False;
    LDescConfig24.Visible := False;
    LConfig13.Visible := False;
    LDescConfig23.Visible := False;
    LConfig14.Visible := False;
    LDescConfig18.Visible := False;
    LConfig15.Visible := False;
    LDescConfig19.Visible := False;

    // COMENTADO: Ya no creamos LValorCan10 dinámicamente, no ocultarlo aquí
    // LValorCan10.Visible := False;
    // COMENTADO: LUnidad15 ya no existe, usa LUnidadCan15 desde LFM
    // LUnidad15.Visible := False; LDescripcion15.Visible := False; sbGrafico15.Visible := False; sbComentario15.Visible := False; LNombreCanal15.Visible := False;
    // Hide new LFM labels by default
    LNombreCanal09.Visible := False;
    LNombreCanal10.Visible := False;
    LNombreCanal11.Visible := False;
    LNombreCanal12.Visible := False;
    LNombreCanal13.Visible := False;
    LNombreCanal14.Visible := False;
  end;

  // GHOST BUSTERS: Eliminado porque ahora los labels son legítimos (LNombreCanalXX)
end;

////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
function TFprincipal.CentrarTexto(texto: string; Ancho: integer): string;
var
  k, N: integer;
  auxText: string;
begin
  auxText := Texto;
  N := ((Ancho div 8) - length(texto)) div 2;
  for k := 1 to N do auxText := ' ' + auxText;

  if N > 0 then Result := auxText
  else
    Result := texto;
end;

procedure TFprincipal.ToolButton4Click(Sender: TObject);
begin

end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.tsConfiguracionShow(Sender: TObject);
var
  i: integer;
begin
  // Oculto el ComboBox
  cbSensores.Visible := False;

  // Cargo el Nombre del Equipo
  eNombre.Text := Equipo.Nombre;

  // Averiguo el periodo de muestro para el ComboBox
  cbIntervalo.ItemIndex := 0;
  for i := 0 to length(TablaT) - 1 do
    if (Equipo.Tmuestreo = TablaT[i]) then cbIntervalo.ItemIndex := i;
  // Cargo la info de los canales
  // Canal 0
  LConfig00.Caption := ListaSensores[Equipo.Canales[0].PosLista].Nombre;
  LDescConfig00.Caption :=
    ListaSensores[Equipo.Canales[0].PosLista].Descripcion;
  Equipo.ThreadComm.ConfigCHs[0] := Equipo.Canales[0].Config;
  // Canal 1
  LConfig01.Caption := ListaSensores[Equipo.Canales[1].PosLista].Nombre;
  LDescConfig01.Caption :=
    ListaSensores[Equipo.Canales[1].PosLista].Descripcion;
  Equipo.ThreadComm.ConfigCHs[1] := Equipo.Canales[1].Config;
  // Canal 2
  LConfig02.Caption := ListaSensores[Equipo.Canales[2].PosLista].Nombre;
  LDescConfig02.Caption :=
    ListaSensores[Equipo.Canales[2].PosLista].Descripcion;
  Equipo.ThreadComm.ConfigCHs[2] := Equipo.Canales[2].Config;
  // Canal 3
  LConfig03.Caption := ListaSensores[Equipo.Canales[3].PosLista].Nombre;
  LDescConfig03.Caption :=
    ListaSensores[Equipo.Canales[3].PosLista].Descripcion;
  Equipo.ThreadComm.ConfigCHs[3] := Equipo.Canales[3].Config;
  // Canal 4
  LConfig04.Caption := ListaSensores[Equipo.Canales[4].PosLista].Nombre;
  LDescConfig04.Caption :=
    ListaSensores[Equipo.Canales[4].PosLista].Descripcion;
  Equipo.ThreadComm.ConfigCHs[4] := Equipo.Canales[4].Config;
  // Canal 5
  LConfig05.Caption := ListaSensores[Equipo.Canales[5].PosLista].Nombre;
  LDescConfig05.Caption :=
    ListaSensores[Equipo.Canales[5].PosLista].Descripcion;
  Equipo.ThreadComm.ConfigCHs[5] := Equipo.Canales[5].Config;
  // Canal 6
  LConfig06.Caption := ListaSensores[Equipo.Canales[6].PosLista].Nombre;
  LDescConfig06.Caption :=
    ListaSensores[Equipo.Canales[6].PosLista].Descripcion;
  Equipo.ThreadComm.ConfigCHs[6] := Equipo.Canales[6].Config;
  // Canal 7
  LConfig07.Caption := ListaSensores[Equipo.Canales[7].PosLista].Nombre;
  LDescConfig07.Caption :=
    ListaSensores[Equipo.Canales[7].PosLista].Descripcion;
  Equipo.ThreadComm.ConfigCHs[7] := Equipo.Canales[7].Config;

  // Canales Digitales (Tengo 2 pero lo Uso como uno)
  // Canales Digitales (Tengo 2 pero lo Uso como uno)
  // Canal 8
  if (Equipo.NumCanales > 8) then
  
  begin
    if not Equipo.UsarCH9[0] then
    begin
      LConfig08.Caption := ListaSensores[Equipo.Canales[8].PosLista].Nombre;
      LDescConfig08.Caption :=
        ListaSensores[Equipo.Canales[8].PosLista].Descripcion;
      Equipo.ThreadComm.ConfigCHs[8] := Equipo.Canales[8].Config;
    end
    else
    begin // Canal 9
      if (Equipo.NumCanales > 9) then
      begin
        LConfig08.Caption := ListaSensores[Equipo.Canales[9].PosLista].Nombre;
        LDescConfig08.Caption :=
          ListaSensores[Equipo.Canales[9].PosLista].Descripcion;
        Equipo.ThreadComm.ConfigCHs[9] := Equipo.Canales[9].Config;
      end;
    end;
  end;



  // Desabilito el boton para configurar si el equipo no est� conectado
  if not Equipo.ThreadComm.ONLine then  sbConfigurar.Enabled := False
  else
    sbConfigurar.Enabled := True;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.LConfigsClick(Sender: TObject);
begin
  if (Sender is TLabel) then
  begin
    NCanal := (Sender as TLabel).Tag;
    
    // Si es un canal digital (termina en 8) y UsarCH9 está activo, usar el canal x9
    if ((NCanal mod 10) = 8) and Equipo.UsarCH9[NCanal div 10] then
      NCanal := NCanal + 1;
    // Posiciono el combo sobre el label
    cbSensores.Left := (Sender as TLabel).Left;
    cbSensores.Top  := (Sender as TLabel).Top;
    cbSensores.Parent := (Sender as TLabel).Parent;
    // Si el ancho del label es muy pequeo, quizas dar un ancho minimo al combo
    if (Sender as TLabel).Width > cbSensores.Width then
        cbSensores.Width := (Sender as TLabel).Width;
    
    // Selecciono el item correspondiente a la configuracion actual del canal
    if (NCanal >= 0) and (NCanal < Equipo.NumCanales) then
    begin
       if (Equipo.Canales[NCanal].Config < cbSensores.Items.Count) then
          cbSensores.ItemIndex := Equipo.Canales[NCanal].Config
       else
          cbSensores.ItemIndex := -1;
    end;

    cbSensores.Visible := True;
    cbSensores.BringToFront;
    cbSensores.SetFocus;
    cbSensores.DroppedDown := True;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.cbSensoresCloseUp(Sender: TObject);
var
  descripcion : string;
  SensorSel   : TSensor;
  LConfig     : TLabel;
  LDesc       : TLabel;
  fDbg        : TextFile;
  i           : integer;
begin
  if cbSensores.ItemIndex = -1 then
  begin
    cbSensores.Visible := False;
    exit;
  end;

  // Busco el sensor cuyo Config coincida con el ItemIndex del combo
  // (el combo está ordenado por Config en CrearListaSensores)
  SensorSel := nil;
  for i := 0 to length(ListaSensores) - 1 do begin
    if (ListaSensores[i].Config = cbSensores.ItemIndex) then begin
      SensorSel := ListaSensores[i];
      break;
    end;
  end;
  
  if SensorSel = nil then begin
    ShowMessage('No se encontró sensor con Config=' + IntToStr(cbSensores.ItemIndex));
    cbSensores.Visible := False;
    exit;
  end;

  descripcion := SensorSel.Descripcion;

  // Validaciones: canales 0-7 de cada bloque son analógicos, 8 y 9 son digitales
   if ((NCanal mod 10) <= 7) then
   begin
       // Canal ANALOGICO
       if (SensorSel.Entrada <> 'TENSION') and (SensorSel.Config > 1) then
       begin
          MessageBox(Handle,'El sensor seleccionado corresponde a un canal DIGITAL. Este canal es ANALOGICO.', PChar(Caption), MB_OK or MB_ICONERROR );
          cbSensores.Visible := False;
          exit;
       end;
   end;
   
   // Canal DIGITAL (8 o 9 de cada bloque)
   if ((NCanal mod 10) = 8) or ((NCanal mod 10) = 9) then
   begin
       if (SensorSel.Entrada <> 'PULSO') and (SensorSel.Config > 1) then
       begin
          MessageBox(Handle,'El sensor seleccionado corresponde a un canal ANALOGICO. Este canal es DIGITAL.', PChar(Caption), MB_OK or MB_ICONERROR );
          cbSensores.Visible := False;
          exit;
       end;
   end;

   // Actualizo la UI - LConfig
   // Si NCanal fue ajustado por UsarCH9 (ej: 9 en vez de 8), el label sigue siendo LConfig08
   if ((NCanal mod 10) = 9) and Equipo.UsarCH9[NCanal div 10] then begin
     LConfig := TLabel(FindComponent('LConfig' + Format('%.2d', [NCanal - 1])));
     LDesc   := TLabel(FindComponent('LDescConfig' + Format('%.2d', [NCanal - 1])));
   end else begin
     LConfig := TLabel(FindComponent('LConfig' + Format('%.2d', [NCanal])));
     LDesc   := TLabel(FindComponent('LDescConfig' + Format('%.2d', [NCanal])));
   end;
   If Assigned(LConfig) then LConfig.Caption := cbSensores.Text;
  
   // Actualizo la UI - LDesc (Restaurado con seguridad)
   If Assigned(LDesc) then LDesc.Caption := descripcion;
 
   // Actualizo la configuracion del equipo
   if (NCanal < Equipo.NumCanales) then
   begin
      // Suspend thread to prevent overwriting Config from Serial Port while we save
      if Assigned(Equipo.ThreadComm) then Equipo.ThreadComm.Suspend;
      try
        // DEBUG LOG REMOVED

        // Asignar copia TODAS las propiedades: Config, Descripcion, Unidad,
        // Entrada, Modo, Salida, Decimales, Curva, etc.
        Equipo.Canales[NCanal].Asignar(SensorSel);

        // Proteger la config del usuario contra LeerConfig hasta que confirme
        Equipo.ThreadComm.PendingUserConfig := true;
        
        // DEBUG LOG REMOVED

        // IMPORTANT: Save immediately to disk
        Equipo.GuardarEquipo(Mercury.DirEquipos);

        // DEBUG LOG REMOVED
      finally
        if Assigned(Equipo.ThreadComm) then Equipo.ThreadComm.Resume;
      end;
   end;

   cbSensores.Visible := False;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.cbSensoresExit(Sender: TObject);
begin
  cbSensores.Visible := False;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.sbConfigurarClick(Sender: TObject);
var
  i: byte;
  auxNombre: string[4];
  Qst: byte;
  fDbg: TextFile;
begin
  // Cartel de advertencia
  if (Sender <> nil) then
  begin
    Qst := MessageBox(Handle, 'Advertencia, los datos en la memoria se borrarán.' +
      #13 + '¿Desea continuar?', 'Mercury', // PChar(Caption)
      MB_YESNO or MB_ICONQUESTION);
    if (Qst = 7) then exit; // Presionó "NO"
  end;

  // Cargo el nuevo nombre (Max 4 caracteres)
  auxNombre := '____'; 
  
  if Assigned(eNombre) then
  begin
    for i := 1 to length(eNombre.Text) do 
    begin
        if (i > 4) then break; // Prevenir Buffer Overflow
        if (eNombre.Text[i] <> ' ') then
            auxNombre[i] := eNombre.Text[i];
    end;
  end;
  
  if Assigned(Equipo) and Assigned(Equipo.ThreadComm) then
  begin
     Equipo.ThreadComm.NombreEquipo := auxNombre;
     
     // Cargo el nuevo periodo de muestreo con validación de rango
     if (cbIntervalo.ItemIndex >= 0) and (cbIntervalo.ItemIndex <= 13) then
     begin
        Equipo.ThreadComm.T := TablaT[cbIntervalo.ItemIndex];
     end
     else
     begin
        // Valor por defecto si no hay selección válida (ej: 60 seg)
        Equipo.ThreadComm.T := 60; 
     end;
  end
  else
  begin
     ShowMessage('Error Crítico: El objeto Equipo no está inicializado.');
     Exit;
  end;

  // Cartel de información para que cambie periodo de conexión por internet
  if Assigned(Equipo.ThreadComm.pTmuestreo) and (Equipo.ThreadComm.pTmuestreo^ <> Equipo.ThreadComm.T) then
  begin
    MessageBox(Handle,
      'Al cambiar el periodo de muestreo se debe re-configurar los parámetros ' +
      #13 + 'de conexión por internet, en caso de usarse.', 'Mercury', // PChar(Caption)
      MB_OK or MB_ICONINFORMATION);
  end;  

  // DEBUG LOG REMOVED

  // Borro la Config de Equipo para luego reemplazarla por una Nueva
  if not Equipo.BorrarEquipo(Mercury.DirEquipos) then
     ShowMessage('Advertencia: No se pudo borrar la configuración anterior del equipo.');

  // GUARDAMOS la nueva configuración en disco inmediatamente.
  if not Equipo.GuardarEquipo(Mercury.DirEquipos) then
      ShowMessage('Error al guardar la nueva configuración del equipo.');

  // DEBUG LOG REMOVED

  // Indico al Thread que transfiera los cambios al equipo
  ActualizarCHs := True;
  Equipo.ThreadComm.ConfigEquipo := True;
  // PendingUserConfig se mantiene true para proteger Config durante ActualizarInfo
  PageControl.ActivePageIndex := 0;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.CrearListaSensores;
var
  AFiles: AFilesOfDir;
  i, j: integer;
begin
  ExtractFilesOfDir(Mercury.DirSensores + '*.sen', AFiles);
  SetLength(ListaSensores, length(AFiles) + 2);

  // Creo los sensores B�sicos
  ListaSensores[0] := TSensor.Crear;
  ListaSensores[1] := TSensor.Crear;
  ListaSensores[1].Nombre := 'Dato Original';
  ListaSensores[1].Config := 1;
  ListaSensores[1].Descripcion := 'Dato Original';
  ListaSensores[1].Unidad := '-';
  ListaSensores[1].Entrada := 'PULSO';
  ListaSensores[1].Modo := 'CICLO';
  ListaSensores[1].Salida := 'NUMERO';
  ListaSensores[1].Curva[0].x := 0;
  ListaSensores[1].Curva[0].y := 0;
  ListaSensores[1].Curva[1].x := 65536;
  ListaSensores[1].Curva[1].y := 65536;
  ListaSensores[1].Minimo := 0;
  ListaSensores[1].Maximo := 65536;

  //Cargo cada sensor
  for i := 0 to length(AFiles) - 1 do
  begin
    ListaSensores[i + 2] := TSensor.Crear;
    ListaSensores[i + 2].CargarDeArchivo(Mercury.DirSensores + AFiles[i].Name);
  end;

  // Cargo los nombres de los sensores al ComboBox
  cbSensores.Items.Clear;
  for i := 0 to length(ListaSensores) - 1 do
  begin
    for j := 0 to length(ListaSensores) - 1 do
    begin
      if (ListaSensores[j].Config = i) then
      begin
        ListaSensores[j].PosLista := j;
        cbSensores.Items.Add(ListaSensores[j].Nombre);
      end;
    end;
  end;

  SetLength(AFiles, 0);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mAcercaClick(Sender: TObject);
begin
  // Creo la presentaci�n
  FPresentacion := TFPresentacion.Create(Self);
  FPresentacion.Timer1.Interval := 4000;
  FPresentacion.Timer1.Enabled := True;
  FPresentacion.Showmodal;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mDescargarDatosClick(Sender: TObject);
begin
  // Adapto el sistema para el formato elejido (espa�ol - ingles)

  StatusBar.Panels[0].Text :=
    'Descargando ' + IntToStr(Equipo.Memoria) + ' Bytes...';
  Equipo.ThreadComm.FormatoDescarga := Mercury.FormatoDescarga;
  Equipo.ThreadComm.IndiceFormatoFe := Mercury.IndiceFormatoFe;
  Equipo.ThreadComm.Archivo :=
    Mercury.DirDatos + Equipo.Nombre + '_' + FormatDateTime('dd.mm.yyyy hh.nn', now);
  Equipo.ThreadComm.DescargarDatos := True;

  // Una vez descargados los datos se AutoConfigura al Equipo
  if upCase(Mercury.AutoConfigurar) = 'S' then Mercury.Configurar := True;
  if upCase(Mercury.SalirDescarga) = 'S' then Mercury.Salir := True;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
var
  area: trect;
begin
  if (statusbar.Tag <= 0) then exit;

  area := rect;
  with statusbar do
  begin
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.color := $00DF860D;//clblack;
    area.Right := rect.Left + ((Panel.Width * Tag) div 100);
    Canvas.Fillrect(area);
    canvas.Font.Color := clwhite;
    canvas.Brush.Style := bsclear;
    Canvas.TextOut((rect.Right + rect.Left - canvas.TextExtent(IntToStr(Tag) + '%').cx) div
      2, area.top, IntToStr(Tag) + '%');
  end;
  TagOLD := statusbar.Tag;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.ActualizarProgreso(Sender: TObject);
begin
  Statusbar.Refresh;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mAutoDescargarDatosClick(Sender: TObject);
begin
  if (Sender as TMenuItem).Checked then
  begin
    (Sender as TMenuItem).Checked := False;
    Mercury.AutoDescargarDatos := 'N';
  end
  else
  begin
    (Sender as TMenuItem).Checked := True;
    Mercury.AutoDescargarDatos := 'S';
  end;

  // Cartel de Informac�on
  MessageBox(Handle, 'Debe reiniciar el programa para que ' +
    #13 + 'los cambios tengan efecto.', PChar(Caption), MB_OK or
    MB_ICONINFORMATION);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mAutoConfigurarClick(Sender: TObject);
begin
  if (Sender as TMenuItem).Checked then
  begin
    (Sender as TMenuItem).Checked := False;
    Mercury.AutoConfigurar := 'N';
  end
  else
  begin
    (Sender as TMenuItem).Checked := True;
    Mercury.AutoConfigurar := 'S';
  end;

  // Cartel de Informac�on
  MessageBox(Handle, 'Debe reiniciar el programa para que ' +
    #13 + 'los cambios tengan efecto.', PChar(Caption), MB_OK or
    MB_ICONINFORMATION);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mSalirDescargaClick(Sender: TObject);
begin
  if (Sender as TMenuItem).Checked then
  begin
    (Sender as TMenuItem).Checked := False;
    Mercury.SalirDescarga := 'N';
  end
  else
  begin
    (Sender as TMenuItem).Checked := True;
    Mercury.SalirDescarga := 'S';
  end;

  // Cartel de Informac�on
  MessageBox(Handle, 'Debe reiniciar el programa para que ' +
    #13 + 'los cambios tengan efecto.', PChar(Caption), MB_OK or
    MB_ICONINFORMATION);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.PuertoSerieClick(Sender: TObject);
var
  i: byte;
begin
  // Quito el tilde de todos los items
  for i := 0 to mPuertoSerie.Count - 1 do mPuertoSerie.Items[i].Checked := False;

  // Pongo el tilde
  (Sender as TMenuItem).Checked := True;
  Mercury.PuertoSerie :=
    PSerie.ListaPorts.Strings[(Sender as TMenuItem).MenuIndex];

  // Cartel de Informac�on
  MessageBox(Handle, 'Debe reiniciar el programa para que ' +
    #13 + 'los cambios tengan efecto.', PChar(Caption), MB_OK or
    MB_ICONINFORMATION);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mPreferenciasClick(Sender: TObject);
begin
  FPreferencias := TFPreferencias.Create(self);
  FPreferencias.ShowModal;
end;


////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.TimerCierreTimer(Sender: TObject);
begin
  Close;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.sbGrabarClick(Sender: TObject);
var
  ImgAux: TBitmap;
begin
  ImgAux := TBitmap.Create;

  if not Mercury.Grabando then
  begin
    Mercury.Grabando := True;
    Caption := ' EMAC MERCURY - Monitoreo en Linea';
    sbGrabar.Caption := 'Detener';

    // Asigno la imagen de Stop
    DataModule1.ImageList32x32.GetBitmap(13, ImgAux);
    sbGrabar.Glyph.Assign(ImgAux);

    // Desabilito los objetos para que no se puedan modificar las opciones
    tbGrabar.Enabled := False;
    cbReporte.Enabled := False;
    cbReporteWeb.Enabled := False;
    sbDirDatos.Enabled := False;
    sbSaveWeb.Enabled := False;
    cbFormatoReporte.Enabled := False;
    cbIntervaloCaptura.Enabled := False;
    cbTipoArchivo.Enabled := False;
    tbParar.Enabled := True;

    // Codigo de la Captura
    // Guardo los par�metreos de Monitoreo
    if cbReporte.Checked then Mercury.ReporteSel := 'S'
    else
      Mercury.ReporteSel := 'N';

    if cbReporteWeb.Checked then Mercury.ReporteWebSel := 'S'
    else
      Mercury.ReporteWebSel := 'N';

    Mercury.DirReporte := EDirReporte.Text;
    Mercury.NombreNuevaWeb := EdirNuevaWeb.Text;
    Mercury.FormatoReporte := cbFormatoReporte.ItemIndex;
    Mercury.IntervaloCaptura := cbIntervaloCaptura.ItemIndex;
    Mercury.TipoArchivoReporte := cbTipoArchivo.ItemIndex;

    // Hora del Muestreo
    // Redondeo los segundos
    Mercury.HoraMuestreoLinea := trunc(now * 86400 + 1) / 86400;
  end
  else
  begin
    Mercury.Grabando := False;
    Caption := ' EMAC MERCURY';
    sbGrabar.Caption := 'Capturar';

    // Asigno la imagen de Grabar
    DataModule1.ImageList32x32.GetBitmap(11, ImgAux);
    sbGrabar.Glyph.Assign(ImgAux);

    // Modifico los Botones de la Toolbar
    tbParar.Enabled := False;
    tbGrabar.Enabled := True;
    cbReporte.Enabled := True;
    cbReporteWeb.Enabled := True;
    sbDirDatos.Enabled := True;
    sbSaveWeb.Enabled := True;
    cbFormatoReporte.Enabled := True;
    cbIntervaloCaptura.Enabled := True;
    cbTipoArchivo.Enabled := True;
  end;

  ImgAux.Free;
end;

procedure TFprincipal.tsMonitoreoContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: boolean);
begin

end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.tsMonitorOnLineShow(Sender: TObject);
begin
  if (UpCase(Mercury.ReporteSel) = 'S') then cbReporte.Checked := True
  else
    cbReporte.Checked := False;

  if (UpCase(Mercury.ReporteWebSel) = 'S') then cbReporteWeb.Checked := True
  else
    cbReporteWeb.Checked := False;

  EDirReporte.Text := Mercury.DirReporte;
  EdirNuevaWeb.Text := Mercury.NombreNuevaWeb;
  cbFormatoReporte.ItemIndex := Mercury.FormatoReporte;
  cbIntervaloCaptura.ItemIndex := Mercury.IntervaloCaptura;
  cbTipoArchivo.ItemIndex := Mercury.TipoArchivoReporte;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.sbDirDatosClick(Sender: TObject);
var
  aux: string;
begin
  if not SelectDirectory('Directorio de Datos', '', aux) then SetFocus
  else
  begin
    SetFocus;
    if (length(aux) > 3) then EDirReporte.Text := aux + '\'
    else
      EDirReporte.Text := aux;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.sbSaveWebClick(Sender: TObject);
begin
  DataModule1.SaveDialog.FileName := ExtractFileName(EdirNuevaWeb.Text);
  DataModule1.SaveDialog.InitialDir := ExtractFilePath(EdirNuevaWeb.Text);
  DataModule1.SaveDialog.Filter := 'Paginas Web (*.htm, *.html)|*.htm;*.html';

  if DataModule1.SaveDialog.Execute then
  begin
    if length(ExtractFileExt(DataModule1.SaveDialog.FileName)) > 0 then
      EdirNuevaWeb.Text := DataModule1.SaveDialog.FileName
    else
      EdirNuevaWeb.Text := DataModule1.SaveDialog.FileName + '.htm';
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.MonitoreoEnLinea;
var
  Archivo: string;
  sep: string;
  ext: string;
  Linea: string;
  lineaAux1: string;
  lineaAux2: string;
  F: TextFile;
  i: byte;
  FormatoFecha: string;
begin
  // me fijo que es el momento de generar lo(s) reporte(s)
  if (now < Mercury.HoraMuestreoLinea) then exit;

  // Nueva hora de Muestra
  Mercury.HoraMuestreoLinea := now + TablaTMonitor[Mercury.IntervaloCaptura];

  // Me aseguro que exista el directorio de destino
  if not DirectoryExists(Mercury.DirReporte) then exit;

  // Configuro los par�metros seg�n el formato elegido
  case Mercury.FormatoReporte of
    // Texto (delimitado por tabulaciones)
    0: begin
      sep := #9;
      ext := '.txt';
    end;
    // CSV - Planilla de c�lculo (formato en espa�ol)
    1: begin
      sep := ';';
      ext := '.txt';
    end;
    // CSV - Planilla de c�lculo (formato en ingles)
    2: begin
      sep := ',';
      ext := '.txt';
    end;
    else
    begin
      // Texto (delimitado por tabulaciones)
      sep := #9;
      ext := '.txt';
    end;
  end;

  // Genero el nombre del archivo seg�n el tipo de archivo elejido
  case Mercury.TipoArchivoReporte of
    // Generar un archivo por Hora
    0: Archivo := Mercury.DirReporte + 'Monitoreo_' + Equipo.Nombre +
        '_' + FormatDateTime('dd.mm.yyyy hh', now) + ext;
    // Generar un archivo por D�a
    1: Archivo := Mercury.DirReporte + 'Monitoreo_' + Equipo.Nombre +
        '_' + FormatDateTime('dd.mm.yyyy', now) + ext;
    // Generar un archivo por Mes
    2: Archivo := Mercury.DirReporte + 'Monitoreo_' + Equipo.Nombre +
        '_' + FormatDateTime('mm.yyyy', now) + ext;
    // Generar un archivo por A�o
    3: Archivo := Mercury.DirReporte + 'Monitoreo_' + Equipo.Nombre +
        '_' + FormatDateTime('yyyy', now) + ext;
    else
      // Generar un archivo por D�a
      Archivo := Mercury.DirReporte + 'Monitoreo_' + Equipo.Nombre + '_' +
        FormatDateTime('dd.mm.yyyy', now) + ext;
  end;

  // Configuro las varable para adaptar la fecha con el formato elegido
  FormatoFecha := Mercury.ObtenerFormatoFecha(Mercury.IndiceFormatoFe);

  // Genero el reporte en el archivo de texto
  if (upcase(Mercury.ReporteSel) = 'S') then
  begin
    try // Guardo la info en el archivo
      AssignFile(F, Archivo);

      if FileExists(Archivo) then Append(F)
      else
      begin
        // Incorporo la info en el archivo de texto y los titulos
        Rewrite(F);

        // Para reporte en archivo de texto
        Writeln(F, 'Datos Generales');
        Writeln(F, '--------------------------');
        Writeln(F, 'Nombre del Equipo ' + sep + '= ' + Equipo.Nombre);
        Writeln(F, 'Intervalo de Captura' + sep + '= ' + cbIntervaloCaptura.Text);
        Writeln(F, 'Hora del Equipo   ' + sep + '= ' +
          FormatDateTime(FormatoFecha, Equipo.Hora));
        Writeln(F, 'Hora de la PC     ' + sep + '= ' +
          FormatDateTime(FormatoFecha, Equipo.HoraPC));
        Writeln(F, '');
        Writeln(F, '');

        // Descripci�n de los canales
        Writeln(F, 'Descripci�n de los Canales');
        Writeln(F, '--------------------------');

        for i := 0 to Equipo.NumCanales - 1 do
        begin
          if (Equipo.Canales[i].Config > 0) then
            if (sep = #9) then
              Writeln(F, 'CH ' + IntToStr(i) + #9#9 + sep + '= ' + Equipo.Canales[i].Descripcion +
                ' ' + '[' + Equipo.Canales[i].Unidad + ']')
            else
              Writeln(F, 'CH ' + IntToStr(i) + sep + '= ' + Equipo.Canales[i].Descripcion +
                ' ' + '[' + Equipo.Canales[i].Unidad + ']');
        end;
        Writeln(F, '');
        Writeln(F, '');

        // Descripci�n de los valores calculados
        Writeln(F, 'Valores Calculados');
        Writeln(F, '--------------------------');

        for i := 0 to Equipo.CalcParam.CantParm - 1 do
        begin
          if (Equipo.CalcParam.Parametros[i].Calcular = 1) then
            if (sep = #9) then
              Writeln(F, 'VC ' + IntToStr(i) + #9#9 + sep + '= ' +
                Equipo.CalcParam.Parametros[i].Descripcion + ' ' +
                '[' + Equipo.CalcParam.Parametros[i].Unidad + ']')
            else
              Writeln(F, 'VC ' + IntToStr(i) + sep + '= ' +
                Equipo.CalcParam.Parametros[i].Descripcion + ' ' +
                '[' + Equipo.CalcParam.Parametros[i].Unidad + ']');
        end;
        Writeln(F, '');
        Writeln(F, '');


        // Titulos de la tabla de los valores de los canales y valores
        for i := 0 to Equipo.CalcParam.CantParm - 1 do
        begin
          if (Equipo.CalcParam.Parametros[i].Calcular = 1) then
          begin
            lineaAux1 := lineaAux1 + 'VC ' + IntToStr(i) + sep;
            lineaAux2 := lineaAux2 + '----' + sep;
          end;
        end;

        Writeln(F, lineaAux1);
        Writeln(F, lineaAux2);
      end;

      // Incorporo la info del monitoreo en linea al archivo
      Linea := FormatDateTime('dd/mm/yyyy hh:nn:ss.zzz', now);

      // Info de los valores de los Canales
      for i := 0 to Equipo.NumCanales - 1 do
        if (Equipo.Canales[i].Config <> 0) then
          Linea := Linea + sep + Equipo.Canales[i].ValorReal;

      // Info de los valores Calculdaos
      for i := 0 to Equipo.CalcParam.CantParm - 1 do
        if (Equipo.CalcParam.Parametros[i].Calcular = 1) then
          Linea := Linea + sep + Equipo.CalcParam.Parametros[i].ResultCalcStr;

      Writeln(F, Linea);
      CloseFile(F);
    except
      // Cartel de ERROR
      //MessageDlg('No se puede escribir en el archivo ', mtError,[mbOk], 0);
    end;
  end;

  // Genero el Reporte Web si es necessario
  if (upcase(Mercury.ReporteWebSel) = 'S') then GenerarReporteWeb;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.GenerarReporteWeb;
var
  PaginaWeb: TStrings;
  i: integer;
  FormatoFecha: string;
begin
  if not FileExists(Mercury.NombrePaginaWeb) then exit;
  PaginaWeb := TStringList.Create;
  PaginaWeb.Clear;

  // Levanto la plantilla web para cargar los datos
  PaginaWeb.LoadFromFile(Mercury.NombrePaginaWeb);

  // Configuro las varable para adaptar la fecha con el formato elegido
  FormatoFecha := Mercury.ObtenerFormatoFecha(Mercury.IndiceFormatoFe);

  // Inserto la info en la pagina
  for i := 0 to PaginaWeb.Count - 1 do
  begin
    // Informarc�on del Equipo
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],
      '#FECHA#', FormatDateTime(FormatoFecha, now));
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],
      '#NOMBRE#', Equipo.Nombre);
    if (round(TablaTMonitor[Mercury.IntervaloCaptura] * 86400) > 30) then
      PaginaWeb.Strings[i] :=
        ReemplazarString(PaginaWeb.Strings[i], '#T#', IntToStr(
        round(TablaTMonitor[Mercury.IntervaloCaptura] * 86400)))
    else
      PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i], '#T#', IntToStr(30));

    // Informarc�on de los valores de los canales
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],
      '#CANAL0#', Equipo.Canales[0].ValorReal + ' [' + Equipo.Canales[0].Unidad + ']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],
      '#CANAL1#', Equipo.Canales[1].ValorReal + ' [' + Equipo.Canales[1].Unidad + ']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],
      '#CANAL2#', Equipo.Canales[2].ValorReal + ' [' + Equipo.Canales[2].Unidad + ']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],
      '#CANAL3#', Equipo.Canales[3].ValorReal + ' [' + Equipo.Canales[3].Unidad + ']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],
      '#CANAL4#', Equipo.Canales[4].ValorReal + ' [' + Equipo.Canales[4].Unidad + ']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],
      '#CANAL5#', Equipo.Canales[5].ValorReal + ' [' + Equipo.Canales[5].Unidad + ']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],
      '#CANAL6#', Equipo.Canales[6].ValorReal + ' [' + Equipo.Canales[6].Unidad + ']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],
      '#CANAL7#', Equipo.Canales[7].ValorReal + ' [' + Equipo.Canales[7].Unidad + ']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],
      '#CANALD#', Equipo.Canales[8].ValorReal + ' [' + Equipo.Canales[8].Unidad + ']');

    // Informarc�on de los valores calculados
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],
      '#VC0#', Equipo.CalcParam.Parametros[0].ResultCalcStr +
      ' [' + Equipo.CalcParam.Parametros[0].Unidad + ']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],
      '#VC1#', Equipo.CalcParam.Parametros[1].ResultCalcStr +
      ' [' + Equipo.CalcParam.Parametros[1].Unidad + ']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],
      '#VC2#', Equipo.CalcParam.Parametros[2].ResultCalcStr +
      ' [' + Equipo.CalcParam.Parametros[2].Unidad + ']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],
      '#VC3#', Equipo.CalcParam.Parametros[3].ResultCalcStr +
      ' [' + Equipo.CalcParam.Parametros[3].Unidad + ']');
  end;

  try
    // Guardo la pagina web con los nuevos valores
    PaginaWeb.SaveToFile(Mercury.NombreNuevaWeb);
  except

  end;

  PaginaWeb.Free;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.BotonGraficoCanalClick(Sender: TObject);
var
  Canal: byte;
begin
  // Charting functionality temporarily disabled for Lazarus compatibility
  {FGraficoSensor := TFGraficoSensor.Create(self);
  Canal          := (sender as TSpeedButton).Tag;
  // Solo cuando uso el canal 9 
  if ((Canal mod 10)=8) and Equipo.UsarCH9[Canal div 10] then Canal:=Canal+1;

  FGraficoSensor.Caption                              := FGraficoSensor.ListaCanales.Strings[Canal];
  FGraficoSensor.CanalOrg                             := Canal;
  FGraficoSensor.pEquipo                              := @Equipo;
  FGraficoSensor.DBGrafico.Title.Text.Text            := Equipo.Canales[Canal].Descripcion;
  FGraficoSensor.FechaInicial                         := now;
  FGraficoSensor.PopupMenuSeries.Items[Canal].Checked := true;
  FGraficoSensor.CrearSerie;
  FGraficoSensor.Show;

  inc(GraficosOpen,1);}
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.sbComentarioClick(Sender: TObject);
var
  NuevaDesc: string;
  Canal: byte;
begin
  Canal := (Sender as TSpeedButton).Tag;
  // Solo cuando uso el canal 9
  if ((Canal mod 10) = 8) and Equipo.UsarCH9[Canal div 10] then Canal := Canal + 1;

  NuevaDesc := Equipo.Canales[Canal].Descripcion;
  if not InputQuery('Cambiar Descripci�n del Canal ' + IntToStr(Canal),
    'Ingrese una nueva Descripci�n', NuevaDesc) then exit;

  Equipo.Canales[Canal].Descripcion := NuevaDesc;
  Equipo.GuardarEquipo(Mercury.DirEquipos);
  Equipo.CargarEquipo(Mercury.DirEquipos);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mCalculosParam(Sender: TObject);
begin
  FCalculoParam := TFCalculoParam.Create(self);
  //  FCalculoParam.Caption    := 'C�lculo de par�metros - ' + (sender as TMenuItem).Caption;
  FCalculoParam.pEquipo := @Equipo;
  FCalculoParam.Nparametro := (Sender as TMenuItem).Tag;
  FCalculoParam.ShowModal;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.TipoDeComunicacionClick(Sender: TObject);
begin
  mDirectaCableSERIE.Checked := False;
  mTelefoniaCelular.Checked := False;
  mInternet.Checked := False;

  // Aplico la nueva configuraci�n                                                  
  (Sender as TMenuItem).Checked := True;
  Mercury.TipoDeComm := (Sender as TMenuItem).Tag;

  // Cartel de Informac�on
  MessageBox(Handle, 'Debe reiniciar el programa para que ' +
    #13 + 'los cambios tengan efecto.', PChar(Caption), MB_OK or
    MB_ICONINFORMATION);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mConexionesTelefonicasClick(Sender: TObject);
begin
  FConexionesRemotas := TFConexionesRemotas.Create(self);
  FConexionesRemotas.pConexTelefon := @Mercury.ConexTelefon;

  FConexionesRemotas.ShowModal;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mConexionAutoClick(Sender: TObject);
begin
  FConexionAuto := TFConexionAuto.Create(self);
  FConexionAuto.pMercury := @Mercury;
  FConexionAuto.ShowModal;

  // habilito el bot�n para indicar que est� habilitada la conexi�n auto
  if (Mercury.ConexAuto.intervalo > 0) then
  begin
    tbConexAutoEN.Enabled := True;
    tbConexAutoEN.Hint := 'Conexiones automaticas habilitadas';
  end
  else
  begin
    tbConexAutoEN.Enabled := False;
    tbConexAutoEN.Hint := 'Conexiones automaticas deshabilitadas';
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.ConexionManualClick(Sender: TObject);
var
  Nitem, msg: integer;
begin
  Nitem := (Sender as TMenuItem).Tag;
  msg := MessageBox(Handle, PChar('�Seguro que desea conectarce con ' +
    Mercury.ConexTelefon.AConexiones[Nitem].Nombre + '?'),
    PChar(Caption), MB_YESNO or MB_ICONQUESTION);
  if (msg = 7) then exit;     // Presiono el Boton "NO", No hago nada

  ConcectarConRemoto(Nitem, False, False);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mDesconectarClick(Sender: TObject);
begin
  DesconcectarConRemoto;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.ConcectarConRemoto(index: integer;
  AutoDesconecDesc, AutoDesconecConf: boolean);
begin
  // Asigno el Numero de telefono al que hay que llamar
  Equipo.ThreadComm.NombreConex := Mercury.ConexTelefon.AConexiones[index].Nombre;
  Equipo.ThreadComm.Ntelefono := Mercury.ConexTelefon.AConexiones[index].Ntelefono;

  // Inicio la conexi�n
  Equipo.ThreadComm.ConecTelef := True;

  // Indico si se debe desconectar solo una vez bajados los datos
  Equipo.ThreadComm.AutoDesconecDesc := AutoDesconecDesc;
  // Indico si se debe desconectar solo una vez configurado el equipo  
  Equipo.ThreadComm.AutoDesconecConf := AutoDesconecConf;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.DesconcectarConRemoto;
begin
  // Termino la conexi�n
  Equipo.ThreadComm.DesConecTelef := True;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.ConexionAutomatica(Sender: TObject);
var
  aux: TStrings;
begin
  // Me aseguro que no excista una conexi�n activa
  if Equipo.ThreadComm.ConexOK then exit;

  // Si est� en la lista me conecto
  if Mercury.ConexTelefon.AConexiones[Mercury.ConexAuto.indexConex].Select = 'S' then
  begin
    // Selecciono los distintos tipos de conexi�n
    case Mercury.ConexAuto.CritDesconec of
      0: ConcectarConRemoto(Mercury.ConexAuto.indexConex, True, False);
      1: ConcectarConRemoto(Mercury.ConexAuto.indexConex, False, True);
      else
        ConcectarConRemoto(Mercury.ConexAuto.indexConex, False, True);
    end;

    // Prueba de conexi�n - Generaci�n del archivo de logeo
    aux := TStringList.Create;
    aux.Clear;
    try
      if FileExists('horaConexion.txt') then aux.LoadFromFile('horaConexion.txt');
      aux.Add(Mercury.ConexTelefon.AConexiones[Mercury.ConexAuto.indexConex].Nombre
        + ' ' + FormatDateTime('dd/mm/yy hh:nn:ss', now));
      aux.SaveToFile('horaConexion.txt');
    except

    end;
    aux.Destroy;
  end;

  // Incremento el indice
  Inc(Mercury.ConexAuto.indexConex, 1);

  // Me fijo si termine de conectarme con todos los equipos - reseteo el indice
  if (Mercury.ConexAuto.indexConex > Mercury.ConexTelefon.NumConex - 1) then
    Mercury.ConexAuto.indexConex := 0;

  // Guardo la config ya que tiene la nueva fecha y hora de muestreo
  Mercury.GuardarConfig;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.ONConexionRemota(Sender: TObject);
begin
  // Escribo el cartel para indicar que me estoy conectando
  StatusBar.Panels[0].Text := 'Conectando con "' + Equipo.ThreadComm.NombreConex + '"...';

  // Habilito el bot�n y el men� para desconectar
  tbDesconectar.Enabled := True;
  mDesconectar.Enabled := True;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.ONDesconexionRemota(Sender: TObject);
begin
  // Deshabilito el bot�n y el men� para desconectar
  tbDesconectar.Enabled := False;
  mDesconectar.Enabled := False;

  // Escribo el cartel para indicar que me estoy Desconectando
  StatusBar.Panels[0].Text := 'Desconectando...';
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mConfiguracionDeInternetClick(Sender: TObject);
begin
  FConfiguracionInternet := TFConfiguracionInternet.Create(self);
  FConfiguracionInternet.pEquipo := @Equipo;
  FConfiguracionInternet.ShowModal;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.PageControlChanging(Sender: TObject; var AllowChange: boolean);
begin
  if (Mercury.TipoDeComm = 2) then AllowChange := False;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.PageControlChange(Sender: TObject);
begin
  if ((Mercury.TipoDeComm <> 2) and (PageControl.ActivePageIndex = 3)) then
    PageControl.ActivePageIndex := 0;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mHistorialInternetChange(Sender: TObject);
var
  NombreM: string;
  //dirM     : string;
  auxLines: TStrings;
begin
  if not (Mercury.GuardarRegistro = 'S') then exit;
  if not (mHistorialInternet.Lines.Count > 0) or OnCambio then exit;
  if (mHistorialInternet.Lines.Count = IniLine) then exit;
  OnCambio := True;

  // Guardo el registro de conexiones de internet
  try
    NombreM := Mercury.DirMercury + '\logs\LogInternet ' + FormatDateTime(
      'dd-mm-yyyy', now) + '.txt';
    {dirM    := ExtractFilePath(NombreM);


    // Me aseguro que exista el dir sino lo creo
    if not DirectoryExists(dirM) then MkDir(dirM);

    // Guardo la info en el disco
    if not FileExists(NombreM) then mHistorialInternet.Lines.SaveToFile(NombreM)
    else begin
      auxLines := TStringList.Create;
      auxLines.LoadFromFile(NombreM);
      auxLines.Add(mHistorialInternet.Lines.Strings[mHistorialInternet.Lines.Count-1]);
      if DeleteFile(NombreM) then auxLines.SaveToFile(NombreM);
      auxLines.Destroy;
    end;
    }

    // Guardo la nueva linea en el archivo de logs
    auxLines := TStringList.Create;
    auxLines.Add(mHistorialInternet.Lines.Strings[mHistorialInternet.Lines.Count - 1]);
    SaveTstringsToTxtFile(NombreM, @auxLines, 0, 0);
    IniLine := mHistorialInternet.Lines.Count;
    auxLines.Destroy;

    // Quito la primera linea del historial si tiene mas de 50 lineas
    with mHistorialInternet.Lines do
    begin
      if Count > 500 then
      begin
        {// Quito la primera linea
        Delete(0);
        // Modifico la �ltima linea para que el curso quede sobre la �ltima linea
        Strings[Count-1] := Strings[Count-1]+'';
        IniLine         := Count;  }

        mHistorialInternet.Lines.Clear;
        IniLine := 0;
      end;
    end;
  except

  end;
  OnCambio := False;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mBorrarHistorialClick(Sender: TObject);
begin
  mHistorialInternet.Clear;
end;

////////////////////////////////////////////////////////////////////////////////
// Implementaciones para los nuevos canales visuales (09-15)
// Solo muestran mensajes informativos - No tienen funcionalidad real

procedure TFprincipal.sbGrafico09Click(Sender: TObject);
begin
  MessageBox(Handle, 'Canal 09 es solo visual. No tiene gráfico disponible.',
    PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbGrafico10Click(Sender: TObject);
begin
  MessageBox(Handle, 'Canal 10 es solo visual. No tiene gráfico disponible.',
    PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbGrafico11Click(Sender: TObject);
begin
  MessageBox(Handle, 'Canal 11 es solo visual. No tiene gráfico disponible.',
    PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbGrafico12Click(Sender: TObject);
begin
  MessageBox(Handle, 'Canal 12 es solo visual. No tiene gráfico disponible.',
    PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbGrafico13Click(Sender: TObject);
begin
  MessageBox(Handle, 'Canal 13 es solo visual. No tiene gráfico disponible.',
    PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbGrafico14Click(Sender: TObject);
begin
  MessageBox(Handle, 'Canal 14 es solo visual. No tiene gráfico disponible.',
    PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbGrafico15Click(Sender: TObject);
begin
  MessageBox(Handle, 'Canal 15 es solo visual. No tiene gráfico disponible.',
    PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbComentario09Click(Sender: TObject);
begin
  MessageBox(Handle, 'Canal 09 es solo visual. No tiene comentarios disponibles.',
    PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbComentario10Click(Sender: TObject);
begin
  MessageBox(Handle, 'Canal 10 es solo visual. No tiene comentarios disponibles.',
    PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbComentario11Click(Sender: TObject);
begin
  MessageBox(Handle, 'Canal 11 es solo visual. No tiene comentarios disponibles.',
    PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbComentario12Click(Sender: TObject);
begin
  MessageBox(Handle, 'Canal 12 es solo visual. No tiene comentarios disponibles.',
    PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbComentario13Click(Sender: TObject);
begin
  MessageBox(Handle, 'Canal 13 es solo visual. No tiene comentarios disponibles.',
    PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbComentario14Click(Sender: TObject);
begin
  MessageBox(Handle, 'Canal 14 es solo visual. No tiene comentarios disponibles.',
    PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbComentario15Click(Sender: TObject);
begin
  MessageBox(Handle, 'Canal 15 es solo visual. No tiene comentarios disponibles.',
    PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

// Implementación del menú de expansión
procedure TFprincipal.tbExpansionClick(Sender: TObject);
begin
  // Usamos la instancia global FExpansion (definida en UExpansion.pas y creada en el .lpr)
  if not Assigned(UExpansion.FExpansion) then
    Exit;

  try
    // Configurar el estado inicial del form de expansión basado en la visibilidad actual
    if Assigned(tsExp2) and tsExp2.TabVisible then
      UExpansion.FExpansion.rbCanales32.Checked := True // 32 Canales
    else if Assigned(tsExp1) and tsExp1.TabVisible then
      UExpansion.FExpansion.rbCanales24.Checked := True // 24 Canales
    else if Assigned(tsExp0) and tsExp0.TabVisible then
      UExpansion.FExpansion.RadioButton2.Checked := True // 16 Canales
    else
      UExpansion.FExpansion.RadioButton1.Checked := True; // 8 Canales

    // Mostrar modal y procesar resultado
    if UExpansion.FExpansion.ShowModal = mrOk then
    begin
      if UExpansion.FExpansion.rbCanales32.Checked then
        ActualizarVisibilidadCanales(32)
      else if UExpansion.FExpansion.rbCanales24.Checked then
        ActualizarVisibilidadCanales(24)
      else if UExpansion.FExpansion.RadioButton2.Checked then
        ActualizarVisibilidadCanales(16)
      else
        ActualizarVisibilidadCanales(8);
    end;
  except
    // Evitar cierres inesperados por errores en la UI
  end;
end;

procedure TFprincipal.ActualizarVisibilidadCanales(CantidadCanales: integer);
var
  Es16Canales: boolean;
begin
  // Reset active page first to avoid hiding active tab which can cause freezes
  if Assigned(tsMon) and Assigned(tsMon.PageControl) then
    tsMon.PageControl.ActivePage := tsMon;

  // Actualizar la lógica del Backend (Equipo y Comunicación)
  if Assigned(Equipo) then
    Equipo.ActualizarCantidadCanales(CantidadCanales);

  // Determinar si debemos mostrar los canales extendidos del primer bloque (compatibilidad con lógica anterior)
  Es16Canales := (CantidadCanales >= 16);

  // --- Lógica Legacy de Componentes (Labels, etc.) ---
  // Configuracion (LConfig24, LDescConfig)
  if Assigned(LConfig09) then LConfig09.Visible := Es16Canales;
  if Assigned(LDescConfig09) then LDescConfig09.Visible := Es16Canales;
  if Assigned(LConfig10) then LConfig10.Visible := Es16Canales;
  if Assigned(LDescConfig26) then LDescConfig26.Visible := Es16Canales;
  if Assigned(LConfig11) then LConfig11.Visible := Es16Canales;
  if Assigned(LDescConfig25) then LDescConfig25.Visible := Es16Canales;
  if Assigned(LConfig12) then LConfig12.Visible := Es16Canales;
  if Assigned(LDescConfig24) then LDescConfig24.Visible := Es16Canales;
  if Assigned(LConfig13) then LConfig13.Visible := Es16Canales;
  if Assigned(LDescConfig23) then LDescConfig23.Visible := Es16Canales;
  if Assigned(LConfig14) then LConfig14.Visible := Es16Canales;
  if Assigned(LDescConfig18) then LDescConfig18.Visible := Es16Canales;
  if Assigned(LConfig15) then LConfig15.Visible := Es16Canales;
  if Assigned(LDescConfig19) then LDescConfig19.Visible := Es16Canales;

  // Visualizacion (Valores, Unidades, Descripciones) para Canales 8-15 (Expansion 1)
  // NOTA: En Expansion 1, LDescripcionX y LUnidadX (1-8) corresponden a canales 8-15
  // Canal 8
  if Assigned(LValorCan08) then LValorCan08.Visible := Es16Canales;
  if Assigned(LUnidadCan08) then LUnidadCan08.Visible := Es16Canales;
  if Assigned(LDescripcionCan08) then LDescripcionCan08.Visible := Es16Canales;
  if Assigned(LNombreCanal09) then LNombreCanal09.Visible := Es16Canales;

  // Canal 9
  if Assigned(LValorCan09) then LValorCan09.Visible := Es16Canales;
  if Assigned(LUnidadCan09) then LUnidadCan09.Visible := Es16Canales;
  if Assigned(LDescripcionCan09) then LDescripcionCan09.Visible := Es16Canales;
  if Assigned(LNombreCanal10) then LNombreCanal10.Visible := Es16Canales;

  // Canal 10
  if Assigned(LValorCan10) then LValorCan10.Visible := Es16Canales;
  if Assigned(LUnidadCan10) then LUnidadCan10.Visible := Es16Canales;
  if Assigned(LDescripcionCan10) then LDescripcionCan10.Visible := Es16Canales;
  if Assigned(LNombreCanal11) then LNombreCanal11.Visible := Es16Canales;

  // Canal 11
  if Assigned(LValorCan11) then LValorCan11.Visible := Es16Canales;
  if Assigned(LUnidadCan11) then LUnidadCan11.Visible := Es16Canales;
  if Assigned(LDescripcionCan11) then LDescripcionCan11.Visible := Es16Canales;
  if Assigned(LNombreCanal12) then LNombreCanal12.Visible := Es16Canales;

  // Canal 12
  if Assigned(LValorCan12) then LValorCan12.Visible := Es16Canales;
  if Assigned(LUnidadCan12) then LUnidadCan12.Visible := Es16Canales;
  if Assigned(LDescripcionCan12) then LDescripcionCan12.Visible := Es16Canales;
  if Assigned(LNombreCanal13) then LNombreCanal13.Visible := Es16Canales;

  // Canal 13
  if Assigned(LValorCan13) then LValorCan13.Visible := Es16Canales;
  if Assigned(LUnidadCan13) then LUnidadCan13.Visible := Es16Canales;
  if Assigned(LDescripcionCan13) then LDescripcionCan13.Visible := Es16Canales;
  if Assigned(LNombreCanal14) then LNombreCanal14.Visible := Es16Canales;

  // Canal 14
  if Assigned(LValorCan14) then LValorCan14.Visible := Es16Canales;
  if Assigned(LUnidadCan14) then LUnidadCan14.Visible := Es16Canales;
  if Assigned(LDescripcionCan14) then LDescripcionCan14.Visible := Es16Canales;
  if Assigned(LNombreCanal15) then LNombreCanal15.Visible := Es16Canales;

  // Canal 15
  if Assigned(LValorCan15) then LValorCan15.Visible := Es16Canales;
  if Assigned(LUnidadCan15) then LUnidadCan15.Visible := Es16Canales;
  if Assigned(LDescripcionCan15) then LDescripcionCan15.Visible := Es16Canales;

  // Controlar la visibilidad del contenedor de los canales adicionales (GroupBoxCan14)
  if GroupBoxCan14 <> nil then
    GroupBoxCan14.Visible := Es16Canales;

  // Ajustar la posición de GroupBox8
  if GroupBox8 <> nil then
  begin
    if Es16Canales then
    begin
      if GroupBoxCan14 <> nil then
        GroupBox8.Top := GroupBoxCan14.Top + GroupBoxCan14.Height + 50;
    end
    else
    begin
      if GroupBox6 <> nil then
        GroupBox8.Top := GroupBox6.Top + GroupBox6.Height + 50;
    end;
  end;

  // --- Lógica de Pestañas (TabSheets) ---
  // tsMon siempre visible (8 canales base)
  tsMon.TabVisible := True;

  // tsExp0 visible si 16 o más (nota: coincide con GroupBoxCan14)
  tsExp0.TabVisible := (CantidadCanales >= 16);

  // tsExp1 visible si 24 o más
  tsExp1.TabVisible := (CantidadCanales >= 24);

  // tsExp2 visible si 32 o más
  tsExp2.TabVisible := (CantidadCanales >= 32);

  // Asegurar que la pestaña activa sea válida y visible (Evita freeze y visualización incorrecta al inicio)
  if tsMon.PageControl <> nil then
  begin
    // Si la pestaña activa actual va a ser ocultada, cambiar a tsMon
    if (not tsExp0.TabVisible and (tsMon.PageControl.ActivePage = tsExp0)) or
      (not tsExp1.TabVisible and (tsMon.PageControl.ActivePage = tsExp1)) or
      (not tsExp2.TabVisible and (tsMon.PageControl.ActivePage = tsExp2)) then
    begin
      tsMon.PageControl.ActivePage := tsMon;
    end;

    // Forzar tsMon al inicio si estamos en modo 8 canales
    if (CantidadCanales = 8) then
      tsMon.PageControl.ActivePage := tsMon;
  end;
end;





end.
