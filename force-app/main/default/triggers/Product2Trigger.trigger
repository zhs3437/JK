trigger Product2Trigger on Product2 (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new RC_ProductToiProductHandler().run();
}