
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: HomeGraph
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## 
## 
## https://developers.google.com/actions/smarthome/create-app#request-sync
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
  gcpServiceName = "homegraph"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_HomegraphDevicesQuery_579635 = ref object of OpenApiRestCall_579364
proc url_HomegraphDevicesQuery_579637(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_HomegraphDevicesQuery_579636(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the device states for the devices in QueryRequest.
  ## The third-party user's identity is passed in as `agent_user_id`. The agent
  ## is identified by the JWT signed by the third-party partner's service
  ## account.
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

proc call*(call_579796: Call_HomegraphDevicesQuery_579635; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the device states for the devices in QueryRequest.
  ## The third-party user's identity is passed in as `agent_user_id`. The agent
  ## is identified by the JWT signed by the third-party partner's service
  ## account.
  ## 
  let valid = call_579796.validator(path, query, header, formData, body)
  let scheme = call_579796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579796.url(scheme.get, call_579796.host, call_579796.base,
                         call_579796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579796, url, valid)

proc call*(call_579867: Call_HomegraphDevicesQuery_579635; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## homegraphDevicesQuery
  ## Gets the device states for the devices in QueryRequest.
  ## The third-party user's identity is passed in as `agent_user_id`. The agent
  ## is identified by the JWT signed by the third-party partner's service
  ## account.
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

var homegraphDevicesQuery* = Call_HomegraphDevicesQuery_579635(
    name: "homegraphDevicesQuery", meth: HttpMethod.HttpPost,
    host: "homegraph.googleapis.com", route: "/v1/devices:query",
    validator: validate_HomegraphDevicesQuery_579636, base: "/",
    url: url_HomegraphDevicesQuery_579637, schemes: {Scheme.Https})
type
  Call_HomegraphDevicesReportStateAndNotification_579909 = ref object of OpenApiRestCall_579364
proc url_HomegraphDevicesReportStateAndNotification_579911(protocol: Scheme;
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

proc validate_HomegraphDevicesReportStateAndNotification_579910(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reports device state and optionally sends device notifications. Called by
  ## an agent when the device state of a third-party changes or the agent wants
  ## to send a notification about the device. See
  ## [Implement Report State](/actions/smarthome/report-state) for more
  ## information.
  ## This method updates a predefined set of states for a device, which all
  ## devices have according to their prescribed traits (for example, a light
  ## will have the [OnOff](/actions/smarthome/traits/onoff) trait that reports
  ## the state `on` as a boolean value).
  ## A new state may not be created and an INVALID_ARGUMENT code will be thrown
  ## if so. It also optionally takes in a list of Notifications that may be
  ## created, which are associated to this state change.
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`.
  ## The agent is identified by the JWT signed by the partner's service account.
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
  var valid_579912 = query.getOrDefault("key")
  valid_579912 = validateParameter(valid_579912, JString, required = false,
                                 default = nil)
  if valid_579912 != nil:
    section.add "key", valid_579912
  var valid_579913 = query.getOrDefault("prettyPrint")
  valid_579913 = validateParameter(valid_579913, JBool, required = false,
                                 default = newJBool(true))
  if valid_579913 != nil:
    section.add "prettyPrint", valid_579913
  var valid_579914 = query.getOrDefault("oauth_token")
  valid_579914 = validateParameter(valid_579914, JString, required = false,
                                 default = nil)
  if valid_579914 != nil:
    section.add "oauth_token", valid_579914
  var valid_579915 = query.getOrDefault("$.xgafv")
  valid_579915 = validateParameter(valid_579915, JString, required = false,
                                 default = newJString("1"))
  if valid_579915 != nil:
    section.add "$.xgafv", valid_579915
  var valid_579916 = query.getOrDefault("alt")
  valid_579916 = validateParameter(valid_579916, JString, required = false,
                                 default = newJString("json"))
  if valid_579916 != nil:
    section.add "alt", valid_579916
  var valid_579917 = query.getOrDefault("uploadType")
  valid_579917 = validateParameter(valid_579917, JString, required = false,
                                 default = nil)
  if valid_579917 != nil:
    section.add "uploadType", valid_579917
  var valid_579918 = query.getOrDefault("quotaUser")
  valid_579918 = validateParameter(valid_579918, JString, required = false,
                                 default = nil)
  if valid_579918 != nil:
    section.add "quotaUser", valid_579918
  var valid_579919 = query.getOrDefault("callback")
  valid_579919 = validateParameter(valid_579919, JString, required = false,
                                 default = nil)
  if valid_579919 != nil:
    section.add "callback", valid_579919
  var valid_579920 = query.getOrDefault("fields")
  valid_579920 = validateParameter(valid_579920, JString, required = false,
                                 default = nil)
  if valid_579920 != nil:
    section.add "fields", valid_579920
  var valid_579921 = query.getOrDefault("access_token")
  valid_579921 = validateParameter(valid_579921, JString, required = false,
                                 default = nil)
  if valid_579921 != nil:
    section.add "access_token", valid_579921
  var valid_579922 = query.getOrDefault("upload_protocol")
  valid_579922 = validateParameter(valid_579922, JString, required = false,
                                 default = nil)
  if valid_579922 != nil:
    section.add "upload_protocol", valid_579922
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

proc call*(call_579924: Call_HomegraphDevicesReportStateAndNotification_579909;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports device state and optionally sends device notifications. Called by
  ## an agent when the device state of a third-party changes or the agent wants
  ## to send a notification about the device. See
  ## [Implement Report State](/actions/smarthome/report-state) for more
  ## information.
  ## This method updates a predefined set of states for a device, which all
  ## devices have according to their prescribed traits (for example, a light
  ## will have the [OnOff](/actions/smarthome/traits/onoff) trait that reports
  ## the state `on` as a boolean value).
  ## A new state may not be created and an INVALID_ARGUMENT code will be thrown
  ## if so. It also optionally takes in a list of Notifications that may be
  ## created, which are associated to this state change.
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`.
  ## The agent is identified by the JWT signed by the partner's service account.
  ## 
  let valid = call_579924.validator(path, query, header, formData, body)
  let scheme = call_579924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579924.url(scheme.get, call_579924.host, call_579924.base,
                         call_579924.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579924, url, valid)

proc call*(call_579925: Call_HomegraphDevicesReportStateAndNotification_579909;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## homegraphDevicesReportStateAndNotification
  ## Reports device state and optionally sends device notifications. Called by
  ## an agent when the device state of a third-party changes or the agent wants
  ## to send a notification about the device. See
  ## [Implement Report State](/actions/smarthome/report-state) for more
  ## information.
  ## This method updates a predefined set of states for a device, which all
  ## devices have according to their prescribed traits (for example, a light
  ## will have the [OnOff](/actions/smarthome/traits/onoff) trait that reports
  ## the state `on` as a boolean value).
  ## A new state may not be created and an INVALID_ARGUMENT code will be thrown
  ## if so. It also optionally takes in a list of Notifications that may be
  ## created, which are associated to this state change.
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`.
  ## The agent is identified by the JWT signed by the partner's service account.
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
  var query_579926 = newJObject()
  var body_579927 = newJObject()
  add(query_579926, "key", newJString(key))
  add(query_579926, "prettyPrint", newJBool(prettyPrint))
  add(query_579926, "oauth_token", newJString(oauthToken))
  add(query_579926, "$.xgafv", newJString(Xgafv))
  add(query_579926, "alt", newJString(alt))
  add(query_579926, "uploadType", newJString(uploadType))
  add(query_579926, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579927 = body
  add(query_579926, "callback", newJString(callback))
  add(query_579926, "fields", newJString(fields))
  add(query_579926, "access_token", newJString(accessToken))
  add(query_579926, "upload_protocol", newJString(uploadProtocol))
  result = call_579925.call(nil, query_579926, nil, nil, body_579927)

var homegraphDevicesReportStateAndNotification* = Call_HomegraphDevicesReportStateAndNotification_579909(
    name: "homegraphDevicesReportStateAndNotification", meth: HttpMethod.HttpPost,
    host: "homegraph.googleapis.com",
    route: "/v1/devices:reportStateAndNotification",
    validator: validate_HomegraphDevicesReportStateAndNotification_579910,
    base: "/", url: url_HomegraphDevicesReportStateAndNotification_579911,
    schemes: {Scheme.Https})
type
  Call_HomegraphDevicesRequestSync_579928 = ref object of OpenApiRestCall_579364
proc url_HomegraphDevicesRequestSync_579930(protocol: Scheme; host: string;
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

proc validate_HomegraphDevicesRequestSync_579929(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests a `SYNC` call from Google to a 3p partner's home control agent for
  ## a user.
  ## 
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`
  ## (see RequestSyncDevicesRequest) and forwarded back to the agent.
  ## The agent is identified by the API key or JWT signed by the partner's
  ## service account.
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
  var valid_579931 = query.getOrDefault("key")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = nil)
  if valid_579931 != nil:
    section.add "key", valid_579931
  var valid_579932 = query.getOrDefault("prettyPrint")
  valid_579932 = validateParameter(valid_579932, JBool, required = false,
                                 default = newJBool(true))
  if valid_579932 != nil:
    section.add "prettyPrint", valid_579932
  var valid_579933 = query.getOrDefault("oauth_token")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "oauth_token", valid_579933
  var valid_579934 = query.getOrDefault("$.xgafv")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = newJString("1"))
  if valid_579934 != nil:
    section.add "$.xgafv", valid_579934
  var valid_579935 = query.getOrDefault("alt")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = newJString("json"))
  if valid_579935 != nil:
    section.add "alt", valid_579935
  var valid_579936 = query.getOrDefault("uploadType")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "uploadType", valid_579936
  var valid_579937 = query.getOrDefault("quotaUser")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "quotaUser", valid_579937
  var valid_579938 = query.getOrDefault("callback")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "callback", valid_579938
  var valid_579939 = query.getOrDefault("fields")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "fields", valid_579939
  var valid_579940 = query.getOrDefault("access_token")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = nil)
  if valid_579940 != nil:
    section.add "access_token", valid_579940
  var valid_579941 = query.getOrDefault("upload_protocol")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "upload_protocol", valid_579941
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

proc call*(call_579943: Call_HomegraphDevicesRequestSync_579928; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests a `SYNC` call from Google to a 3p partner's home control agent for
  ## a user.
  ## 
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`
  ## (see RequestSyncDevicesRequest) and forwarded back to the agent.
  ## The agent is identified by the API key or JWT signed by the partner's
  ## service account.
  ## 
  let valid = call_579943.validator(path, query, header, formData, body)
  let scheme = call_579943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579943.url(scheme.get, call_579943.host, call_579943.base,
                         call_579943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579943, url, valid)

proc call*(call_579944: Call_HomegraphDevicesRequestSync_579928; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## homegraphDevicesRequestSync
  ## Requests a `SYNC` call from Google to a 3p partner's home control agent for
  ## a user.
  ## 
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`
  ## (see RequestSyncDevicesRequest) and forwarded back to the agent.
  ## The agent is identified by the API key or JWT signed by the partner's
  ## service account.
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
  var query_579945 = newJObject()
  var body_579946 = newJObject()
  add(query_579945, "key", newJString(key))
  add(query_579945, "prettyPrint", newJBool(prettyPrint))
  add(query_579945, "oauth_token", newJString(oauthToken))
  add(query_579945, "$.xgafv", newJString(Xgafv))
  add(query_579945, "alt", newJString(alt))
  add(query_579945, "uploadType", newJString(uploadType))
  add(query_579945, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579946 = body
  add(query_579945, "callback", newJString(callback))
  add(query_579945, "fields", newJString(fields))
  add(query_579945, "access_token", newJString(accessToken))
  add(query_579945, "upload_protocol", newJString(uploadProtocol))
  result = call_579944.call(nil, query_579945, nil, nil, body_579946)

var homegraphDevicesRequestSync* = Call_HomegraphDevicesRequestSync_579928(
    name: "homegraphDevicesRequestSync", meth: HttpMethod.HttpPost,
    host: "homegraph.googleapis.com", route: "/v1/devices:requestSync",
    validator: validate_HomegraphDevicesRequestSync_579929, base: "/",
    url: url_HomegraphDevicesRequestSync_579930, schemes: {Scheme.Https})
type
  Call_HomegraphDevicesSync_579947 = ref object of OpenApiRestCall_579364
proc url_HomegraphDevicesSync_579949(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_HomegraphDevicesSync_579948(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the devices associated with the given third-party user.
  ## The third-party user's identity is passed in as `agent_user_id`. The agent
  ## is identified by the JWT signed by the third-party partner's service
  ## account.
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
  var valid_579950 = query.getOrDefault("key")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "key", valid_579950
  var valid_579951 = query.getOrDefault("prettyPrint")
  valid_579951 = validateParameter(valid_579951, JBool, required = false,
                                 default = newJBool(true))
  if valid_579951 != nil:
    section.add "prettyPrint", valid_579951
  var valid_579952 = query.getOrDefault("oauth_token")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "oauth_token", valid_579952
  var valid_579953 = query.getOrDefault("$.xgafv")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = newJString("1"))
  if valid_579953 != nil:
    section.add "$.xgafv", valid_579953
  var valid_579954 = query.getOrDefault("alt")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = newJString("json"))
  if valid_579954 != nil:
    section.add "alt", valid_579954
  var valid_579955 = query.getOrDefault("uploadType")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "uploadType", valid_579955
  var valid_579956 = query.getOrDefault("quotaUser")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "quotaUser", valid_579956
  var valid_579957 = query.getOrDefault("callback")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "callback", valid_579957
  var valid_579958 = query.getOrDefault("fields")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "fields", valid_579958
  var valid_579959 = query.getOrDefault("access_token")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "access_token", valid_579959
  var valid_579960 = query.getOrDefault("upload_protocol")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "upload_protocol", valid_579960
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

proc call*(call_579962: Call_HomegraphDevicesSync_579947; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the devices associated with the given third-party user.
  ## The third-party user's identity is passed in as `agent_user_id`. The agent
  ## is identified by the JWT signed by the third-party partner's service
  ## account.
  ## 
  let valid = call_579962.validator(path, query, header, formData, body)
  let scheme = call_579962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579962.url(scheme.get, call_579962.host, call_579962.base,
                         call_579962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579962, url, valid)

proc call*(call_579963: Call_HomegraphDevicesSync_579947; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## homegraphDevicesSync
  ## Gets all the devices associated with the given third-party user.
  ## The third-party user's identity is passed in as `agent_user_id`. The agent
  ## is identified by the JWT signed by the third-party partner's service
  ## account.
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
  var query_579964 = newJObject()
  var body_579965 = newJObject()
  add(query_579964, "key", newJString(key))
  add(query_579964, "prettyPrint", newJBool(prettyPrint))
  add(query_579964, "oauth_token", newJString(oauthToken))
  add(query_579964, "$.xgafv", newJString(Xgafv))
  add(query_579964, "alt", newJString(alt))
  add(query_579964, "uploadType", newJString(uploadType))
  add(query_579964, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579965 = body
  add(query_579964, "callback", newJString(callback))
  add(query_579964, "fields", newJString(fields))
  add(query_579964, "access_token", newJString(accessToken))
  add(query_579964, "upload_protocol", newJString(uploadProtocol))
  result = call_579963.call(nil, query_579964, nil, nil, body_579965)

var homegraphDevicesSync* = Call_HomegraphDevicesSync_579947(
    name: "homegraphDevicesSync", meth: HttpMethod.HttpPost,
    host: "homegraph.googleapis.com", route: "/v1/devices:sync",
    validator: validate_HomegraphDevicesSync_579948, base: "/",
    url: url_HomegraphDevicesSync_579949, schemes: {Scheme.Https})
type
  Call_HomegraphAgentUsersDelete_579966 = ref object of OpenApiRestCall_579364
proc url_HomegraphAgentUsersDelete_579968(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "agentUserId" in path, "`agentUserId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "agentUserId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_HomegraphAgentUsersDelete_579967(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unlinks an agent user from Google. As a result, all data related to this
  ## user will be deleted.
  ## 
  ## Here is how the agent user is created in Google:
  ## 
  ## 1.  When a user opens their Google Home App, they can begin linking a 3p
  ##     partner.
  ## 2.  User is guided through the OAuth process.
  ## 3.  After entering the 3p credentials, Google gets the 3p OAuth token and
  ##     uses it to make a Sync call to the 3p partner and gets back all of the
  ##     user's data, including `agent_user_id` and devices.
  ## 4.  Google creates the agent user and stores a mapping from the
  ##     `agent_user_id` -> Google ID mapping. Google also
  ##     stores all of the user's devices under that Google ID.
  ## 
  ## The mapping from `agent_user_id` to Google ID is many to many, since one
  ## Google user can have multiple 3p accounts, and multiple Google users can
  ## map to one `agent_user_id` (e.g., a husband and wife share one Nest account
  ## username/password).
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`.
  ## The agent is identified by the JWT signed by the partner's service account.
  ## 
  ## Note: Special characters (except "/") in `agent_user_id` must be
  ## URL-encoded.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   agentUserId: JString (required)
  ##              : Required. Third-party user ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `agentUserId` field"
  var valid_579983 = path.getOrDefault("agentUserId")
  valid_579983 = validateParameter(valid_579983, JString, required = true,
                                 default = nil)
  if valid_579983 != nil:
    section.add "agentUserId", valid_579983
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
  ##   requestId: JString
  ##            : Request ID used for debugging.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579984 = query.getOrDefault("key")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "key", valid_579984
  var valid_579985 = query.getOrDefault("prettyPrint")
  valid_579985 = validateParameter(valid_579985, JBool, required = false,
                                 default = newJBool(true))
  if valid_579985 != nil:
    section.add "prettyPrint", valid_579985
  var valid_579986 = query.getOrDefault("oauth_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "oauth_token", valid_579986
  var valid_579987 = query.getOrDefault("$.xgafv")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = newJString("1"))
  if valid_579987 != nil:
    section.add "$.xgafv", valid_579987
  var valid_579988 = query.getOrDefault("alt")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = newJString("json"))
  if valid_579988 != nil:
    section.add "alt", valid_579988
  var valid_579989 = query.getOrDefault("uploadType")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "uploadType", valid_579989
  var valid_579990 = query.getOrDefault("quotaUser")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "quotaUser", valid_579990
  var valid_579991 = query.getOrDefault("callback")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "callback", valid_579991
  var valid_579992 = query.getOrDefault("requestId")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "requestId", valid_579992
  var valid_579993 = query.getOrDefault("fields")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "fields", valid_579993
  var valid_579994 = query.getOrDefault("access_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "access_token", valid_579994
  var valid_579995 = query.getOrDefault("upload_protocol")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "upload_protocol", valid_579995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579996: Call_HomegraphAgentUsersDelete_579966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unlinks an agent user from Google. As a result, all data related to this
  ## user will be deleted.
  ## 
  ## Here is how the agent user is created in Google:
  ## 
  ## 1.  When a user opens their Google Home App, they can begin linking a 3p
  ##     partner.
  ## 2.  User is guided through the OAuth process.
  ## 3.  After entering the 3p credentials, Google gets the 3p OAuth token and
  ##     uses it to make a Sync call to the 3p partner and gets back all of the
  ##     user's data, including `agent_user_id` and devices.
  ## 4.  Google creates the agent user and stores a mapping from the
  ##     `agent_user_id` -> Google ID mapping. Google also
  ##     stores all of the user's devices under that Google ID.
  ## 
  ## The mapping from `agent_user_id` to Google ID is many to many, since one
  ## Google user can have multiple 3p accounts, and multiple Google users can
  ## map to one `agent_user_id` (e.g., a husband and wife share one Nest account
  ## username/password).
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`.
  ## The agent is identified by the JWT signed by the partner's service account.
  ## 
  ## Note: Special characters (except "/") in `agent_user_id` must be
  ## URL-encoded.
  ## 
  let valid = call_579996.validator(path, query, header, formData, body)
  let scheme = call_579996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579996.url(scheme.get, call_579996.host, call_579996.base,
                         call_579996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579996, url, valid)

proc call*(call_579997: Call_HomegraphAgentUsersDelete_579966; agentUserId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; requestId: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## homegraphAgentUsersDelete
  ## Unlinks an agent user from Google. As a result, all data related to this
  ## user will be deleted.
  ## 
  ## Here is how the agent user is created in Google:
  ## 
  ## 1.  When a user opens their Google Home App, they can begin linking a 3p
  ##     partner.
  ## 2.  User is guided through the OAuth process.
  ## 3.  After entering the 3p credentials, Google gets the 3p OAuth token and
  ##     uses it to make a Sync call to the 3p partner and gets back all of the
  ##     user's data, including `agent_user_id` and devices.
  ## 4.  Google creates the agent user and stores a mapping from the
  ##     `agent_user_id` -> Google ID mapping. Google also
  ##     stores all of the user's devices under that Google ID.
  ## 
  ## The mapping from `agent_user_id` to Google ID is many to many, since one
  ## Google user can have multiple 3p accounts, and multiple Google users can
  ## map to one `agent_user_id` (e.g., a husband and wife share one Nest account
  ## username/password).
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`.
  ## The agent is identified by the JWT signed by the partner's service account.
  ## 
  ## Note: Special characters (except "/") in `agent_user_id` must be
  ## URL-encoded.
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
  ##   agentUserId: string (required)
  ##              : Required. Third-party user ID.
  ##   callback: string
  ##           : JSONP
  ##   requestId: string
  ##            : Request ID used for debugging.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579998 = newJObject()
  var query_579999 = newJObject()
  add(query_579999, "key", newJString(key))
  add(query_579999, "prettyPrint", newJBool(prettyPrint))
  add(query_579999, "oauth_token", newJString(oauthToken))
  add(query_579999, "$.xgafv", newJString(Xgafv))
  add(query_579999, "alt", newJString(alt))
  add(query_579999, "uploadType", newJString(uploadType))
  add(query_579999, "quotaUser", newJString(quotaUser))
  add(path_579998, "agentUserId", newJString(agentUserId))
  add(query_579999, "callback", newJString(callback))
  add(query_579999, "requestId", newJString(requestId))
  add(query_579999, "fields", newJString(fields))
  add(query_579999, "access_token", newJString(accessToken))
  add(query_579999, "upload_protocol", newJString(uploadProtocol))
  result = call_579997.call(path_579998, query_579999, nil, nil, nil)

var homegraphAgentUsersDelete* = Call_HomegraphAgentUsersDelete_579966(
    name: "homegraphAgentUsersDelete", meth: HttpMethod.HttpDelete,
    host: "homegraph.googleapis.com", route: "/v1/{agentUserId}",
    validator: validate_HomegraphAgentUsersDelete_579967, base: "/",
    url: url_HomegraphAgentUsersDelete_579968, schemes: {Scheme.Https})
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
