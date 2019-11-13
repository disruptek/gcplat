
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Stackdriver Debugger
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Examines the call stack and variables of a running application without stopping or slowing it down.
## 
## 
## https://cloud.google.com/debugger
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_579364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579364): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "clouddebugger"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClouddebuggerControllerDebuggeesRegister_579635 = ref object of OpenApiRestCall_579364
proc url_ClouddebuggerControllerDebuggeesRegister_579637(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ClouddebuggerControllerDebuggeesRegister_579636(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Registers the debuggee with the controller service.
  ## 
  ## All agents attached to the same application must call this method with
  ## exactly the same request content to get back the same stable `debuggee_id`.
  ## Agents should call this method again whenever `google.rpc.Code.NOT_FOUND`
  ## is returned from any controller method.
  ## 
  ## This protocol allows the controller service to disable debuggees, recover
  ## from data loss, or change the `debuggee_id` format. Agents must handle
  ## `debuggee_id` value changing upon re-registration.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579749 = query.getOrDefault("key")
  valid_579749 = validateParameter(valid_579749, JString, required = false,
                                 default = nil)
  if valid_579749 != nil:
    section.add "key", valid_579749
  var valid_579763 = query.getOrDefault("prettyPrint")
  valid_579763 = validateParameter(valid_579763, JBool, required = false,
                                 default = newJBool(true))
  if valid_579763 != nil:
    section.add "prettyPrint", valid_579763
  var valid_579764 = query.getOrDefault("oauth_token")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "oauth_token", valid_579764
  var valid_579765 = query.getOrDefault("$.xgafv")
  valid_579765 = validateParameter(valid_579765, JString, required = false,
                                 default = newJString("1"))
  if valid_579765 != nil:
    section.add "$.xgafv", valid_579765
  var valid_579766 = query.getOrDefault("alt")
  valid_579766 = validateParameter(valid_579766, JString, required = false,
                                 default = newJString("json"))
  if valid_579766 != nil:
    section.add "alt", valid_579766
  var valid_579767 = query.getOrDefault("uploadType")
  valid_579767 = validateParameter(valid_579767, JString, required = false,
                                 default = nil)
  if valid_579767 != nil:
    section.add "uploadType", valid_579767
  var valid_579768 = query.getOrDefault("quotaUser")
  valid_579768 = validateParameter(valid_579768, JString, required = false,
                                 default = nil)
  if valid_579768 != nil:
    section.add "quotaUser", valid_579768
  var valid_579769 = query.getOrDefault("callback")
  valid_579769 = validateParameter(valid_579769, JString, required = false,
                                 default = nil)
  if valid_579769 != nil:
    section.add "callback", valid_579769
  var valid_579770 = query.getOrDefault("fields")
  valid_579770 = validateParameter(valid_579770, JString, required = false,
                                 default = nil)
  if valid_579770 != nil:
    section.add "fields", valid_579770
  var valid_579771 = query.getOrDefault("access_token")
  valid_579771 = validateParameter(valid_579771, JString, required = false,
                                 default = nil)
  if valid_579771 != nil:
    section.add "access_token", valid_579771
  var valid_579772 = query.getOrDefault("upload_protocol")
  valid_579772 = validateParameter(valid_579772, JString, required = false,
                                 default = nil)
  if valid_579772 != nil:
    section.add "upload_protocol", valid_579772
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579796: Call_ClouddebuggerControllerDebuggeesRegister_579635;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Registers the debuggee with the controller service.
  ## 
  ## All agents attached to the same application must call this method with
  ## exactly the same request content to get back the same stable `debuggee_id`.
  ## Agents should call this method again whenever `google.rpc.Code.NOT_FOUND`
  ## is returned from any controller method.
  ## 
  ## This protocol allows the controller service to disable debuggees, recover
  ## from data loss, or change the `debuggee_id` format. Agents must handle
  ## `debuggee_id` value changing upon re-registration.
  ## 
  let valid = call_579796.validator(path, query, header, formData, body)
  let scheme = call_579796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579796.url(scheme.get, call_579796.host, call_579796.base,
                         call_579796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579796, url, valid)

proc call*(call_579867: Call_ClouddebuggerControllerDebuggeesRegister_579635;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## clouddebuggerControllerDebuggeesRegister
  ## Registers the debuggee with the controller service.
  ## 
  ## All agents attached to the same application must call this method with
  ## exactly the same request content to get back the same stable `debuggee_id`.
  ## Agents should call this method again whenever `google.rpc.Code.NOT_FOUND`
  ## is returned from any controller method.
  ## 
  ## This protocol allows the controller service to disable debuggees, recover
  ## from data loss, or change the `debuggee_id` format. Agents must handle
  ## `debuggee_id` value changing upon re-registration.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579868 = newJObject()
  var body_579870 = newJObject()
  add(query_579868, "key", newJString(key))
  add(query_579868, "prettyPrint", newJBool(prettyPrint))
  add(query_579868, "oauth_token", newJString(oauthToken))
  add(query_579868, "$.xgafv", newJString(Xgafv))
  add(query_579868, "alt", newJString(alt))
  add(query_579868, "uploadType", newJString(uploadType))
  add(query_579868, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579870 = body
  add(query_579868, "callback", newJString(callback))
  add(query_579868, "fields", newJString(fields))
  add(query_579868, "access_token", newJString(accessToken))
  add(query_579868, "upload_protocol", newJString(uploadProtocol))
  result = call_579867.call(nil, query_579868, nil, nil, body_579870)

var clouddebuggerControllerDebuggeesRegister* = Call_ClouddebuggerControllerDebuggeesRegister_579635(
    name: "clouddebuggerControllerDebuggeesRegister", meth: HttpMethod.HttpPost,
    host: "clouddebugger.googleapis.com",
    route: "/v2/controller/debuggees/register",
    validator: validate_ClouddebuggerControllerDebuggeesRegister_579636,
    base: "/", url: url_ClouddebuggerControllerDebuggeesRegister_579637,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerControllerDebuggeesBreakpointsList_579909 = ref object of OpenApiRestCall_579364
proc url_ClouddebuggerControllerDebuggeesBreakpointsList_579911(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "debuggeeId" in path, "`debuggeeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/controller/debuggees/"),
               (kind: VariableSegment, value: "debuggeeId"),
               (kind: ConstantSegment, value: "/breakpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ClouddebuggerControllerDebuggeesBreakpointsList_579910(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the list of all active breakpoints for the debuggee.
  ## 
  ## The breakpoint specification (`location`, `condition`, and `expressions`
  ## fields) is semantically immutable, although the field values may
  ## change. For example, an agent may update the location line number
  ## to reflect the actual line where the breakpoint was set, but this
  ## doesn't change the breakpoint semantics.
  ## 
  ## This means that an agent does not need to check if a breakpoint has changed
  ## when it encounters the same breakpoint on a successive call.
  ## Moreover, an agent should remember the breakpoints that are completed
  ## until the controller removes them from the active list to avoid
  ## setting those breakpoints again.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   debuggeeId: JString (required)
  ##             : Required. Identifies the debuggee.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `debuggeeId` field"
  var valid_579926 = path.getOrDefault("debuggeeId")
  valid_579926 = validateParameter(valid_579926, JString, required = true,
                                 default = nil)
  if valid_579926 != nil:
    section.add "debuggeeId", valid_579926
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   waitToken: JString
  ##            : A token that, if specified, blocks the method call until the list
  ## of active breakpoints has changed, or a server-selected timeout has
  ## expired. The value should be set from the `next_wait_token` field in
  ## the last response. The initial value should be set to `"init"`.
  ##   successOnTimeout: JBool
  ##                   : If set to `true` (recommended), returns `google.rpc.Code.OK` status and
  ## sets the `wait_expired` response field to `true` when the server-selected
  ## timeout has expired.
  ## 
  ## If set to `false` (deprecated), returns `google.rpc.Code.ABORTED` status
  ## when the server-selected timeout has expired.
  section = newJObject()
  var valid_579927 = query.getOrDefault("key")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = nil)
  if valid_579927 != nil:
    section.add "key", valid_579927
  var valid_579928 = query.getOrDefault("prettyPrint")
  valid_579928 = validateParameter(valid_579928, JBool, required = false,
                                 default = newJBool(true))
  if valid_579928 != nil:
    section.add "prettyPrint", valid_579928
  var valid_579929 = query.getOrDefault("oauth_token")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "oauth_token", valid_579929
  var valid_579930 = query.getOrDefault("$.xgafv")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = newJString("1"))
  if valid_579930 != nil:
    section.add "$.xgafv", valid_579930
  var valid_579931 = query.getOrDefault("alt")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = newJString("json"))
  if valid_579931 != nil:
    section.add "alt", valid_579931
  var valid_579932 = query.getOrDefault("uploadType")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "uploadType", valid_579932
  var valid_579933 = query.getOrDefault("quotaUser")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "quotaUser", valid_579933
  var valid_579934 = query.getOrDefault("callback")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = nil)
  if valid_579934 != nil:
    section.add "callback", valid_579934
  var valid_579935 = query.getOrDefault("fields")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "fields", valid_579935
  var valid_579936 = query.getOrDefault("access_token")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "access_token", valid_579936
  var valid_579937 = query.getOrDefault("upload_protocol")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "upload_protocol", valid_579937
  var valid_579938 = query.getOrDefault("waitToken")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "waitToken", valid_579938
  var valid_579939 = query.getOrDefault("successOnTimeout")
  valid_579939 = validateParameter(valid_579939, JBool, required = false, default = nil)
  if valid_579939 != nil:
    section.add "successOnTimeout", valid_579939
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579940: Call_ClouddebuggerControllerDebuggeesBreakpointsList_579909;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the list of all active breakpoints for the debuggee.
  ## 
  ## The breakpoint specification (`location`, `condition`, and `expressions`
  ## fields) is semantically immutable, although the field values may
  ## change. For example, an agent may update the location line number
  ## to reflect the actual line where the breakpoint was set, but this
  ## doesn't change the breakpoint semantics.
  ## 
  ## This means that an agent does not need to check if a breakpoint has changed
  ## when it encounters the same breakpoint on a successive call.
  ## Moreover, an agent should remember the breakpoints that are completed
  ## until the controller removes them from the active list to avoid
  ## setting those breakpoints again.
  ## 
  let valid = call_579940.validator(path, query, header, formData, body)
  let scheme = call_579940.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579940.url(scheme.get, call_579940.host, call_579940.base,
                         call_579940.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579940, url, valid)

proc call*(call_579941: Call_ClouddebuggerControllerDebuggeesBreakpointsList_579909;
          debuggeeId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          waitToken: string = ""; successOnTimeout: bool = false): Recallable =
  ## clouddebuggerControllerDebuggeesBreakpointsList
  ## Returns the list of all active breakpoints for the debuggee.
  ## 
  ## The breakpoint specification (`location`, `condition`, and `expressions`
  ## fields) is semantically immutable, although the field values may
  ## change. For example, an agent may update the location line number
  ## to reflect the actual line where the breakpoint was set, but this
  ## doesn't change the breakpoint semantics.
  ## 
  ## This means that an agent does not need to check if a breakpoint has changed
  ## when it encounters the same breakpoint on a successive call.
  ## Moreover, an agent should remember the breakpoints that are completed
  ## until the controller removes them from the active list to avoid
  ## setting those breakpoints again.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   debuggeeId: string (required)
  ##             : Required. Identifies the debuggee.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   waitToken: string
  ##            : A token that, if specified, blocks the method call until the list
  ## of active breakpoints has changed, or a server-selected timeout has
  ## expired. The value should be set from the `next_wait_token` field in
  ## the last response. The initial value should be set to `"init"`.
  ##   successOnTimeout: bool
  ##                   : If set to `true` (recommended), returns `google.rpc.Code.OK` status and
  ## sets the `wait_expired` response field to `true` when the server-selected
  ## timeout has expired.
  ## 
  ## If set to `false` (deprecated), returns `google.rpc.Code.ABORTED` status
  ## when the server-selected timeout has expired.
  var path_579942 = newJObject()
  var query_579943 = newJObject()
  add(query_579943, "key", newJString(key))
  add(query_579943, "prettyPrint", newJBool(prettyPrint))
  add(query_579943, "oauth_token", newJString(oauthToken))
  add(query_579943, "$.xgafv", newJString(Xgafv))
  add(query_579943, "alt", newJString(alt))
  add(query_579943, "uploadType", newJString(uploadType))
  add(query_579943, "quotaUser", newJString(quotaUser))
  add(path_579942, "debuggeeId", newJString(debuggeeId))
  add(query_579943, "callback", newJString(callback))
  add(query_579943, "fields", newJString(fields))
  add(query_579943, "access_token", newJString(accessToken))
  add(query_579943, "upload_protocol", newJString(uploadProtocol))
  add(query_579943, "waitToken", newJString(waitToken))
  add(query_579943, "successOnTimeout", newJBool(successOnTimeout))
  result = call_579941.call(path_579942, query_579943, nil, nil, nil)

var clouddebuggerControllerDebuggeesBreakpointsList* = Call_ClouddebuggerControllerDebuggeesBreakpointsList_579909(
    name: "clouddebuggerControllerDebuggeesBreakpointsList",
    meth: HttpMethod.HttpGet, host: "clouddebugger.googleapis.com",
    route: "/v2/controller/debuggees/{debuggeeId}/breakpoints",
    validator: validate_ClouddebuggerControllerDebuggeesBreakpointsList_579910,
    base: "/", url: url_ClouddebuggerControllerDebuggeesBreakpointsList_579911,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_579944 = ref object of OpenApiRestCall_579364
proc url_ClouddebuggerControllerDebuggeesBreakpointsUpdate_579946(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "debuggeeId" in path, "`debuggeeId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/controller/debuggees/"),
               (kind: VariableSegment, value: "debuggeeId"),
               (kind: ConstantSegment, value: "/breakpoints/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ClouddebuggerControllerDebuggeesBreakpointsUpdate_579945(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the breakpoint state or mutable fields.
  ## The entire Breakpoint message must be sent back to the controller service.
  ## 
  ## Updates to active breakpoint fields are only allowed if the new value
  ## does not change the breakpoint specification. Updates to the `location`,
  ## `condition` and `expressions` fields should not alter the breakpoint
  ## semantics. These may only make changes such as canonicalizing a value
  ## or snapping the location to the correct line of code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Breakpoint identifier, unique in the scope of the debuggee.
  ##   debuggeeId: JString (required)
  ##             : Required. Identifies the debuggee being debugged.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_579947 = path.getOrDefault("id")
  valid_579947 = validateParameter(valid_579947, JString, required = true,
                                 default = nil)
  if valid_579947 != nil:
    section.add "id", valid_579947
  var valid_579948 = path.getOrDefault("debuggeeId")
  valid_579948 = validateParameter(valid_579948, JString, required = true,
                                 default = nil)
  if valid_579948 != nil:
    section.add "debuggeeId", valid_579948
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579949 = query.getOrDefault("key")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "key", valid_579949
  var valid_579950 = query.getOrDefault("prettyPrint")
  valid_579950 = validateParameter(valid_579950, JBool, required = false,
                                 default = newJBool(true))
  if valid_579950 != nil:
    section.add "prettyPrint", valid_579950
  var valid_579951 = query.getOrDefault("oauth_token")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "oauth_token", valid_579951
  var valid_579952 = query.getOrDefault("$.xgafv")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = newJString("1"))
  if valid_579952 != nil:
    section.add "$.xgafv", valid_579952
  var valid_579953 = query.getOrDefault("alt")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = newJString("json"))
  if valid_579953 != nil:
    section.add "alt", valid_579953
  var valid_579954 = query.getOrDefault("uploadType")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "uploadType", valid_579954
  var valid_579955 = query.getOrDefault("quotaUser")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "quotaUser", valid_579955
  var valid_579956 = query.getOrDefault("callback")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "callback", valid_579956
  var valid_579957 = query.getOrDefault("fields")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "fields", valid_579957
  var valid_579958 = query.getOrDefault("access_token")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "access_token", valid_579958
  var valid_579959 = query.getOrDefault("upload_protocol")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "upload_protocol", valid_579959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579961: Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_579944;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the breakpoint state or mutable fields.
  ## The entire Breakpoint message must be sent back to the controller service.
  ## 
  ## Updates to active breakpoint fields are only allowed if the new value
  ## does not change the breakpoint specification. Updates to the `location`,
  ## `condition` and `expressions` fields should not alter the breakpoint
  ## semantics. These may only make changes such as canonicalizing a value
  ## or snapping the location to the correct line of code.
  ## 
  let valid = call_579961.validator(path, query, header, formData, body)
  let scheme = call_579961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579961.url(scheme.get, call_579961.host, call_579961.base,
                         call_579961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579961, url, valid)

proc call*(call_579962: Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_579944;
          id: string; debuggeeId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## clouddebuggerControllerDebuggeesBreakpointsUpdate
  ## Updates the breakpoint state or mutable fields.
  ## The entire Breakpoint message must be sent back to the controller service.
  ## 
  ## Updates to active breakpoint fields are only allowed if the new value
  ## does not change the breakpoint specification. Updates to the `location`,
  ## `condition` and `expressions` fields should not alter the breakpoint
  ## semantics. These may only make changes such as canonicalizing a value
  ## or snapping the location to the correct line of code.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Breakpoint identifier, unique in the scope of the debuggee.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   debuggeeId: string (required)
  ##             : Required. Identifies the debuggee being debugged.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579963 = newJObject()
  var query_579964 = newJObject()
  var body_579965 = newJObject()
  add(query_579964, "key", newJString(key))
  add(query_579964, "prettyPrint", newJBool(prettyPrint))
  add(query_579964, "oauth_token", newJString(oauthToken))
  add(query_579964, "$.xgafv", newJString(Xgafv))
  add(path_579963, "id", newJString(id))
  add(query_579964, "alt", newJString(alt))
  add(query_579964, "uploadType", newJString(uploadType))
  add(query_579964, "quotaUser", newJString(quotaUser))
  add(path_579963, "debuggeeId", newJString(debuggeeId))
  if body != nil:
    body_579965 = body
  add(query_579964, "callback", newJString(callback))
  add(query_579964, "fields", newJString(fields))
  add(query_579964, "access_token", newJString(accessToken))
  add(query_579964, "upload_protocol", newJString(uploadProtocol))
  result = call_579962.call(path_579963, query_579964, nil, nil, body_579965)

var clouddebuggerControllerDebuggeesBreakpointsUpdate* = Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_579944(
    name: "clouddebuggerControllerDebuggeesBreakpointsUpdate",
    meth: HttpMethod.HttpPut, host: "clouddebugger.googleapis.com",
    route: "/v2/controller/debuggees/{debuggeeId}/breakpoints/{id}",
    validator: validate_ClouddebuggerControllerDebuggeesBreakpointsUpdate_579945,
    base: "/", url: url_ClouddebuggerControllerDebuggeesBreakpointsUpdate_579946,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesList_579966 = ref object of OpenApiRestCall_579364
proc url_ClouddebuggerDebuggerDebuggeesList_579968(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ClouddebuggerDebuggerDebuggeesList_579967(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the debuggees that the user has access to.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   project: JString
  ##          : Required. Project number of a Google Cloud project whose debuggees to list.
  ##   callback: JString
  ##           : JSONP
  ##   includeInactive: JBool
  ##                  : When set to `true`, the result includes all debuggees. Otherwise, the
  ## result includes only debuggees that are active.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   clientVersion: JString
  ##                : Required. The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  section = newJObject()
  var valid_579969 = query.getOrDefault("key")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "key", valid_579969
  var valid_579970 = query.getOrDefault("prettyPrint")
  valid_579970 = validateParameter(valid_579970, JBool, required = false,
                                 default = newJBool(true))
  if valid_579970 != nil:
    section.add "prettyPrint", valid_579970
  var valid_579971 = query.getOrDefault("oauth_token")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "oauth_token", valid_579971
  var valid_579972 = query.getOrDefault("$.xgafv")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("1"))
  if valid_579972 != nil:
    section.add "$.xgafv", valid_579972
  var valid_579973 = query.getOrDefault("alt")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = newJString("json"))
  if valid_579973 != nil:
    section.add "alt", valid_579973
  var valid_579974 = query.getOrDefault("uploadType")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "uploadType", valid_579974
  var valid_579975 = query.getOrDefault("quotaUser")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "quotaUser", valid_579975
  var valid_579976 = query.getOrDefault("project")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "project", valid_579976
  var valid_579977 = query.getOrDefault("callback")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "callback", valid_579977
  var valid_579978 = query.getOrDefault("includeInactive")
  valid_579978 = validateParameter(valid_579978, JBool, required = false, default = nil)
  if valid_579978 != nil:
    section.add "includeInactive", valid_579978
  var valid_579979 = query.getOrDefault("fields")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "fields", valid_579979
  var valid_579980 = query.getOrDefault("access_token")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "access_token", valid_579980
  var valid_579981 = query.getOrDefault("upload_protocol")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "upload_protocol", valid_579981
  var valid_579982 = query.getOrDefault("clientVersion")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "clientVersion", valid_579982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579983: Call_ClouddebuggerDebuggerDebuggeesList_579966;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the debuggees that the user has access to.
  ## 
  let valid = call_579983.validator(path, query, header, formData, body)
  let scheme = call_579983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579983.url(scheme.get, call_579983.host, call_579983.base,
                         call_579983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579983, url, valid)

proc call*(call_579984: Call_ClouddebuggerDebuggerDebuggeesList_579966;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; project: string = ""; callback: string = "";
          includeInactive: bool = false; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; clientVersion: string = ""): Recallable =
  ## clouddebuggerDebuggerDebuggeesList
  ## Lists all the debuggees that the user has access to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   project: string
  ##          : Required. Project number of a Google Cloud project whose debuggees to list.
  ##   callback: string
  ##           : JSONP
  ##   includeInactive: bool
  ##                  : When set to `true`, the result includes all debuggees. Otherwise, the
  ## result includes only debuggees that are active.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   clientVersion: string
  ##                : Required. The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  var query_579985 = newJObject()
  add(query_579985, "key", newJString(key))
  add(query_579985, "prettyPrint", newJBool(prettyPrint))
  add(query_579985, "oauth_token", newJString(oauthToken))
  add(query_579985, "$.xgafv", newJString(Xgafv))
  add(query_579985, "alt", newJString(alt))
  add(query_579985, "uploadType", newJString(uploadType))
  add(query_579985, "quotaUser", newJString(quotaUser))
  add(query_579985, "project", newJString(project))
  add(query_579985, "callback", newJString(callback))
  add(query_579985, "includeInactive", newJBool(includeInactive))
  add(query_579985, "fields", newJString(fields))
  add(query_579985, "access_token", newJString(accessToken))
  add(query_579985, "upload_protocol", newJString(uploadProtocol))
  add(query_579985, "clientVersion", newJString(clientVersion))
  result = call_579984.call(nil, query_579985, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesList* = Call_ClouddebuggerDebuggerDebuggeesList_579966(
    name: "clouddebuggerDebuggerDebuggeesList", meth: HttpMethod.HttpGet,
    host: "clouddebugger.googleapis.com", route: "/v2/debugger/debuggees",
    validator: validate_ClouddebuggerDebuggerDebuggeesList_579967, base: "/",
    url: url_ClouddebuggerDebuggerDebuggeesList_579968, schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_579986 = ref object of OpenApiRestCall_579364
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsList_579988(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "debuggeeId" in path, "`debuggeeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/debugger/debuggees/"),
               (kind: VariableSegment, value: "debuggeeId"),
               (kind: ConstantSegment, value: "/breakpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsList_579987(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all breakpoints for the debuggee.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   debuggeeId: JString (required)
  ##             : Required. ID of the debuggee whose breakpoints to list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `debuggeeId` field"
  var valid_579989 = path.getOrDefault("debuggeeId")
  valid_579989 = validateParameter(valid_579989, JString, required = true,
                                 default = nil)
  if valid_579989 != nil:
    section.add "debuggeeId", valid_579989
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   action.value: JString
  ##               : Only breakpoints with the specified action will pass the filter.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeAllUsers: JBool
  ##                  : When set to `true`, the response includes the list of breakpoints set by
  ## any user. Otherwise, it includes only breakpoints set by the caller.
  ##   stripResults: JBool
  ##               : This field is deprecated. The following fields are always stripped out of
  ## the result: `stack_frames`, `evaluated_expressions` and `variable_table`.
  ##   callback: JString
  ##           : JSONP
  ##   includeInactive: JBool
  ##                  : When set to `true`, the response includes active and inactive
  ## breakpoints. Otherwise, it includes only active breakpoints.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   waitToken: JString
  ##            : A wait token that, if specified, blocks the call until the breakpoints
  ## list has changed, or a server selected timeout has expired.  The value
  ## should be set from the last response. The error code
  ## `google.rpc.Code.ABORTED` (RPC) is returned on wait timeout, which
  ## should be called again with the same `wait_token`.
  ##   clientVersion: JString
  ##                : Required. The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  section = newJObject()
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("prettyPrint")
  valid_579991 = validateParameter(valid_579991, JBool, required = false,
                                 default = newJBool(true))
  if valid_579991 != nil:
    section.add "prettyPrint", valid_579991
  var valid_579992 = query.getOrDefault("oauth_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "oauth_token", valid_579992
  var valid_579993 = query.getOrDefault("$.xgafv")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = newJString("1"))
  if valid_579993 != nil:
    section.add "$.xgafv", valid_579993
  var valid_579994 = query.getOrDefault("action.value")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("CAPTURE"))
  if valid_579994 != nil:
    section.add "action.value", valid_579994
  var valid_579995 = query.getOrDefault("alt")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = newJString("json"))
  if valid_579995 != nil:
    section.add "alt", valid_579995
  var valid_579996 = query.getOrDefault("uploadType")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "uploadType", valid_579996
  var valid_579997 = query.getOrDefault("quotaUser")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "quotaUser", valid_579997
  var valid_579998 = query.getOrDefault("includeAllUsers")
  valid_579998 = validateParameter(valid_579998, JBool, required = false, default = nil)
  if valid_579998 != nil:
    section.add "includeAllUsers", valid_579998
  var valid_579999 = query.getOrDefault("stripResults")
  valid_579999 = validateParameter(valid_579999, JBool, required = false, default = nil)
  if valid_579999 != nil:
    section.add "stripResults", valid_579999
  var valid_580000 = query.getOrDefault("callback")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "callback", valid_580000
  var valid_580001 = query.getOrDefault("includeInactive")
  valid_580001 = validateParameter(valid_580001, JBool, required = false, default = nil)
  if valid_580001 != nil:
    section.add "includeInactive", valid_580001
  var valid_580002 = query.getOrDefault("fields")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "fields", valid_580002
  var valid_580003 = query.getOrDefault("access_token")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "access_token", valid_580003
  var valid_580004 = query.getOrDefault("upload_protocol")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "upload_protocol", valid_580004
  var valid_580005 = query.getOrDefault("waitToken")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "waitToken", valid_580005
  var valid_580006 = query.getOrDefault("clientVersion")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "clientVersion", valid_580006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580007: Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_579986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all breakpoints for the debuggee.
  ## 
  let valid = call_580007.validator(path, query, header, formData, body)
  let scheme = call_580007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580007.url(scheme.get, call_580007.host, call_580007.base,
                         call_580007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580007, url, valid)

proc call*(call_580008: Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_579986;
          debuggeeId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; actionValue: string = "CAPTURE";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          includeAllUsers: bool = false; stripResults: bool = false;
          callback: string = ""; includeInactive: bool = false; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; waitToken: string = "";
          clientVersion: string = ""): Recallable =
  ## clouddebuggerDebuggerDebuggeesBreakpointsList
  ## Lists all breakpoints for the debuggee.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   actionValue: string
  ##              : Only breakpoints with the specified action will pass the filter.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeAllUsers: bool
  ##                  : When set to `true`, the response includes the list of breakpoints set by
  ## any user. Otherwise, it includes only breakpoints set by the caller.
  ##   stripResults: bool
  ##               : This field is deprecated. The following fields are always stripped out of
  ## the result: `stack_frames`, `evaluated_expressions` and `variable_table`.
  ##   debuggeeId: string (required)
  ##             : Required. ID of the debuggee whose breakpoints to list.
  ##   callback: string
  ##           : JSONP
  ##   includeInactive: bool
  ##                  : When set to `true`, the response includes active and inactive
  ## breakpoints. Otherwise, it includes only active breakpoints.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   waitToken: string
  ##            : A wait token that, if specified, blocks the call until the breakpoints
  ## list has changed, or a server selected timeout has expired.  The value
  ## should be set from the last response. The error code
  ## `google.rpc.Code.ABORTED` (RPC) is returned on wait timeout, which
  ## should be called again with the same `wait_token`.
  ##   clientVersion: string
  ##                : Required. The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  var path_580009 = newJObject()
  var query_580010 = newJObject()
  add(query_580010, "key", newJString(key))
  add(query_580010, "prettyPrint", newJBool(prettyPrint))
  add(query_580010, "oauth_token", newJString(oauthToken))
  add(query_580010, "$.xgafv", newJString(Xgafv))
  add(query_580010, "action.value", newJString(actionValue))
  add(query_580010, "alt", newJString(alt))
  add(query_580010, "uploadType", newJString(uploadType))
  add(query_580010, "quotaUser", newJString(quotaUser))
  add(query_580010, "includeAllUsers", newJBool(includeAllUsers))
  add(query_580010, "stripResults", newJBool(stripResults))
  add(path_580009, "debuggeeId", newJString(debuggeeId))
  add(query_580010, "callback", newJString(callback))
  add(query_580010, "includeInactive", newJBool(includeInactive))
  add(query_580010, "fields", newJString(fields))
  add(query_580010, "access_token", newJString(accessToken))
  add(query_580010, "upload_protocol", newJString(uploadProtocol))
  add(query_580010, "waitToken", newJString(waitToken))
  add(query_580010, "clientVersion", newJString(clientVersion))
  result = call_580008.call(path_580009, query_580010, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesBreakpointsList* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_579986(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsList",
    meth: HttpMethod.HttpGet, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsList_579987,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsList_579988,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_580011 = ref object of OpenApiRestCall_579364
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsSet_580013(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "debuggeeId" in path, "`debuggeeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/debugger/debuggees/"),
               (kind: VariableSegment, value: "debuggeeId"),
               (kind: ConstantSegment, value: "/breakpoints/set")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsSet_580012(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the breakpoint to the debuggee.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   debuggeeId: JString (required)
  ##             : Required. ID of the debuggee where the breakpoint is to be set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `debuggeeId` field"
  var valid_580014 = path.getOrDefault("debuggeeId")
  valid_580014 = validateParameter(valid_580014, JString, required = true,
                                 default = nil)
  if valid_580014 != nil:
    section.add "debuggeeId", valid_580014
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   clientVersion: JString
  ##                : Required. The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  section = newJObject()
  var valid_580015 = query.getOrDefault("key")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "key", valid_580015
  var valid_580016 = query.getOrDefault("prettyPrint")
  valid_580016 = validateParameter(valid_580016, JBool, required = false,
                                 default = newJBool(true))
  if valid_580016 != nil:
    section.add "prettyPrint", valid_580016
  var valid_580017 = query.getOrDefault("oauth_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "oauth_token", valid_580017
  var valid_580018 = query.getOrDefault("$.xgafv")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("1"))
  if valid_580018 != nil:
    section.add "$.xgafv", valid_580018
  var valid_580019 = query.getOrDefault("alt")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = newJString("json"))
  if valid_580019 != nil:
    section.add "alt", valid_580019
  var valid_580020 = query.getOrDefault("uploadType")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "uploadType", valid_580020
  var valid_580021 = query.getOrDefault("quotaUser")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "quotaUser", valid_580021
  var valid_580022 = query.getOrDefault("callback")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "callback", valid_580022
  var valid_580023 = query.getOrDefault("fields")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "fields", valid_580023
  var valid_580024 = query.getOrDefault("access_token")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "access_token", valid_580024
  var valid_580025 = query.getOrDefault("upload_protocol")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "upload_protocol", valid_580025
  var valid_580026 = query.getOrDefault("clientVersion")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "clientVersion", valid_580026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580028: Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_580011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the breakpoint to the debuggee.
  ## 
  let valid = call_580028.validator(path, query, header, formData, body)
  let scheme = call_580028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580028.url(scheme.get, call_580028.host, call_580028.base,
                         call_580028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580028, url, valid)

proc call*(call_580029: Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_580011;
          debuggeeId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; clientVersion: string = ""): Recallable =
  ## clouddebuggerDebuggerDebuggeesBreakpointsSet
  ## Sets the breakpoint to the debuggee.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   debuggeeId: string (required)
  ##             : Required. ID of the debuggee where the breakpoint is to be set.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   clientVersion: string
  ##                : Required. The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  var path_580030 = newJObject()
  var query_580031 = newJObject()
  var body_580032 = newJObject()
  add(query_580031, "key", newJString(key))
  add(query_580031, "prettyPrint", newJBool(prettyPrint))
  add(query_580031, "oauth_token", newJString(oauthToken))
  add(query_580031, "$.xgafv", newJString(Xgafv))
  add(query_580031, "alt", newJString(alt))
  add(query_580031, "uploadType", newJString(uploadType))
  add(query_580031, "quotaUser", newJString(quotaUser))
  add(path_580030, "debuggeeId", newJString(debuggeeId))
  if body != nil:
    body_580032 = body
  add(query_580031, "callback", newJString(callback))
  add(query_580031, "fields", newJString(fields))
  add(query_580031, "access_token", newJString(accessToken))
  add(query_580031, "upload_protocol", newJString(uploadProtocol))
  add(query_580031, "clientVersion", newJString(clientVersion))
  result = call_580029.call(path_580030, query_580031, nil, nil, body_580032)

var clouddebuggerDebuggerDebuggeesBreakpointsSet* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_580011(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsSet",
    meth: HttpMethod.HttpPost, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints/set",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsSet_580012,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsSet_580013,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_580033 = ref object of OpenApiRestCall_579364
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsGet_580035(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "debuggeeId" in path, "`debuggeeId` is a required path parameter"
  assert "breakpointId" in path, "`breakpointId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/debugger/debuggees/"),
               (kind: VariableSegment, value: "debuggeeId"),
               (kind: ConstantSegment, value: "/breakpoints/"),
               (kind: VariableSegment, value: "breakpointId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsGet_580034(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets breakpoint information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   breakpointId: JString (required)
  ##               : Required. ID of the breakpoint to get.
  ##   debuggeeId: JString (required)
  ##             : Required. ID of the debuggee whose breakpoint to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `breakpointId` field"
  var valid_580036 = path.getOrDefault("breakpointId")
  valid_580036 = validateParameter(valid_580036, JString, required = true,
                                 default = nil)
  if valid_580036 != nil:
    section.add "breakpointId", valid_580036
  var valid_580037 = path.getOrDefault("debuggeeId")
  valid_580037 = validateParameter(valid_580037, JString, required = true,
                                 default = nil)
  if valid_580037 != nil:
    section.add "debuggeeId", valid_580037
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   clientVersion: JString
  ##                : Required. The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  section = newJObject()
  var valid_580038 = query.getOrDefault("key")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "key", valid_580038
  var valid_580039 = query.getOrDefault("prettyPrint")
  valid_580039 = validateParameter(valid_580039, JBool, required = false,
                                 default = newJBool(true))
  if valid_580039 != nil:
    section.add "prettyPrint", valid_580039
  var valid_580040 = query.getOrDefault("oauth_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "oauth_token", valid_580040
  var valid_580041 = query.getOrDefault("$.xgafv")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = newJString("1"))
  if valid_580041 != nil:
    section.add "$.xgafv", valid_580041
  var valid_580042 = query.getOrDefault("alt")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("json"))
  if valid_580042 != nil:
    section.add "alt", valid_580042
  var valid_580043 = query.getOrDefault("uploadType")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "uploadType", valid_580043
  var valid_580044 = query.getOrDefault("quotaUser")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "quotaUser", valid_580044
  var valid_580045 = query.getOrDefault("callback")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "callback", valid_580045
  var valid_580046 = query.getOrDefault("fields")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "fields", valid_580046
  var valid_580047 = query.getOrDefault("access_token")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "access_token", valid_580047
  var valid_580048 = query.getOrDefault("upload_protocol")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "upload_protocol", valid_580048
  var valid_580049 = query.getOrDefault("clientVersion")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "clientVersion", valid_580049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580050: Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_580033;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets breakpoint information.
  ## 
  let valid = call_580050.validator(path, query, header, formData, body)
  let scheme = call_580050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580050.url(scheme.get, call_580050.host, call_580050.base,
                         call_580050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580050, url, valid)

proc call*(call_580051: Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_580033;
          breakpointId: string; debuggeeId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; clientVersion: string = ""): Recallable =
  ## clouddebuggerDebuggerDebuggeesBreakpointsGet
  ## Gets breakpoint information.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   breakpointId: string (required)
  ##               : Required. ID of the breakpoint to get.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   debuggeeId: string (required)
  ##             : Required. ID of the debuggee whose breakpoint to get.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   clientVersion: string
  ##                : Required. The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  var path_580052 = newJObject()
  var query_580053 = newJObject()
  add(query_580053, "key", newJString(key))
  add(query_580053, "prettyPrint", newJBool(prettyPrint))
  add(query_580053, "oauth_token", newJString(oauthToken))
  add(query_580053, "$.xgafv", newJString(Xgafv))
  add(path_580052, "breakpointId", newJString(breakpointId))
  add(query_580053, "alt", newJString(alt))
  add(query_580053, "uploadType", newJString(uploadType))
  add(query_580053, "quotaUser", newJString(quotaUser))
  add(path_580052, "debuggeeId", newJString(debuggeeId))
  add(query_580053, "callback", newJString(callback))
  add(query_580053, "fields", newJString(fields))
  add(query_580053, "access_token", newJString(accessToken))
  add(query_580053, "upload_protocol", newJString(uploadProtocol))
  add(query_580053, "clientVersion", newJString(clientVersion))
  result = call_580051.call(path_580052, query_580053, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesBreakpointsGet* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_580033(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsGet",
    meth: HttpMethod.HttpGet, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints/{breakpointId}",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsGet_580034,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsGet_580035,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_580054 = ref object of OpenApiRestCall_579364
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_580056(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "debuggeeId" in path, "`debuggeeId` is a required path parameter"
  assert "breakpointId" in path, "`breakpointId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/debugger/debuggees/"),
               (kind: VariableSegment, value: "debuggeeId"),
               (kind: ConstantSegment, value: "/breakpoints/"),
               (kind: VariableSegment, value: "breakpointId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_580055(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes the breakpoint from the debuggee.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   breakpointId: JString (required)
  ##               : Required. ID of the breakpoint to delete.
  ##   debuggeeId: JString (required)
  ##             : Required. ID of the debuggee whose breakpoint to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `breakpointId` field"
  var valid_580057 = path.getOrDefault("breakpointId")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "breakpointId", valid_580057
  var valid_580058 = path.getOrDefault("debuggeeId")
  valid_580058 = validateParameter(valid_580058, JString, required = true,
                                 default = nil)
  if valid_580058 != nil:
    section.add "debuggeeId", valid_580058
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   clientVersion: JString
  ##                : Required. The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  section = newJObject()
  var valid_580059 = query.getOrDefault("key")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "key", valid_580059
  var valid_580060 = query.getOrDefault("prettyPrint")
  valid_580060 = validateParameter(valid_580060, JBool, required = false,
                                 default = newJBool(true))
  if valid_580060 != nil:
    section.add "prettyPrint", valid_580060
  var valid_580061 = query.getOrDefault("oauth_token")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "oauth_token", valid_580061
  var valid_580062 = query.getOrDefault("$.xgafv")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = newJString("1"))
  if valid_580062 != nil:
    section.add "$.xgafv", valid_580062
  var valid_580063 = query.getOrDefault("alt")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = newJString("json"))
  if valid_580063 != nil:
    section.add "alt", valid_580063
  var valid_580064 = query.getOrDefault("uploadType")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "uploadType", valid_580064
  var valid_580065 = query.getOrDefault("quotaUser")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "quotaUser", valid_580065
  var valid_580066 = query.getOrDefault("callback")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "callback", valid_580066
  var valid_580067 = query.getOrDefault("fields")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "fields", valid_580067
  var valid_580068 = query.getOrDefault("access_token")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "access_token", valid_580068
  var valid_580069 = query.getOrDefault("upload_protocol")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "upload_protocol", valid_580069
  var valid_580070 = query.getOrDefault("clientVersion")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "clientVersion", valid_580070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580071: Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_580054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the breakpoint from the debuggee.
  ## 
  let valid = call_580071.validator(path, query, header, formData, body)
  let scheme = call_580071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580071.url(scheme.get, call_580071.host, call_580071.base,
                         call_580071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580071, url, valid)

proc call*(call_580072: Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_580054;
          breakpointId: string; debuggeeId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; clientVersion: string = ""): Recallable =
  ## clouddebuggerDebuggerDebuggeesBreakpointsDelete
  ## Deletes the breakpoint from the debuggee.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   breakpointId: string (required)
  ##               : Required. ID of the breakpoint to delete.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   debuggeeId: string (required)
  ##             : Required. ID of the debuggee whose breakpoint to delete.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   clientVersion: string
  ##                : Required. The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  var path_580073 = newJObject()
  var query_580074 = newJObject()
  add(query_580074, "key", newJString(key))
  add(query_580074, "prettyPrint", newJBool(prettyPrint))
  add(query_580074, "oauth_token", newJString(oauthToken))
  add(query_580074, "$.xgafv", newJString(Xgafv))
  add(path_580073, "breakpointId", newJString(breakpointId))
  add(query_580074, "alt", newJString(alt))
  add(query_580074, "uploadType", newJString(uploadType))
  add(query_580074, "quotaUser", newJString(quotaUser))
  add(path_580073, "debuggeeId", newJString(debuggeeId))
  add(query_580074, "callback", newJString(callback))
  add(query_580074, "fields", newJString(fields))
  add(query_580074, "access_token", newJString(accessToken))
  add(query_580074, "upload_protocol", newJString(uploadProtocol))
  add(query_580074, "clientVersion", newJString(clientVersion))
  result = call_580072.call(path_580073, query_580074, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesBreakpointsDelete* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_580054(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsDelete",
    meth: HttpMethod.HttpDelete, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints/{breakpointId}",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_580055,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_580056,
    schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
