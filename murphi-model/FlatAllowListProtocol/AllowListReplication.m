/*
  Copyright (c) 2021.  Nicolai Oswald
  Copyright (c) 2021.  University of Edinburgh
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met: redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer;
  redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution;
  neither the name of the copyright holders nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
--RevMurphi/MurphiModular/Constants/GenConst
  ---- System access constants
  const
    ENABLE_QS: false;
    VAL_COUNT: 1;
    ADR_COUNT: 1;
  
  ---- System network constants
    O_NET_MAX: 12;
    U_NET_MAX: 12;
  
  ---- SSP declaration constants
    NrCachesL1C1: 1;
  
--RevMurphi/MurphiModular/GenTypes
  type
    ----RevMurphi/MurphiModular/Types/GenAdrDef
    Address: scalarset(ADR_COUNT);
    ClValue: 0..VAL_COUNT;
    
    ----RevMurphi/MurphiModular/Types/Enums/GenEnums
      ------RevMurphi/MurphiModular/Types/Enums/SubEnums/GenAccess
      PermissionType: enum {
        load, 
        store, 
        evict, 
        none
      };
      
      ------RevMurphi/MurphiModular/Types/Enums/SubEnums/GenMessageTypes
      MessageType: enum {
        GetSL1C1, 
        GetML1C1, 
        WB_AckL1C1, 
        PutSL1C1, 
        Inv_AckL1C1, 
        WBL1C1, 
        PutML1C1, 
        GetS_AckL1C1, 
        GetM_Ack_DL1C1, 
        InvL1C1, 
        GetM_Ack_ADL1C1, 
        Put_AckL1C1, 
        Fwd_GetSL1C1, 
        Fwd_GetML1C1
      };
      
      ------RevMurphi/MurphiModular/Types/Enums/SubEnums/GenArchEnums
      s_cacheL1C1: enum {
        cacheL1C1_S_store_GetM_Ack_AD,
        cacheL1C1_S_store,
        cacheL1C1_S_evict_x_M_Fwd_GetS,
        cacheL1C1_S_evict_x_I,
        cacheL1C1_S_evict,
        cacheL1C1_S,
        cacheL1C1_M_evict_x_M_Fwd_GetM,
        cacheL1C1_M_evict_x_I,
        cacheL1C1_M_evict,
        cacheL1C1_M_Fwd_GetS,
        cacheL1C1_M_Fwd_GetM,
        cacheL1C1_M,
        cacheL1C1_I_x_M_Fwd_GetM,
        cacheL1C1_I_store_GetM_Ack_AD,
        cacheL1C1_I_store,
        cacheL1C1_I_load,
        cacheL1C1_I
      };
      
      s_directoryL1C1: enum {
        directoryL1C1_S_store,
        directoryL1C1_S,
        directoryL1C1_RM_store,
        directoryL1C1_RM_load,
        directoryL1C1_RM,
        directoryL1C1_M_evict,
        directoryL1C1_M_GetS,
        directoryL1C1_M_GetM,
        directoryL1C1_M,
        directoryL1C1_I
      };
      
    ----RevMurphi/MurphiModular/Types/GenMachineSets
      -- Cluster: C1
      OBJSET_cacheL1C1: enum{cacheL1C1};
      OBJSET_directoryL1C1: enum{directoryL1C1};
      C1Machines: union{OBJSET_cacheL1C1, OBJSET_directoryL1C1};
      
      Machines: union{OBJSET_cacheL1C1, OBJSET_directoryL1C1};
    
    ----RevMurphi/MurphiModular/Types/GenCheckTypes
      ------RevMurphi/MurphiModular/Types/CheckTypes/GenPermType
        acc_type_obj: multiset[3] of PermissionType;
        PermMonitor: array[Machines] of array[Address] of acc_type_obj;
      
      ------RevMurphi/MurphiModular/Types/CheckTypes/GenStoreMonitorType
        GlobalStoreMonitor: array[Address] of ClValue;
      
    
    ----RevMurphi/MurphiModular/Types/GenMessage
      Message: record
        adr: Address;
        mtype: MessageType;
        src: Machines;
        dst: Machines;
        acksExpectedL1C1: 0..NrCachesL1C1;
        cl: ClValue;
      end;
      
    ----RevMurphi/MurphiModular/Types/GenNetwork
      NET_Ordered: array[Machines] of array[0..O_NET_MAX-1] of Message;
      NET_Ordered_cnt: array[Machines] of 0..O_NET_MAX;
      NET_Unordered: array[Machines] of multiset[U_NET_MAX] of Message;
    
    ----RevMurphi/MurphiModular/Types/GenMachines
      
      ENTRY_cacheL1C1: record
        State: s_cacheL1C1;
        cl: ClValue;
        acksReceivedL1C1: 0..NrCachesL1C1;
        acksExpectedL1C1: 0..NrCachesL1C1;
      end;
      
      MACH_cacheL1C1: record
        cb: array[Address] of ENTRY_cacheL1C1;
      end;
      
      OBJ_cacheL1C1: array[OBJSET_cacheL1C1] of MACH_cacheL1C1;
      v_sharersL1C1: multiset[NrCachesL1C1] of Machines;
      cnt_v_sharersL1C1: 0..NrCachesL1C1;
      
      ENTRY_directoryL1C1: record
        State: s_directoryL1C1;
        cl: ClValue;
        sharersL1C1: v_sharersL1C1;
        ownerL1C1: Machines;
      end;
      
      MACH_directoryL1C1: record
        cb: array[Address] of ENTRY_directoryL1C1;
      end;
      
      OBJ_directoryL1C1: array[OBJSET_directoryL1C1] of MACH_directoryL1C1;
    

  var
    --RevMurphi/MurphiModular/GenVars
      fwd: NET_Ordered;
      cnt_fwd: NET_Ordered_cnt;
      resp: NET_Ordered;
      cnt_resp: NET_Ordered_cnt;
      req: NET_Ordered;
      cnt_req: NET_Ordered_cnt;
    
    
      g_perm: PermMonitor;
      g_monitor_store: GlobalStoreMonitor;
      i_cacheL1C1: OBJ_cacheL1C1;
      i_directoryL1C1: OBJ_directoryL1C1;
  
--RevMurphi/MurphiModular/GenFunctions

  ----RevMurphi/MurphiModular/Functions/GenResetFunc
    procedure ResetMachine_cacheL1C1();
    begin
      for i:OBJSET_cacheL1C1 do
        for a:Address do
          i_cacheL1C1[i].cb[a].State := cacheL1C1_I;
          i_cacheL1C1[i].cb[a].cl := 0;
          i_cacheL1C1[i].cb[a].acksReceivedL1C1 := 0;
          i_cacheL1C1[i].cb[a].acksExpectedL1C1 := 0;
    
        endfor;
      endfor;
    end;
    
    procedure ResetMachine_directoryL1C1();
    begin
      for i:OBJSET_directoryL1C1 do
        for a:Address do
          i_directoryL1C1[i].cb[a].State := directoryL1C1_I;
          i_directoryL1C1[i].cb[a].cl := 0;
          undefine i_directoryL1C1[i].cb[a].sharersL1C1;
          undefine i_directoryL1C1[i].cb[a].ownerL1C1;
    
        endfor;
      endfor;
    end;
    
      procedure ResetMachine_();
      begin
      ResetMachine_cacheL1C1();
      ResetMachine_directoryL1C1();
      
      end;
  ----RevMurphi/MurphiModular/Functions/GenEventFunc
  ----RevMurphi/MurphiModular/Functions/GenPermFunc
    procedure Clear_perm(adr: Address; m: Machines);
    begin
      alias l_perm_set:g_perm[m][adr] do
          undefine l_perm_set;
      endalias;
    end;
    
    procedure Set_perm(acc_type: PermissionType; adr: Address; m: Machines);
    begin
      alias l_perm_set:g_perm[m][adr] do
          MultisetAdd(acc_type, l_perm_set);
      endalias;
    end;
    
    procedure Reset_perm();
    begin
      for m:Machines do
        for adr:Address do
          Clear_perm(adr, m);
        endfor;
      endfor;
    end;
    
  
  ----RevMurphi/MurphiModular/Functions/GenStoreMonitorFunc
    procedure Execute_store_monitor(cb: ClValue; adr: Address);
    begin
      alias cbe: g_monitor_store[adr] do
        if cbe = cb then
          if cbe = VAL_COUNT then
            cbe := 0;
          else
            cbe := cbe + 1;
          endif;
        else
            error "Write linearization failed";
        endif;
      endalias;
    end;
    
    procedure Reset_global_monitor();
    begin
      for adr:Address do
        g_monitor_store[adr] := 0;
      endfor;
    end;
  
    procedure Store(var cbe: ClValue; adr: Address);
    begin
      Execute_store_monitor(cbe, adr);
      if cbe = VAL_COUNT then
        cbe:= 0;
      else
        cbe := cbe + 1;
      endif;
    end;
  
  ----RevMurphi/MurphiModular/Functions/GenVectorFunc
    -- .add()
    procedure AddElement_sharersL1C1(var sv:v_sharersL1C1; n:Machines);
    begin
        if MultiSetCount(i:sv, sv[i] = n) = 0 then
          MultiSetAdd(n, sv);
        endif;
    end;
    
    -- .del()
    procedure RemoveElement_sharersL1C1(var sv:v_sharersL1C1; n:Machines);
    begin
        if MultiSetCount(i:sv, sv[i] = n) = 1 then
          MultiSetRemovePred(i:sv, sv[i] = n);
        endif;
    end;
    
    -- .clear()
    procedure ClearVector_sharersL1C1(var sv:v_sharersL1C1;);
    begin
        MultiSetRemovePred(i:sv, true);
    end;
    
    -- .contains()
    function IsElement_sharersL1C1(var sv:v_sharersL1C1; n:Machines) : boolean;
    begin
        if MultiSetCount(i:sv, sv[i] = n) = 1 then
          return true;
        elsif MultiSetCount(i:sv, sv[i] = n) = 0 then
          return false;
        else
          Error "Multiple Entries of Sharer in SV multiset";
        endif;
      return false;
    end;
    
    -- .empty()
    function HasElement_sharersL1C1(var sv:v_sharersL1C1; n:Machines) : boolean;
    begin
        if MultiSetCount(i:sv, true) = 0 then
          return false;
        endif;
    
        return true;
    end;
    
    -- .count()
    function VectorCount_sharersL1C1(var sv:v_sharersL1C1) : cnt_v_sharersL1C1;
    begin
        return MultiSetCount(i:sv, true);
    end;
    
  ----RevMurphi/MurphiModular/Functions/GenFIFOFunc
  ----RevMurphi/MurphiModular/Functions/GenNetworkFunc
    procedure Send_fwd(msg:Message; src: Machines;);
      Assert(cnt_fwd[msg.dst] < O_NET_MAX) "Too many messages";
      fwd[msg.dst][cnt_fwd[msg.dst]] := msg;
      cnt_fwd[msg.dst] := cnt_fwd[msg.dst] + 1;
    end;
    
    procedure Pop_fwd(dst:Machines; src: Machines;);
    begin
      Assert (cnt_fwd[dst] > 0) "Trying to advance empty Q";
      for i := 0 to cnt_fwd[dst]-1 do
        if i < cnt_fwd[dst]-1 then
          fwd[dst][i] := fwd[dst][i+1];
        else
          undefine fwd[dst][i];
        endif;
      endfor;
      cnt_fwd[dst] := cnt_fwd[dst] - 1;
    end;
    
    procedure Send_resp(msg:Message; src: Machines;);
      Assert(cnt_resp[msg.dst] < O_NET_MAX) "Too many messages";
      resp[msg.dst][cnt_resp[msg.dst]] := msg;
      cnt_resp[msg.dst] := cnt_resp[msg.dst] + 1;
    end;
    
    procedure Pop_resp(dst:Machines; src: Machines;);
    begin
      Assert (cnt_resp[dst] > 0) "Trying to advance empty Q";
      for i := 0 to cnt_resp[dst]-1 do
        if i < cnt_resp[dst]-1 then
          resp[dst][i] := resp[dst][i+1];
        else
          undefine resp[dst][i];
        endif;
      endfor;
      cnt_resp[dst] := cnt_resp[dst] - 1;
    end;
    
    procedure Send_req(msg:Message; src: Machines;);
      Assert(cnt_req[msg.dst] < O_NET_MAX) "Too many messages";
      req[msg.dst][cnt_req[msg.dst]] := msg;
      cnt_req[msg.dst] := cnt_req[msg.dst] + 1;
    end;
    
    procedure Pop_req(dst:Machines; src: Machines;);
    begin
      Assert (cnt_req[dst] > 0) "Trying to advance empty Q";
      for i := 0 to cnt_req[dst]-1 do
        if i < cnt_req[dst]-1 then
          req[dst][i] := req[dst][i+1];
        else
          undefine req[dst][i];
        endif;
      endfor;
      cnt_req[dst] := cnt_req[dst] - 1;
    end;
    
    procedure Multicast_fwd_v_sharersL1C1(var msg: Message; dst_vect: v_sharersL1C1; src: Machines;);
    begin
          for n:Machines do
              if n!=msg.src then
                if MultiSetCount(i:dst_vect, dst_vect[i] = n) = 1 then
                  msg.dst := n;
                  Send_fwd(msg, src);
                endif;
              endif;
          endfor;
    end;
    
    function req_network_ready(): boolean;
    begin
          for dst:Machines do
            for src: Machines do
              if cnt_req[dst] >= (O_NET_MAX-3) then
                return false;
              endif;
            endfor;
          endfor;
    
          return true;
    end;
    function resp_network_ready(): boolean;
    begin
          for dst:Machines do
            for src: Machines do
              if cnt_resp[dst] >= (O_NET_MAX-3) then
                return false;
              endif;
            endfor;
          endfor;
    
          return true;
    end;
    function fwd_network_ready(): boolean;
    begin
          for dst:Machines do
            for src: Machines do
              if cnt_fwd[dst] >= (O_NET_MAX-3) then
                return false;
              endif;
            endfor;
          endfor;
    
          return true;
    end;
    function network_ready(): boolean;
    begin
            if !req_network_ready() then
            return false;
          endif;
    
    
          if !resp_network_ready() then
            return false;
          endif;
    
    
          if !fwd_network_ready() then
            return false;
          endif;
    
    
    
      return true;
    end;
    
    procedure Reset_NET_();
    begin
      
      undefine resp;
      for dst:Machines do
          cnt_resp[dst] := 0;
      endfor;
      
      undefine req;
      for dst:Machines do
          cnt_req[dst] := 0;
      endfor;
      
      undefine fwd;
      for dst:Machines do
          cnt_fwd[dst] := 0;
      endfor;
    
    end;
    
  
  ----RevMurphi/MurphiModular/Functions/GenMessageConstrFunc
    function RequestL1C1(adr: Address; mtype: MessageType; src: Machines; dst: Machines) : Message;
    var Message: Message;
    begin
      Message.adr := adr;
      Message.mtype := mtype;
      Message.src := src;
      Message.dst := dst;
    return Message;
    end;
    
    function AckL1C1(adr: Address; mtype: MessageType; src: Machines; dst: Machines) : Message;
    var Message: Message;
    begin
      Message.adr := adr;
      Message.mtype := mtype;
      Message.src := src;
      Message.dst := dst;
    return Message;
    end;
    
    function RespL1C1(adr: Address; mtype: MessageType; src: Machines; dst: Machines) : Message;
    var Message: Message;
    begin
      Message.adr := adr;
      Message.mtype := mtype;
      Message.src := src;
      Message.dst := dst;
    return Message;
    end;
    
    function RespAckL1C1(adr: Address; mtype: MessageType; src: Machines; dst: Machines; acksExpectedL1C1: 0..NrCachesL1C1) : Message;
    var Message: Message;
    begin
      Message.adr := adr;
      Message.mtype := mtype;
      Message.src := src;
      Message.dst := dst;
      Message.acksExpectedL1C1 := acksExpectedL1C1;
    return Message;
    end;
    
    function Data_WBL1C1(adr: Address; mtype: MessageType; src: Machines; dst: Machines; cl: ClValue) : Message;
    var Message: Message;
    begin
      Message.adr := adr;
      Message.mtype := mtype;
      Message.src := src;
      Message.dst := dst;
      Message.cl := cl;
    return Message;
    end;
    
    function Data_RespL1C1(adr: Address; mtype: MessageType; src: Machines; dst: Machines; cl: ClValue) : Message;
    var Message: Message;
    begin
      Message.adr := adr;
      Message.mtype := mtype;
      Message.src := src;
      Message.dst := dst;
      Message.cl := cl;
    return Message;
    end;
    
  

--RevMurphi/MurphiModular/GenStateMachines

  ----RevMurphi/MurphiModular/StateMachines/GenAccessStateMachines
    procedure FSM_Access_cacheL1C1_I_load(adr:Address; m:OBJSET_cacheL1C1);
    var msg: Message;
    begin
    alias cbe: i_cacheL1C1[m].cb[adr] do
      msg := RequestL1C1(adr,GetSL1C1,m,directoryL1C1);
      Send_req(msg, m);
      Clear_perm(adr, m);
      cbe.State := cacheL1C1_I_load;
      return;
    endalias;
    end;
    
    procedure FSM_Access_cacheL1C1_I_store(adr:Address; m:OBJSET_cacheL1C1);
    var msg: Message;
    begin
    alias cbe: i_cacheL1C1[m].cb[adr] do
      msg := RequestL1C1(adr,GetML1C1,m,directoryL1C1);
      Send_req(msg, m);
      cbe.acksReceivedL1C1 := 0;
      Clear_perm(adr, m);
      cbe.State := cacheL1C1_I_store;
      return;
    endalias;
    end;
    
    procedure FSM_Access_cacheL1C1_M_evict(adr:Address; m:OBJSET_cacheL1C1);
    var msg: Message;
    begin
    alias cbe: i_cacheL1C1[m].cb[adr] do
      msg := Data_WBL1C1(adr,PutML1C1,m,directoryL1C1,cbe.cl);
      Send_req(msg, m);
      Clear_perm(adr, m);
      cbe.State := cacheL1C1_M_evict;
      return;
    endalias;
    end;
    
    procedure FSM_Access_cacheL1C1_M_load(adr:Address; m:OBJSET_cacheL1C1);
    begin
    alias cbe: i_cacheL1C1[m].cb[adr] do
      Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
      cbe.State := cacheL1C1_M;
      return;
    endalias;
    end;
    
    procedure FSM_Access_cacheL1C1_M_store(adr:Address; m:OBJSET_cacheL1C1);
    begin
    alias cbe: i_cacheL1C1[m].cb[adr] do
      Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
      Store(cbe.cl, adr);
      cbe.State := cacheL1C1_M;
      return;
    endalias;
    end;
    
    procedure FSM_Access_cacheL1C1_S_evict(adr:Address; m:OBJSET_cacheL1C1);
    var msg: Message;
    begin
    alias cbe: i_cacheL1C1[m].cb[adr] do
      msg := Data_WBL1C1(adr,PutSL1C1,m,directoryL1C1,cbe.cl);
      Send_req(msg, m);
      Clear_perm(adr, m);
      cbe.State := cacheL1C1_S_evict;
      return;
    endalias;
    end;
    
    procedure FSM_Access_cacheL1C1_S_load(adr:Address; m:OBJSET_cacheL1C1);
    begin
    alias cbe: i_cacheL1C1[m].cb[adr] do
      Clear_perm(adr, m); Set_perm(load, adr, m);
      cbe.State := cacheL1C1_S;
      return;
    endalias;
    end;
    
    procedure FSM_Access_cacheL1C1_S_store(adr:Address; m:OBJSET_cacheL1C1);
    var msg: Message;
    begin
    alias cbe: i_cacheL1C1[m].cb[adr] do
      msg := RequestL1C1(adr,GetML1C1,m,directoryL1C1);
      Send_req(msg, m);
      cbe.acksReceivedL1C1 := 0;
      Clear_perm(adr, m);
      cbe.State := cacheL1C1_S_store;
      return;
    endalias;
    end;
    
    procedure FSM_Access_directoryL1C1_I_load(adr:Address; m:OBJSET_directoryL1C1);
    begin
    alias cbe: i_directoryL1C1[m].cb[adr] do
      Clear_perm(adr, m); Set_perm(load, adr, m);
      cbe.State := directoryL1C1_S;
      return;
    endalias;
    end;
    
    procedure FSM_Access_directoryL1C1_I_store(adr:Address; m:OBJSET_directoryL1C1);
    begin
    alias cbe: i_directoryL1C1[m].cb[adr] do
      Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
      Store(cbe.cl, adr);
      cbe.State := directoryL1C1_M;
      return;
    endalias;
    end;
    
    procedure FSM_Access_directoryL1C1_M_evict(adr:Address; m:OBJSET_directoryL1C1);
    var msg: Message;
    begin
    alias cbe: i_directoryL1C1[m].cb[adr] do
      msg := Data_WBL1C1(adr,WBL1C1,m,cacheL1C1,cbe.cl);
      Send_fwd(msg, m);
      Clear_perm(adr, m);
      cbe.State := directoryL1C1_M_evict;
      return;
    endalias;
    end;
    
    procedure FSM_Access_directoryL1C1_M_load(adr:Address; m:OBJSET_directoryL1C1);
    begin
    alias cbe: i_directoryL1C1[m].cb[adr] do
      Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
      cbe.State := directoryL1C1_M;
      return;
    endalias;
    end;
    
    procedure FSM_Access_directoryL1C1_M_store(adr:Address; m:OBJSET_directoryL1C1);
    begin
    alias cbe: i_directoryL1C1[m].cb[adr] do
      Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
      Store(cbe.cl, adr);
      cbe.State := directoryL1C1_M;
      return;
    endalias;
    end;
    
    procedure FSM_Access_directoryL1C1_RM_evict(adr:Address; m:OBJSET_directoryL1C1);
    begin
    alias cbe: i_directoryL1C1[m].cb[adr] do
      Clear_perm(adr, m);
      cbe.State := directoryL1C1_RM;
      return;
    endalias;
    end;
    
    procedure FSM_Access_directoryL1C1_RM_load(adr:Address; m:OBJSET_directoryL1C1);
    var msg: Message;
    begin
    alias cbe: i_directoryL1C1[m].cb[adr] do
      msg := RequestL1C1(adr,Fwd_GetSL1C1,m,cbe.ownerL1C1);
      Send_req(msg, m);
      Clear_perm(adr, m);
      cbe.State := directoryL1C1_RM_load;
      return;
    endalias;
    end;
    
    procedure FSM_Access_directoryL1C1_RM_store(adr:Address; m:OBJSET_directoryL1C1);
    var msg: Message;
    begin
    alias cbe: i_directoryL1C1[m].cb[adr] do
      msg := RequestL1C1(adr,Fwd_GetML1C1,m,cbe.ownerL1C1);
      Send_req(msg, m);
      Clear_perm(adr, m);
      cbe.State := directoryL1C1_RM_store;
      return;
    endalias;
    end;
    
    procedure FSM_Access_directoryL1C1_S_evict(adr:Address; m:OBJSET_directoryL1C1);
    begin
    alias cbe: i_directoryL1C1[m].cb[adr] do
      if !(VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
        Clear_perm(adr, m); Set_perm(load, adr, m);
        cbe.State := directoryL1C1_S;
        return;
      endif;
      if (VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
        Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
        cbe.State := directoryL1C1_I;
        return;
      endif;
    endalias;
    end;
    
    procedure FSM_Access_directoryL1C1_S_load(adr:Address; m:OBJSET_directoryL1C1);
    begin
    alias cbe: i_directoryL1C1[m].cb[adr] do
      Clear_perm(adr, m); Set_perm(load, adr, m);
      cbe.State := directoryL1C1_S;
      return;
    endalias;
    end;
    
    procedure FSM_Access_directoryL1C1_S_store(adr:Address; m:OBJSET_directoryL1C1);
    var msg: Message;
    begin
    alias cbe: i_directoryL1C1[m].cb[adr] do
      if (VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
        Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
        Store(cbe.cl, adr);
        cbe.State := directoryL1C1_M;
        return;
      endif;
      if !(VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
        msg := AckL1C1(adr,InvL1C1,m,m);
        Multicast_fwd_v_sharersL1C1(msg, cbe.sharersL1C1, m);
        Clear_perm(adr, m);
        cbe.State := directoryL1C1_S_store;
        return;
      endif;
    endalias;
    end;
    
  ----RevMurphi/MurphiModular/StateMachines/GenMessageStateMachines
    function FSM_MSG_cacheL1C1(inmsg:Message; m:OBJSET_cacheL1C1) : boolean;
    var msg: Message;
    begin
      alias adr: inmsg.adr do
      alias cbe: i_cacheL1C1[m].cb[adr] do
    switch cbe.State
      case cacheL1C1_I:
      switch inmsg.mtype
        case WBL1C1:
          cbe.cl := inmsg.cl;
          msg := RespL1C1(adr,WB_AckL1C1,m,directoryL1C1);
          Send_resp(msg, m);
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_I;
          return true;
        
        else return false;
      endswitch;
      
      case cacheL1C1_I_load:
      switch inmsg.mtype
        case GetS_AckL1C1:
          Clear_perm(adr, m); Set_perm(load, adr, m);
          cbe.State := cacheL1C1_S;
          return true;
        
        case WBL1C1:
          cbe.cl := inmsg.cl;
          msg := RespL1C1(adr,WB_AckL1C1,m,directoryL1C1);
          Send_resp(msg, m);
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_I_load;
          return true;
        
        else return false;
      endswitch;
      
      case cacheL1C1_I_store:
      switch inmsg.mtype
        case GetM_Ack_ADL1C1:
          cbe.acksExpectedL1C1 := inmsg.acksExpectedL1C1;
          if !(cbe.acksExpectedL1C1 = cbe.acksReceivedL1C1) then
            Clear_perm(adr, m);
            cbe.State := cacheL1C1_I_store_GetM_Ack_AD;
            return true;
          endif;
          if (cbe.acksExpectedL1C1 = cbe.acksReceivedL1C1) then
            Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
            cbe.State := cacheL1C1_M;
            return true;
          endif;
        
        case GetM_Ack_DL1C1:
          Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
          cbe.State := cacheL1C1_M;
          return true;
        
        case Inv_AckL1C1:
          cbe.acksReceivedL1C1 := cbe.acksReceivedL1C1+1;
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_I_store;
          return true;
        
        case WBL1C1:
          cbe.cl := inmsg.cl;
          msg := RespL1C1(adr,WB_AckL1C1,m,directoryL1C1);
          Send_resp(msg, m);
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_I_store;
          return true;
        
        else return false;
      endswitch;
      
      case cacheL1C1_I_store_GetM_Ack_AD:
      switch inmsg.mtype
        case Inv_AckL1C1:
          cbe.acksReceivedL1C1 := cbe.acksReceivedL1C1+1;
          if (cbe.acksExpectedL1C1 = cbe.acksReceivedL1C1) then
            Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
            cbe.State := cacheL1C1_M;
            return true;
          endif;
          if !(cbe.acksExpectedL1C1 = cbe.acksReceivedL1C1) then
            Clear_perm(adr, m);
            cbe.State := cacheL1C1_I_store_GetM_Ack_AD;
            return true;
          endif;
        
        else return false;
      endswitch;
      
      case cacheL1C1_I_x_M_Fwd_GetM:
      switch inmsg.mtype
        case WBL1C1:
          cbe.cl := inmsg.cl;
          msg := RespL1C1(adr,WB_AckL1C1,m,directoryL1C1);
          Send_resp(msg, m);
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_I_x_M_Fwd_GetM;
          return true;
        
        case WB_AckL1C1:
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_I;
          return true;
        
        else return false;
      endswitch;
      
      case cacheL1C1_M:
      switch inmsg.mtype
        case Fwd_GetML1C1:
          msg := Data_WBL1C1(adr,WBL1C1,inmsg.src,directoryL1C1,cbe.cl);
          Send_resp(msg, m);
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_M_Fwd_GetM;
          return true;
        
        case Fwd_GetSL1C1:
          msg := Data_WBL1C1(adr,WBL1C1,inmsg.src,directoryL1C1,cbe.cl);
          Send_resp(msg, m);
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_M_Fwd_GetS;
          return true;
        
        else return false;
      endswitch;
      
      case cacheL1C1_M_Fwd_GetM:
      switch inmsg.mtype
        case WB_AckL1C1:
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_I;
          return true;
        
        else return false;
      endswitch;
      
      case cacheL1C1_M_Fwd_GetS:
      switch inmsg.mtype
        case WB_AckL1C1:
          Clear_perm(adr, m); Set_perm(load, adr, m);
          cbe.State := cacheL1C1_S;
          return true;
        
        else return false;
      endswitch;
      
      case cacheL1C1_M_evict:
      switch inmsg.mtype
        case Fwd_GetML1C1:
          msg := Data_WBL1C1(adr,WBL1C1,inmsg.src,directoryL1C1,cbe.cl);
          Send_resp(msg, m);
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_M_evict_x_M_Fwd_GetM;
          return true;
        
        case Fwd_GetSL1C1:
          msg := Data_WBL1C1(adr,WBL1C1,inmsg.src,directoryL1C1,cbe.cl);
          Send_resp(msg, m);
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_S_evict_x_M_Fwd_GetS;
          return true;
        
        case Put_AckL1C1:
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_I;
          return true;
        
        else return false;
      endswitch;
      
      case cacheL1C1_M_evict_x_I:
      switch inmsg.mtype
        case Put_AckL1C1:
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_I;
          return true;
        
        case WBL1C1:
          cbe.cl := inmsg.cl;
          msg := RespL1C1(adr,WB_AckL1C1,m,directoryL1C1);
          Send_resp(msg, m);
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_M_evict_x_I;
          return true;
        
        else return false;
      endswitch;
      
      case cacheL1C1_M_evict_x_M_Fwd_GetM:
      switch inmsg.mtype
        case Put_AckL1C1:
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_I_x_M_Fwd_GetM;
          return true;
        
        case WBL1C1:
          cbe.cl := inmsg.cl;
          msg := RespL1C1(adr,WB_AckL1C1,m,directoryL1C1);
          Send_resp(msg, m);
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_M_evict_x_M_Fwd_GetM;
          return true;
        
        case WB_AckL1C1:
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_M_evict_x_I;
          return true;
        
        else return false;
      endswitch;
      
      case cacheL1C1_S:
      switch inmsg.mtype
        case InvL1C1:
          msg := AckL1C1(adr,Inv_AckL1C1,m,inmsg.src);
          Send_resp(msg, m);
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_I;
          return true;
        
        else return false;
      endswitch;
      
      case cacheL1C1_S_evict:
      switch inmsg.mtype
        case InvL1C1:
          msg := AckL1C1(adr,Inv_AckL1C1,m,inmsg.src);
          Send_resp(msg, m);
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_S_evict_x_I;
          return true;
        
        case Put_AckL1C1:
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_I;
          return true;
        
        else return false;
      endswitch;
      
      case cacheL1C1_S_evict_x_I:
      switch inmsg.mtype
        case Put_AckL1C1:
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_I;
          return true;
        
        case WBL1C1:
          cbe.cl := inmsg.cl;
          msg := RespL1C1(adr,WB_AckL1C1,m,directoryL1C1);
          Send_resp(msg, m);
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_S_evict_x_I;
          return true;
        
        else return false;
      endswitch;
      
      case cacheL1C1_S_evict_x_M_Fwd_GetS:
      switch inmsg.mtype
        case WB_AckL1C1:
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_S_evict;
          return true;
        
        else return false;
      endswitch;
      
      case cacheL1C1_S_store:
      switch inmsg.mtype
        case GetM_Ack_ADL1C1:
          cbe.acksExpectedL1C1 := inmsg.acksExpectedL1C1;
          if (cbe.acksExpectedL1C1 = cbe.acksReceivedL1C1) then
            Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
            cbe.State := cacheL1C1_M;
            return true;
          endif;
          if !(cbe.acksExpectedL1C1 = cbe.acksReceivedL1C1) then
            Clear_perm(adr, m);
            cbe.State := cacheL1C1_S_store_GetM_Ack_AD;
            return true;
          endif;
        
        case GetM_Ack_DL1C1:
          Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
          cbe.State := cacheL1C1_M;
          return true;
        
        case InvL1C1:
          msg := AckL1C1(adr,Inv_AckL1C1,m,inmsg.src);
          Send_resp(msg, m);
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_I_store;
          return true;
        
        case Inv_AckL1C1:
          cbe.acksReceivedL1C1 := cbe.acksReceivedL1C1+1;
          Clear_perm(adr, m);
          cbe.State := cacheL1C1_S_store;
          return true;
        
        else return false;
      endswitch;
      
      case cacheL1C1_S_store_GetM_Ack_AD:
      switch inmsg.mtype
        case Inv_AckL1C1:
          cbe.acksReceivedL1C1 := cbe.acksReceivedL1C1+1;
          if (cbe.acksExpectedL1C1 = cbe.acksReceivedL1C1) then
            Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
            cbe.State := cacheL1C1_M;
            return true;
          endif;
          if !(cbe.acksExpectedL1C1 = cbe.acksReceivedL1C1) then
            Clear_perm(adr, m);
            cbe.State := cacheL1C1_S_store_GetM_Ack_AD;
            return true;
          endif;
        
        else return false;
      endswitch;
      
    endswitch;
    endalias;
    endalias;
    return false;
    end;
    
    function FSM_MSG_directoryL1C1(inmsg:Message; m:OBJSET_directoryL1C1) : boolean;
    var msg: Message;
    begin
      alias adr: inmsg.adr do
      alias cbe: i_directoryL1C1[m].cb[adr] do
    switch cbe.State
      case directoryL1C1_I:
      switch inmsg.mtype
        case GetML1C1:
          msg := RespL1C1(adr,GetM_Ack_DL1C1,m,inmsg.src);
          Send_resp(msg, m);
          cbe.ownerL1C1 := inmsg.src;
          Clear_perm(adr, m);
          cbe.State := directoryL1C1_RM;
          return true;
        
        case GetSL1C1:
          AddElement_sharersL1C1(cbe.sharersL1C1, inmsg.src);
          msg := RespL1C1(adr,GetS_AckL1C1,m,inmsg.src);
          Send_resp(msg, m);
          Clear_perm(adr, m); Set_perm(load, adr, m);
          cbe.State := directoryL1C1_S;
          return true;
        
        case PutML1C1:
          msg := AckL1C1(adr,Put_AckL1C1,m,inmsg.src);
          Send_fwd(msg, m);
          if !(cbe.ownerL1C1 = inmsg.src) then
            Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
            cbe.State := directoryL1C1_I;
            return true;
          endif;
          if (cbe.ownerL1C1 = inmsg.src) then
            cbe.cl := inmsg.cl;
            Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
            cbe.State := directoryL1C1_I;
            return true;
          endif;
        
        case PutSL1C1:
          msg := AckL1C1(adr,Put_AckL1C1,m,inmsg.src);
          Send_fwd(msg, m);
          RemoveElement_sharersL1C1(cbe.sharersL1C1, inmsg.src);
          if !(VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
            Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
            cbe.State := directoryL1C1_I;
            return true;
          endif;
          if (VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
            Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
            cbe.State := directoryL1C1_I;
            return true;
          endif;
        
        else return false;
      endswitch;
      
      case directoryL1C1_M:
      switch inmsg.mtype
        case GetML1C1:
          msg := Data_WBL1C1(adr,WBL1C1,m,inmsg.src,cbe.cl);
          Send_fwd(msg, m);
          cbe.ownerL1C1 := inmsg.src;
          Clear_perm(adr, m);
          cbe.State := directoryL1C1_M_GetM;
          return true;
        
        case GetSL1C1:
          msg := Data_WBL1C1(adr,WBL1C1,m,inmsg.src,cbe.cl);
          Send_fwd(msg, m);
          AddElement_sharersL1C1(cbe.sharersL1C1, inmsg.src);
          Clear_perm(adr, m);
          cbe.State := directoryL1C1_M_GetS;
          return true;
        
        case PutML1C1:
          msg := AckL1C1(adr,Put_AckL1C1,m,inmsg.src);
          Send_fwd(msg, m);
          if (cbe.ownerL1C1 = inmsg.src) then
            cbe.cl := inmsg.cl;
            Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
            cbe.State := directoryL1C1_M;
            return true;
          endif;
          if !(cbe.ownerL1C1 = inmsg.src) then
            Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
            cbe.State := directoryL1C1_M;
            return true;
          endif;
        
        case PutSL1C1:
          msg := AckL1C1(adr,Put_AckL1C1,m,inmsg.src);
          Send_fwd(msg, m);
          RemoveElement_sharersL1C1(cbe.sharersL1C1, inmsg.src);
          if !(VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
            Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
            cbe.State := directoryL1C1_M;
            return true;
          endif;
          if (VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
            Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
            cbe.State := directoryL1C1_M;
            return true;
          endif;
        
        else return false;
      endswitch;
      
      case directoryL1C1_M_GetM:
      switch inmsg.mtype
        case WB_AckL1C1:
          msg := RespL1C1(adr,GetM_Ack_DL1C1,m,inmsg.src);
          Send_resp(msg, m);
          Clear_perm(adr, m);
          cbe.State := directoryL1C1_RM;
          return true;
        
        else return false;
      endswitch;
      
      case directoryL1C1_M_GetS:
      switch inmsg.mtype
        case WB_AckL1C1:
          msg := RespL1C1(adr,GetS_AckL1C1,m,inmsg.src);
          Send_resp(msg, m);
          Clear_perm(adr, m); Set_perm(load, adr, m);
          cbe.State := directoryL1C1_S;
          return true;
        
        else return false;
      endswitch;
      
      case directoryL1C1_M_evict:
      switch inmsg.mtype
        case WB_AckL1C1:
          Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
          cbe.State := directoryL1C1_I;
          return true;
        
        else return false;
      endswitch;
      
      case directoryL1C1_RM:
      switch inmsg.mtype
        case PutML1C1:
          msg := AckL1C1(adr,Put_AckL1C1,m,inmsg.src);
          Send_fwd(msg, m);
          if !(cbe.ownerL1C1 = inmsg.src) then
            Clear_perm(adr, m);
            cbe.State := directoryL1C1_RM;
            return true;
          endif;
          if (cbe.ownerL1C1 = inmsg.src) then
            cbe.cl := inmsg.cl;
            Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
            cbe.State := directoryL1C1_I;
            return true;
          endif;
        
        case PutSL1C1:
          msg := AckL1C1(adr,Put_AckL1C1,m,inmsg.src);
          Send_fwd(msg, m);
          if (cbe.ownerL1C1 = inmsg.src) then
            cbe.cl := inmsg.cl;
            Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
            cbe.State := directoryL1C1_I;
            return true;
          endif;
          if !(cbe.ownerL1C1 = inmsg.src) then
            Clear_perm(adr, m);
            cbe.State := directoryL1C1_RM;
            return true;
          endif;
        
        else return false;
      endswitch;
      
      case directoryL1C1_RM_load:
      switch inmsg.mtype
        case WBL1C1:
          AddElement_sharersL1C1(cbe.sharersL1C1, cbe.ownerL1C1);
          cbe.cl := inmsg.cl;
          msg := RespL1C1(adr,WB_AckL1C1,m,cbe.ownerL1C1);
          Send_resp(msg, m);
          cbe.ownerL1C1 := m;
          Clear_perm(adr, m); Set_perm(load, adr, m);
          cbe.State := directoryL1C1_S;
          return true;
        
        else return false;
      endswitch;
      
      case directoryL1C1_RM_store:
      switch inmsg.mtype
        case WBL1C1:
          cbe.cl := inmsg.cl;
          msg := RespL1C1(adr,WB_AckL1C1,m,cbe.ownerL1C1);
          Send_resp(msg, m);
          cbe.ownerL1C1 := m;
          Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
          cbe.State := directoryL1C1_M;
          return true;
        
        else return false;
      endswitch;
      
      case directoryL1C1_S:
      switch inmsg.mtype
        case GetML1C1:
          if !(IsElement_sharersL1C1(cbe.sharersL1C1, inmsg.src)) then
            if !(VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
              msg := RespAckL1C1(adr,GetM_Ack_ADL1C1,m,inmsg.src,VectorCount_sharersL1C1(cbe.sharersL1C1));
              Send_resp(msg, m);
              msg := AckL1C1(adr,InvL1C1,inmsg.src,inmsg.src);
              Multicast_fwd_v_sharersL1C1(msg, cbe.sharersL1C1, m);
              cbe.ownerL1C1 := inmsg.src;
              ClearVector_sharersL1C1(cbe.sharersL1C1);
              Clear_perm(adr, m);
              cbe.State := directoryL1C1_RM;
              return true;
            endif;
            if (VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
              msg := RespL1C1(adr,GetM_Ack_DL1C1,m,inmsg.src);
              Send_resp(msg, m);
              cbe.ownerL1C1 := inmsg.src;
              ClearVector_sharersL1C1(cbe.sharersL1C1);
              Clear_perm(adr, m);
              cbe.State := directoryL1C1_RM;
              return true;
            endif;
          endif;
          if (IsElement_sharersL1C1(cbe.sharersL1C1, inmsg.src)) then
            RemoveElement_sharersL1C1(cbe.sharersL1C1, inmsg.src);
            if !(VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
              msg := RespAckL1C1(adr,GetM_Ack_ADL1C1,m,inmsg.src,VectorCount_sharersL1C1(cbe.sharersL1C1));
              Send_resp(msg, m);
              msg := AckL1C1(adr,InvL1C1,inmsg.src,inmsg.src);
              Multicast_fwd_v_sharersL1C1(msg, cbe.sharersL1C1, m);
              cbe.ownerL1C1 := inmsg.src;
              ClearVector_sharersL1C1(cbe.sharersL1C1);
              Clear_perm(adr, m);
              cbe.State := directoryL1C1_RM;
              return true;
            endif;
            if (VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
              msg := RespL1C1(adr,GetM_Ack_DL1C1,m,inmsg.src);
              Send_resp(msg, m);
              cbe.ownerL1C1 := inmsg.src;
              ClearVector_sharersL1C1(cbe.sharersL1C1);
              Clear_perm(adr, m);
              cbe.State := directoryL1C1_RM;
              return true;
            endif;
          endif;
        
        case GetSL1C1:
          AddElement_sharersL1C1(cbe.sharersL1C1, inmsg.src);
          msg := RespL1C1(adr,GetS_AckL1C1,m,inmsg.src);
          Send_resp(msg, m);
          Clear_perm(adr, m); Set_perm(load, adr, m);
          cbe.State := directoryL1C1_S;
          return true;
        
        case PutML1C1:
          msg := AckL1C1(adr,Put_AckL1C1,m,inmsg.src);
          Send_fwd(msg, m);
          RemoveElement_sharersL1C1(cbe.sharersL1C1, inmsg.src);
          if (VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
            Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
            cbe.State := directoryL1C1_I;
            return true;
          endif;
          if !(VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
            Clear_perm(adr, m); Set_perm(load, adr, m);
            cbe.State := directoryL1C1_S;
            return true;
          endif;
        
        case PutSL1C1:
          msg := AckL1C1(adr,Put_AckL1C1,m,inmsg.src);
          Send_fwd(msg, m);
          RemoveElement_sharersL1C1(cbe.sharersL1C1, inmsg.src);
          if (VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
            Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
            cbe.State := directoryL1C1_I;
            return true;
          endif;
          if !(VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
            Clear_perm(adr, m); Set_perm(load, adr, m);
            cbe.State := directoryL1C1_S;
            return true;
          endif;
        
        else return false;
      endswitch;
      
      case directoryL1C1_S_store:
      switch inmsg.mtype
        case Inv_AckL1C1:
          RemoveElement_sharersL1C1(cbe.sharersL1C1, inmsg.src);
          if (VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
            Clear_perm(adr, m); Set_perm(store, adr, m); Set_perm(load, adr, m);
            cbe.State := directoryL1C1_M;
            return true;
          endif;
          if !(VectorCount_sharersL1C1(cbe.sharersL1C1) = 0) then
            Clear_perm(adr, m);
            cbe.State := directoryL1C1_S_store;
            return true;
          endif;
        
        else return false;
      endswitch;
      
    endswitch;
    endalias;
    endalias;
    return false;
    end;
    

--RevMurphi/MurphiModular/GenResetFunc

  procedure System_Reset();
  begin
  Reset_perm();
  Reset_global_monitor();
  Reset_NET_();
  ResetMachine_();
  end;
  

--RevMurphi/MurphiModular/GenRules
  ----RevMurphi/MurphiModular/Rules/GenAccessRuleSet
    ruleset m:OBJSET_cacheL1C1 do
    ruleset adr:Address do
      alias cbe:i_cacheL1C1[m].cb[adr] do
    
      rule "cacheL1C1_I_store"
        cbe.State = cacheL1C1_I & network_ready() 
      ==>
        FSM_Access_cacheL1C1_I_store(adr, m);
        
      endrule;
    
      rule "cacheL1C1_I_load"
        cbe.State = cacheL1C1_I & network_ready() 
      ==>
        FSM_Access_cacheL1C1_I_load(adr, m);
        
      endrule;
    
      rule "cacheL1C1_M_evict"
        cbe.State = cacheL1C1_M & network_ready() 
      ==>
        FSM_Access_cacheL1C1_M_evict(adr, m);
        
      endrule;
    
      rule "cacheL1C1_M_store"
        cbe.State = cacheL1C1_M 
      ==>
        FSM_Access_cacheL1C1_M_store(adr, m);
        
      endrule;
    
      rule "cacheL1C1_M_load"
        cbe.State = cacheL1C1_M 
      ==>
        FSM_Access_cacheL1C1_M_load(adr, m);
        
      endrule;
    
      rule "cacheL1C1_S_load"
        cbe.State = cacheL1C1_S 
      ==>
        FSM_Access_cacheL1C1_S_load(adr, m);
        
      endrule;
    
      rule "cacheL1C1_S_evict"
        cbe.State = cacheL1C1_S & network_ready() 
      ==>
        FSM_Access_cacheL1C1_S_evict(adr, m);
        
      endrule;
    
      rule "cacheL1C1_S_store"
        cbe.State = cacheL1C1_S & network_ready() 
      ==>
        FSM_Access_cacheL1C1_S_store(adr, m);
        
      endrule;
    
    
      endalias;
    endruleset;
    endruleset;
    
    ruleset m:OBJSET_directoryL1C1 do
    ruleset adr:Address do
      alias cbe:i_directoryL1C1[m].cb[adr] do
    
      rule "directoryL1C1_I_store"
        cbe.State = directoryL1C1_I 
      ==>
        FSM_Access_directoryL1C1_I_store(adr, m);
        
      endrule;
    
      rule "directoryL1C1_I_load"
        cbe.State = directoryL1C1_I 
      ==>
        FSM_Access_directoryL1C1_I_load(adr, m);
        
      endrule;
    
      rule "directoryL1C1_M_evict"
        cbe.State = directoryL1C1_M & network_ready() 
      ==>
        FSM_Access_directoryL1C1_M_evict(adr, m);
        
      endrule;
    
      rule "directoryL1C1_M_store"
        cbe.State = directoryL1C1_M 
      ==>
        FSM_Access_directoryL1C1_M_store(adr, m);
        
      endrule;
    
      rule "directoryL1C1_M_load"
        cbe.State = directoryL1C1_M 
      ==>
        FSM_Access_directoryL1C1_M_load(adr, m);
        
      endrule;
    
      rule "directoryL1C1_RM_store"
        cbe.State = directoryL1C1_RM & network_ready() 
      ==>
        FSM_Access_directoryL1C1_RM_store(adr, m);
        
      endrule;
    
      rule "directoryL1C1_RM_load"
        cbe.State = directoryL1C1_RM & network_ready() 
      ==>
        FSM_Access_directoryL1C1_RM_load(adr, m);
        
      endrule;
    
      rule "directoryL1C1_RM_evict"
        cbe.State = directoryL1C1_RM 
      ==>
        FSM_Access_directoryL1C1_RM_evict(adr, m);
        
      endrule;
    
      rule "directoryL1C1_S_evict"
        cbe.State = directoryL1C1_S 
      ==>
        FSM_Access_directoryL1C1_S_evict(adr, m);
        
      endrule;
    
      rule "directoryL1C1_S_load"
        cbe.State = directoryL1C1_S 
      ==>
        FSM_Access_directoryL1C1_S_load(adr, m);
        
      endrule;
    
      rule "directoryL1C1_S_store"
        cbe.State = directoryL1C1_S & network_ready() 
      ==>
        FSM_Access_directoryL1C1_S_store(adr, m);
        
      endrule;
    
    
      endalias;
    endruleset;
    endruleset;
    
  ----RevMurphi/MurphiModular/Rules/GenEventRuleSet
  ----RevMurphi/MurphiModular/Rules/GenNetworkRule
    ruleset dst:Machines do
        ruleset src: Machines do
            alias msg:resp[dst][0] do
              rule "Receive resp"
                cnt_resp[dst] > 0
              ==>
            if IsMember(dst, OBJSET_directoryL1C1) then
              if FSM_MSG_directoryL1C1(msg, dst) then
                  Pop_resp(dst, src);
              endif;
            elsif IsMember(dst, OBJSET_cacheL1C1) then
              if FSM_MSG_cacheL1C1(msg, dst) then
                  Pop_resp(dst, src);
              endif;
            else error "unknown machine";
            endif;
    
              endrule;
            endalias;
        endruleset;
    endruleset;
    
    ruleset dst:Machines do
        ruleset src: Machines do
            alias msg:req[dst][0] do
              rule "Receive req"
                cnt_req[dst] > 0
              ==>
            if IsMember(dst, OBJSET_directoryL1C1) then
              if FSM_MSG_directoryL1C1(msg, dst) then
                  Pop_req(dst, src);
              endif;
            elsif IsMember(dst, OBJSET_cacheL1C1) then
              if FSM_MSG_cacheL1C1(msg, dst) then
                  Pop_req(dst, src);
              endif;
            else error "unknown machine";
            endif;
    
              endrule;
            endalias;
        endruleset;
    endruleset;
    
    ruleset dst:Machines do
        ruleset src: Machines do
            alias msg:fwd[dst][0] do
              rule "Receive fwd"
                cnt_fwd[dst] > 0
              ==>
            if IsMember(dst, OBJSET_directoryL1C1) then
              if FSM_MSG_directoryL1C1(msg, dst) then
                  Pop_fwd(dst, src);
              endif;
            elsif IsMember(dst, OBJSET_cacheL1C1) then
              if FSM_MSG_cacheL1C1(msg, dst) then
                  Pop_fwd(dst, src);
              endif;
            else error "unknown machine";
            endif;
    
              endrule;
            endalias;
        endruleset;
    endruleset;
    

--RevMurphi/MurphiModular/GenStartStates

  startstate
    System_Reset();
  endstartstate;

--RevMurphi/MurphiModular/GenInvariant
  invariant "exclusive store check"
      forall a:Address do
          forall m1:Machines do
          forall m2:Machines do
          ( m1 != m2
            & MultiSetCount(i:g_perm[m1][a], g_perm[m1][a][i] = store) > 0)
          ->
            MultiSetCount(i:g_perm[m2][a], g_perm[m2][a][i] = store) = 0
          endforall
          endforall
      endforall;
  
  
  
  invariant "store excludes load check"
      forall a:Address do
          forall m1:Machines do
          forall m2:Machines do
          ( m1 != m2
            & MultiSetCount(i:g_perm[m1][a], g_perm[m1][a][i] = store) > 0)
          ->
            MultiSetCount(i:g_perm[m2][a], g_perm[m2][a][i] = load) = 0
          endforall
          endforall
      endforall;
  
