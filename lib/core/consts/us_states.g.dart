// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'us_states.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsStateAdapter extends TypeAdapter<UsState> {
  @override
  final int typeId = 2;

  @override
  UsState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UsState.AL;
      case 1:
        return UsState.AK;
      case 2:
        return UsState.AZ;
      case 3:
        return UsState.AR;
      case 4:
        return UsState.CA;
      case 5:
        return UsState.CO;
      case 6:
        return UsState.CT;
      case 7:
        return UsState.DE;
      case 8:
        return UsState.FL;
      case 9:
        return UsState.GA;
      case 10:
        return UsState.HI;
      case 11:
        return UsState.ID;
      case 12:
        return UsState.IL;
      case 13:
        return UsState.IN;
      case 14:
        return UsState.IA;
      case 15:
        return UsState.KS;
      case 16:
        return UsState.KY;
      case 17:
        return UsState.LA;
      case 18:
        return UsState.ME;
      case 19:
        return UsState.MD;
      case 20:
        return UsState.MA;
      case 21:
        return UsState.MI;
      case 22:
        return UsState.MN;
      case 23:
        return UsState.MS;
      case 24:
        return UsState.MO;
      case 25:
        return UsState.MT;
      case 26:
        return UsState.NE;
      case 27:
        return UsState.NV;
      case 28:
        return UsState.NH;
      case 29:
        return UsState.NJ;
      case 30:
        return UsState.NM;
      case 31:
        return UsState.NY;
      case 32:
        return UsState.NC;
      case 33:
        return UsState.ND;
      case 34:
        return UsState.OH;
      case 35:
        return UsState.OK;
      case 36:
        return UsState.OR;
      case 37:
        return UsState.PA;
      case 38:
        return UsState.RI;
      case 39:
        return UsState.SC;
      case 40:
        return UsState.SD;
      case 41:
        return UsState.TN;
      case 42:
        return UsState.TX;
      case 43:
        return UsState.UT;
      case 44:
        return UsState.VT;
      case 45:
        return UsState.VA;
      case 46:
        return UsState.WA;
      case 47:
        return UsState.WV;
      case 48:
        return UsState.WI;
      case 49:
        return UsState.WY;
      default:
        return UsState.AL;
    }
  }

  @override
  void write(BinaryWriter writer, UsState obj) {
    switch (obj) {
      case UsState.AL:
        writer.writeByte(0);
        break;
      case UsState.AK:
        writer.writeByte(1);
        break;
      case UsState.AZ:
        writer.writeByte(2);
        break;
      case UsState.AR:
        writer.writeByte(3);
        break;
      case UsState.CA:
        writer.writeByte(4);
        break;
      case UsState.CO:
        writer.writeByte(5);
        break;
      case UsState.CT:
        writer.writeByte(6);
        break;
      case UsState.DE:
        writer.writeByte(7);
        break;
      case UsState.FL:
        writer.writeByte(8);
        break;
      case UsState.GA:
        writer.writeByte(9);
        break;
      case UsState.HI:
        writer.writeByte(10);
        break;
      case UsState.ID:
        writer.writeByte(11);
        break;
      case UsState.IL:
        writer.writeByte(12);
        break;
      case UsState.IN:
        writer.writeByte(13);
        break;
      case UsState.IA:
        writer.writeByte(14);
        break;
      case UsState.KS:
        writer.writeByte(15);
        break;
      case UsState.KY:
        writer.writeByte(16);
        break;
      case UsState.LA:
        writer.writeByte(17);
        break;
      case UsState.ME:
        writer.writeByte(18);
        break;
      case UsState.MD:
        writer.writeByte(19);
        break;
      case UsState.MA:
        writer.writeByte(20);
        break;
      case UsState.MI:
        writer.writeByte(21);
        break;
      case UsState.MN:
        writer.writeByte(22);
        break;
      case UsState.MS:
        writer.writeByte(23);
        break;
      case UsState.MO:
        writer.writeByte(24);
        break;
      case UsState.MT:
        writer.writeByte(25);
        break;
      case UsState.NE:
        writer.writeByte(26);
        break;
      case UsState.NV:
        writer.writeByte(27);
        break;
      case UsState.NH:
        writer.writeByte(28);
        break;
      case UsState.NJ:
        writer.writeByte(29);
        break;
      case UsState.NM:
        writer.writeByte(30);
        break;
      case UsState.NY:
        writer.writeByte(31);
        break;
      case UsState.NC:
        writer.writeByte(32);
        break;
      case UsState.ND:
        writer.writeByte(33);
        break;
      case UsState.OH:
        writer.writeByte(34);
        break;
      case UsState.OK:
        writer.writeByte(35);
        break;
      case UsState.OR:
        writer.writeByte(36);
        break;
      case UsState.PA:
        writer.writeByte(37);
        break;
      case UsState.RI:
        writer.writeByte(38);
        break;
      case UsState.SC:
        writer.writeByte(39);
        break;
      case UsState.SD:
        writer.writeByte(40);
        break;
      case UsState.TN:
        writer.writeByte(41);
        break;
      case UsState.TX:
        writer.writeByte(42);
        break;
      case UsState.UT:
        writer.writeByte(43);
        break;
      case UsState.VT:
        writer.writeByte(44);
        break;
      case UsState.VA:
        writer.writeByte(45);
        break;
      case UsState.WA:
        writer.writeByte(46);
        break;
      case UsState.WV:
        writer.writeByte(47);
        break;
      case UsState.WI:
        writer.writeByte(48);
        break;
      case UsState.WY:
        writer.writeByte(49);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
