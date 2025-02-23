// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_type_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssetTypeEnumAdapter extends TypeAdapter<AssetTypeEnum> {
  @override
  final int typeId = 4;

  @override
  AssetTypeEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AssetTypeEnum.refrigerator;
      case 1:
        return AssetTypeEnum.airConditioner;
      case 2:
        return AssetTypeEnum.hvacSystem;
      case 3:
        return AssetTypeEnum.solarPanel;
      case 4:
        return AssetTypeEnum.evCharger;
      case 5:
        return AssetTypeEnum.battery;
      default:
        return AssetTypeEnum.refrigerator;
    }
  }

  @override
  void write(BinaryWriter writer, AssetTypeEnum obj) {
    switch (obj) {
      case AssetTypeEnum.refrigerator:
        writer.writeByte(0);
        break;
      case AssetTypeEnum.airConditioner:
        writer.writeByte(1);
        break;
      case AssetTypeEnum.hvacSystem:
        writer.writeByte(2);
        break;
      case AssetTypeEnum.solarPanel:
        writer.writeByte(3);
        break;
      case AssetTypeEnum.evCharger:
        writer.writeByte(4);
        break;
      case AssetTypeEnum.battery:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetTypeEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
