
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Proximity Beacon
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Registers, manages, indexes, and searches beacons.
## 
## https://developers.google.com/beacons/proximity/
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "proximitybeacon"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProximitybeaconBeaconinfoGetforobserved_588710 = ref object of OpenApiRestCall_588441
proc url_ProximitybeaconBeaconinfoGetforobserved_588712(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ProximitybeaconBeaconinfoGetforobserved_588711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Given one or more beacon observations, returns any beacon information
  ## and attachments accessible to your application. Authorize by using the
  ## [API
  ## key](https://developers.google.com/beacons/proximity/get-started#request_a_browser_api_key)
  ## for the application.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("fields")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "fields", valid_588825
  var valid_588826 = query.getOrDefault("quotaUser")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "quotaUser", valid_588826
  var valid_588840 = query.getOrDefault("alt")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = newJString("json"))
  if valid_588840 != nil:
    section.add "alt", valid_588840
  var valid_588841 = query.getOrDefault("oauth_token")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "oauth_token", valid_588841
  var valid_588842 = query.getOrDefault("callback")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "callback", valid_588842
  var valid_588843 = query.getOrDefault("access_token")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "access_token", valid_588843
  var valid_588844 = query.getOrDefault("uploadType")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "uploadType", valid_588844
  var valid_588845 = query.getOrDefault("key")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "key", valid_588845
  var valid_588846 = query.getOrDefault("$.xgafv")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = newJString("1"))
  if valid_588846 != nil:
    section.add "$.xgafv", valid_588846
  var valid_588847 = query.getOrDefault("prettyPrint")
  valid_588847 = validateParameter(valid_588847, JBool, required = false,
                                 default = newJBool(true))
  if valid_588847 != nil:
    section.add "prettyPrint", valid_588847
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

proc call*(call_588871: Call_ProximitybeaconBeaconinfoGetforobserved_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Given one or more beacon observations, returns any beacon information
  ## and attachments accessible to your application. Authorize by using the
  ## [API
  ## key](https://developers.google.com/beacons/proximity/get-started#request_a_browser_api_key)
  ## for the application.
  ## 
  let valid = call_588871.validator(path, query, header, formData, body)
  let scheme = call_588871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588871.url(scheme.get, call_588871.host, call_588871.base,
                         call_588871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588871, url, valid)

proc call*(call_588942: Call_ProximitybeaconBeaconinfoGetforobserved_588710;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconinfoGetforobserved
  ## Given one or more beacon observations, returns any beacon information
  ## and attachments accessible to your application. Authorize by using the
  ## [API
  ## key](https://developers.google.com/beacons/proximity/get-started#request_a_browser_api_key)
  ## for the application.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588943 = newJObject()
  var body_588945 = newJObject()
  add(query_588943, "upload_protocol", newJString(uploadProtocol))
  add(query_588943, "fields", newJString(fields))
  add(query_588943, "quotaUser", newJString(quotaUser))
  add(query_588943, "alt", newJString(alt))
  add(query_588943, "oauth_token", newJString(oauthToken))
  add(query_588943, "callback", newJString(callback))
  add(query_588943, "access_token", newJString(accessToken))
  add(query_588943, "uploadType", newJString(uploadType))
  add(query_588943, "key", newJString(key))
  add(query_588943, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_588945 = body
  add(query_588943, "prettyPrint", newJBool(prettyPrint))
  result = call_588942.call(nil, query_588943, nil, nil, body_588945)

var proximitybeaconBeaconinfoGetforobserved* = Call_ProximitybeaconBeaconinfoGetforobserved_588710(
    name: "proximitybeaconBeaconinfoGetforobserved", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/beaconinfo:getforobserved",
    validator: validate_ProximitybeaconBeaconinfoGetforobserved_588711, base: "/",
    url: url_ProximitybeaconBeaconinfoGetforobserved_588712,
    schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsList_588984 = ref object of OpenApiRestCall_588441
proc url_ProximitybeaconBeaconsList_588986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ProximitybeaconBeaconsList_588985(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Searches the beacon registry for beacons that match the given search
  ## criteria. Only those beacons that the client has permission to list
  ## will be returned.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token obtained from a previous request to list beacons.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   q: JString
  ##    : Filter query string that supports the following field filters:
  ## 
  ## * **description:`"<string>"`**
  ##   For example: **description:"Room 3"**
  ##   Returns beacons whose description matches tokens in the string "Room 3"
  ##   (not necessarily that exact string).
  ##   The string must be double-quoted.
  ## * **status:`<enum>`**
  ##   For example: **status:active**
  ##   Returns beacons whose status matches the given value. Values must be
  ##   one of the Beacon.Status enum values (case insensitive). Accepts
  ##   multiple filters which will be combined with OR logic.
  ## * **stability:`<enum>`**
  ##   For example: **stability:mobile**
  ##   Returns beacons whose expected stability matches the given value.
  ##   Values must be one of the Beacon.Stability enum values (case
  ##   insensitive). Accepts multiple filters which will be combined with
  ##   OR logic.
  ## * **place\_id:`"<string>"`**
  ##   For example: **place\_id:"ChIJVSZzVR8FdkgRXGmmm6SslKw="**
  ##   Returns beacons explicitly registered at the given place, expressed as
  ##   a Place ID obtained from [Google Places API](/places/place-id). Does not
  ##   match places inside the given place. Does not consider the beacon's
  ##   actual location (which may be different from its registered place).
  ##   Accepts multiple filters that will be combined with OR logic. The place
  ##   ID must be double-quoted.
  ## * **registration\_time`[<|>|<=|>=]<integer>`**
  ##   For example: **registration\_time>=1433116800**
  ##   Returns beacons whose registration time matches the given filter.
  ##   Supports the operators: <, >, <=, and >=. Timestamp must be expressed as
  ##   an integer number of seconds since midnight January 1, 1970 UTC. Accepts
  ##   at most two filters that will be combined with AND logic, to support
  ##   "between" semantics. If more than two are supplied, the latter ones are
  ##   ignored.
  ## * **lat:`<double> lng:<double> radius:<integer>`**
  ##   For example: **lat:51.1232343 lng:-1.093852 radius:1000**
  ##   Returns beacons whose registered location is within the given circle.
  ##   When any of these fields are given, all are required. Latitude and
  ##   longitude must be decimal degrees between -90.0 and 90.0 and between
  ##   -180.0 and 180.0 respectively. Radius must be an integer number of
  ##   meters between 10 and 1,000,000 (1000 km).
  ## * **property:`"<string>=<string>"`**
  ##   For example: **property:"battery-type=CR2032"**
  ##   Returns beacons which have a property of the given name and value.
  ##   Supports multiple filters which will be combined with OR logic.
  ##   The entire name=value string must be double-quoted as one string.
  ## * **attachment\_type:`"<string>"`**
  ##   For example: **attachment_type:"my-namespace/my-type"**
  ##   Returns beacons having at least one attachment of the given namespaced
  ##   type. Supports "any within this namespace" via the partial wildcard
  ##   syntax: "my-namespace/*". Supports multiple filters which will be
  ##   combined with OR logic. The string must be double-quoted.
  ## * **indoor\_level:`"<string>"`**
  ##   For example: **indoor\_level:"1"**
  ##   Returns beacons which are located on the given indoor level. Accepts
  ##   multiple filters that will be combined with OR logic.
  ## 
  ## Multiple filters on the same field are combined with OR logic (except
  ## registration_time which is combined with AND logic).
  ## Multiple filters on different fields are combined with AND logic.
  ## Filters should be separated by spaces.
  ## 
  ## As with any HTTP query string parameter, the whole filter expression must
  ## be URL-encoded.
  ## 
  ## Example REST request:
  ## `GET
  ## /v1beta1/beacons?q=status:active%20lat:51.123%20lng:-1.095%20radius:1000`
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of records to return for this request, up to a
  ## server-defined upper limit.
  ##   projectId: JString
  ##            : The project id to list beacons under. If not present then the project
  ## credential that made the request is used as the project.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588987 = query.getOrDefault("upload_protocol")
  valid_588987 = validateParameter(valid_588987, JString, required = false,
                                 default = nil)
  if valid_588987 != nil:
    section.add "upload_protocol", valid_588987
  var valid_588988 = query.getOrDefault("fields")
  valid_588988 = validateParameter(valid_588988, JString, required = false,
                                 default = nil)
  if valid_588988 != nil:
    section.add "fields", valid_588988
  var valid_588989 = query.getOrDefault("pageToken")
  valid_588989 = validateParameter(valid_588989, JString, required = false,
                                 default = nil)
  if valid_588989 != nil:
    section.add "pageToken", valid_588989
  var valid_588990 = query.getOrDefault("quotaUser")
  valid_588990 = validateParameter(valid_588990, JString, required = false,
                                 default = nil)
  if valid_588990 != nil:
    section.add "quotaUser", valid_588990
  var valid_588991 = query.getOrDefault("alt")
  valid_588991 = validateParameter(valid_588991, JString, required = false,
                                 default = newJString("json"))
  if valid_588991 != nil:
    section.add "alt", valid_588991
  var valid_588992 = query.getOrDefault("oauth_token")
  valid_588992 = validateParameter(valid_588992, JString, required = false,
                                 default = nil)
  if valid_588992 != nil:
    section.add "oauth_token", valid_588992
  var valid_588993 = query.getOrDefault("callback")
  valid_588993 = validateParameter(valid_588993, JString, required = false,
                                 default = nil)
  if valid_588993 != nil:
    section.add "callback", valid_588993
  var valid_588994 = query.getOrDefault("access_token")
  valid_588994 = validateParameter(valid_588994, JString, required = false,
                                 default = nil)
  if valid_588994 != nil:
    section.add "access_token", valid_588994
  var valid_588995 = query.getOrDefault("uploadType")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "uploadType", valid_588995
  var valid_588996 = query.getOrDefault("q")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "q", valid_588996
  var valid_588997 = query.getOrDefault("key")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "key", valid_588997
  var valid_588998 = query.getOrDefault("$.xgafv")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = newJString("1"))
  if valid_588998 != nil:
    section.add "$.xgafv", valid_588998
  var valid_588999 = query.getOrDefault("pageSize")
  valid_588999 = validateParameter(valid_588999, JInt, required = false, default = nil)
  if valid_588999 != nil:
    section.add "pageSize", valid_588999
  var valid_589000 = query.getOrDefault("projectId")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "projectId", valid_589000
  var valid_589001 = query.getOrDefault("prettyPrint")
  valid_589001 = validateParameter(valid_589001, JBool, required = false,
                                 default = newJBool(true))
  if valid_589001 != nil:
    section.add "prettyPrint", valid_589001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589002: Call_ProximitybeaconBeaconsList_588984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches the beacon registry for beacons that match the given search
  ## criteria. Only those beacons that the client has permission to list
  ## will be returned.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  let valid = call_589002.validator(path, query, header, formData, body)
  let scheme = call_589002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589002.url(scheme.get, call_589002.host, call_589002.base,
                         call_589002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589002, url, valid)

proc call*(call_589003: Call_ProximitybeaconBeaconsList_588984;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          q: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          projectId: string = ""; prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsList
  ## Searches the beacon registry for beacons that match the given search
  ## criteria. Only those beacons that the client has permission to list
  ## will be returned.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token obtained from a previous request to list beacons.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   q: string
  ##    : Filter query string that supports the following field filters:
  ## 
  ## * **description:`"<string>"`**
  ##   For example: **description:"Room 3"**
  ##   Returns beacons whose description matches tokens in the string "Room 3"
  ##   (not necessarily that exact string).
  ##   The string must be double-quoted.
  ## * **status:`<enum>`**
  ##   For example: **status:active**
  ##   Returns beacons whose status matches the given value. Values must be
  ##   one of the Beacon.Status enum values (case insensitive). Accepts
  ##   multiple filters which will be combined with OR logic.
  ## * **stability:`<enum>`**
  ##   For example: **stability:mobile**
  ##   Returns beacons whose expected stability matches the given value.
  ##   Values must be one of the Beacon.Stability enum values (case
  ##   insensitive). Accepts multiple filters which will be combined with
  ##   OR logic.
  ## * **place\_id:`"<string>"`**
  ##   For example: **place\_id:"ChIJVSZzVR8FdkgRXGmmm6SslKw="**
  ##   Returns beacons explicitly registered at the given place, expressed as
  ##   a Place ID obtained from [Google Places API](/places/place-id). Does not
  ##   match places inside the given place. Does not consider the beacon's
  ##   actual location (which may be different from its registered place).
  ##   Accepts multiple filters that will be combined with OR logic. The place
  ##   ID must be double-quoted.
  ## * **registration\_time`[<|>|<=|>=]<integer>`**
  ##   For example: **registration\_time>=1433116800**
  ##   Returns beacons whose registration time matches the given filter.
  ##   Supports the operators: <, >, <=, and >=. Timestamp must be expressed as
  ##   an integer number of seconds since midnight January 1, 1970 UTC. Accepts
  ##   at most two filters that will be combined with AND logic, to support
  ##   "between" semantics. If more than two are supplied, the latter ones are
  ##   ignored.
  ## * **lat:`<double> lng:<double> radius:<integer>`**
  ##   For example: **lat:51.1232343 lng:-1.093852 radius:1000**
  ##   Returns beacons whose registered location is within the given circle.
  ##   When any of these fields are given, all are required. Latitude and
  ##   longitude must be decimal degrees between -90.0 and 90.0 and between
  ##   -180.0 and 180.0 respectively. Radius must be an integer number of
  ##   meters between 10 and 1,000,000 (1000 km).
  ## * **property:`"<string>=<string>"`**
  ##   For example: **property:"battery-type=CR2032"**
  ##   Returns beacons which have a property of the given name and value.
  ##   Supports multiple filters which will be combined with OR logic.
  ##   The entire name=value string must be double-quoted as one string.
  ## * **attachment\_type:`"<string>"`**
  ##   For example: **attachment_type:"my-namespace/my-type"**
  ##   Returns beacons having at least one attachment of the given namespaced
  ##   type. Supports "any within this namespace" via the partial wildcard
  ##   syntax: "my-namespace/*". Supports multiple filters which will be
  ##   combined with OR logic. The string must be double-quoted.
  ## * **indoor\_level:`"<string>"`**
  ##   For example: **indoor\_level:"1"**
  ##   Returns beacons which are located on the given indoor level. Accepts
  ##   multiple filters that will be combined with OR logic.
  ## 
  ## Multiple filters on the same field are combined with OR logic (except
  ## registration_time which is combined with AND logic).
  ## Multiple filters on different fields are combined with AND logic.
  ## Filters should be separated by spaces.
  ## 
  ## As with any HTTP query string parameter, the whole filter expression must
  ## be URL-encoded.
  ## 
  ## Example REST request:
  ## `GET
  ## /v1beta1/beacons?q=status:active%20lat:51.123%20lng:-1.095%20radius:1000`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of records to return for this request, up to a
  ## server-defined upper limit.
  ##   projectId: string
  ##            : The project id to list beacons under. If not present then the project
  ## credential that made the request is used as the project.
  ## Optional.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589004 = newJObject()
  add(query_589004, "upload_protocol", newJString(uploadProtocol))
  add(query_589004, "fields", newJString(fields))
  add(query_589004, "pageToken", newJString(pageToken))
  add(query_589004, "quotaUser", newJString(quotaUser))
  add(query_589004, "alt", newJString(alt))
  add(query_589004, "oauth_token", newJString(oauthToken))
  add(query_589004, "callback", newJString(callback))
  add(query_589004, "access_token", newJString(accessToken))
  add(query_589004, "uploadType", newJString(uploadType))
  add(query_589004, "q", newJString(q))
  add(query_589004, "key", newJString(key))
  add(query_589004, "$.xgafv", newJString(Xgafv))
  add(query_589004, "pageSize", newJInt(pageSize))
  add(query_589004, "projectId", newJString(projectId))
  add(query_589004, "prettyPrint", newJBool(prettyPrint))
  result = call_589003.call(nil, query_589004, nil, nil, nil)

var proximitybeaconBeaconsList* = Call_ProximitybeaconBeaconsList_588984(
    name: "proximitybeaconBeaconsList", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/beacons",
    validator: validate_ProximitybeaconBeaconsList_588985, base: "/",
    url: url_ProximitybeaconBeaconsList_588986, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsRegister_589005 = ref object of OpenApiRestCall_588441
proc url_ProximitybeaconBeaconsRegister_589007(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ProximitybeaconBeaconsRegister_589006(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Registers a previously unregistered beacon given its `advertisedId`.
  ## These IDs are unique within the system. An ID can be registered only once.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the project the beacon will be registered to. If
  ## the project id is not specified then the project making the request
  ## is used.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589008 = query.getOrDefault("upload_protocol")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "upload_protocol", valid_589008
  var valid_589009 = query.getOrDefault("fields")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "fields", valid_589009
  var valid_589010 = query.getOrDefault("quotaUser")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "quotaUser", valid_589010
  var valid_589011 = query.getOrDefault("alt")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = newJString("json"))
  if valid_589011 != nil:
    section.add "alt", valid_589011
  var valid_589012 = query.getOrDefault("oauth_token")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "oauth_token", valid_589012
  var valid_589013 = query.getOrDefault("callback")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "callback", valid_589013
  var valid_589014 = query.getOrDefault("access_token")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "access_token", valid_589014
  var valid_589015 = query.getOrDefault("uploadType")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "uploadType", valid_589015
  var valid_589016 = query.getOrDefault("key")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "key", valid_589016
  var valid_589017 = query.getOrDefault("$.xgafv")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = newJString("1"))
  if valid_589017 != nil:
    section.add "$.xgafv", valid_589017
  var valid_589018 = query.getOrDefault("projectId")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "projectId", valid_589018
  var valid_589019 = query.getOrDefault("prettyPrint")
  valid_589019 = validateParameter(valid_589019, JBool, required = false,
                                 default = newJBool(true))
  if valid_589019 != nil:
    section.add "prettyPrint", valid_589019
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

proc call*(call_589021: Call_ProximitybeaconBeaconsRegister_589005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a previously unregistered beacon given its `advertisedId`.
  ## These IDs are unique within the system. An ID can be registered only once.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_589021.validator(path, query, header, formData, body)
  let scheme = call_589021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589021.url(scheme.get, call_589021.host, call_589021.base,
                         call_589021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589021, url, valid)

proc call*(call_589022: Call_ProximitybeaconBeaconsRegister_589005;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; projectId: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsRegister
  ## Registers a previously unregistered beacon given its `advertisedId`.
  ## These IDs are unique within the system. An ID can be registered only once.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the project the beacon will be registered to. If
  ## the project id is not specified then the project making the request
  ## is used.
  ## Optional.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589023 = newJObject()
  var body_589024 = newJObject()
  add(query_589023, "upload_protocol", newJString(uploadProtocol))
  add(query_589023, "fields", newJString(fields))
  add(query_589023, "quotaUser", newJString(quotaUser))
  add(query_589023, "alt", newJString(alt))
  add(query_589023, "oauth_token", newJString(oauthToken))
  add(query_589023, "callback", newJString(callback))
  add(query_589023, "access_token", newJString(accessToken))
  add(query_589023, "uploadType", newJString(uploadType))
  add(query_589023, "key", newJString(key))
  add(query_589023, "$.xgafv", newJString(Xgafv))
  add(query_589023, "projectId", newJString(projectId))
  if body != nil:
    body_589024 = body
  add(query_589023, "prettyPrint", newJBool(prettyPrint))
  result = call_589022.call(nil, query_589023, nil, nil, body_589024)

var proximitybeaconBeaconsRegister* = Call_ProximitybeaconBeaconsRegister_589005(
    name: "proximitybeaconBeaconsRegister", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/beacons:register",
    validator: validate_ProximitybeaconBeaconsRegister_589006, base: "/",
    url: url_ProximitybeaconBeaconsRegister_589007, schemes: {Scheme.Https})
type
  Call_ProximitybeaconGetEidparams_589025 = ref object of OpenApiRestCall_588441
proc url_ProximitybeaconGetEidparams_589027(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ProximitybeaconGetEidparams_589026(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Proximity Beacon API's current public key and associated
  ## parameters used to initiate the Diffie-Hellman key exchange required to
  ## register a beacon that broadcasts the Eddystone-EID format. This key
  ## changes periodically; clients may cache it and re-use the same public key
  ## to provision and register multiple beacons. However, clients should be
  ## prepared to refresh this key when they encounter an error registering an
  ## Eddystone-EID beacon.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589028 = query.getOrDefault("upload_protocol")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "upload_protocol", valid_589028
  var valid_589029 = query.getOrDefault("fields")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "fields", valid_589029
  var valid_589030 = query.getOrDefault("quotaUser")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "quotaUser", valid_589030
  var valid_589031 = query.getOrDefault("alt")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = newJString("json"))
  if valid_589031 != nil:
    section.add "alt", valid_589031
  var valid_589032 = query.getOrDefault("oauth_token")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "oauth_token", valid_589032
  var valid_589033 = query.getOrDefault("callback")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "callback", valid_589033
  var valid_589034 = query.getOrDefault("access_token")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "access_token", valid_589034
  var valid_589035 = query.getOrDefault("uploadType")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "uploadType", valid_589035
  var valid_589036 = query.getOrDefault("key")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "key", valid_589036
  var valid_589037 = query.getOrDefault("$.xgafv")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = newJString("1"))
  if valid_589037 != nil:
    section.add "$.xgafv", valid_589037
  var valid_589038 = query.getOrDefault("prettyPrint")
  valid_589038 = validateParameter(valid_589038, JBool, required = false,
                                 default = newJBool(true))
  if valid_589038 != nil:
    section.add "prettyPrint", valid_589038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589039: Call_ProximitybeaconGetEidparams_589025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Proximity Beacon API's current public key and associated
  ## parameters used to initiate the Diffie-Hellman key exchange required to
  ## register a beacon that broadcasts the Eddystone-EID format. This key
  ## changes periodically; clients may cache it and re-use the same public key
  ## to provision and register multiple beacons. However, clients should be
  ## prepared to refresh this key when they encounter an error registering an
  ## Eddystone-EID beacon.
  ## 
  let valid = call_589039.validator(path, query, header, formData, body)
  let scheme = call_589039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589039.url(scheme.get, call_589039.host, call_589039.base,
                         call_589039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589039, url, valid)

proc call*(call_589040: Call_ProximitybeaconGetEidparams_589025;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## proximitybeaconGetEidparams
  ## Gets the Proximity Beacon API's current public key and associated
  ## parameters used to initiate the Diffie-Hellman key exchange required to
  ## register a beacon that broadcasts the Eddystone-EID format. This key
  ## changes periodically; clients may cache it and re-use the same public key
  ## to provision and register multiple beacons. However, clients should be
  ## prepared to refresh this key when they encounter an error registering an
  ## Eddystone-EID beacon.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589041 = newJObject()
  add(query_589041, "upload_protocol", newJString(uploadProtocol))
  add(query_589041, "fields", newJString(fields))
  add(query_589041, "quotaUser", newJString(quotaUser))
  add(query_589041, "alt", newJString(alt))
  add(query_589041, "oauth_token", newJString(oauthToken))
  add(query_589041, "callback", newJString(callback))
  add(query_589041, "access_token", newJString(accessToken))
  add(query_589041, "uploadType", newJString(uploadType))
  add(query_589041, "key", newJString(key))
  add(query_589041, "$.xgafv", newJString(Xgafv))
  add(query_589041, "prettyPrint", newJBool(prettyPrint))
  result = call_589040.call(nil, query_589041, nil, nil, nil)

var proximitybeaconGetEidparams* = Call_ProximitybeaconGetEidparams_589025(
    name: "proximitybeaconGetEidparams", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/eidparams",
    validator: validate_ProximitybeaconGetEidparams_589026, base: "/",
    url: url_ProximitybeaconGetEidparams_589027, schemes: {Scheme.Https})
type
  Call_ProximitybeaconNamespacesList_589042 = ref object of OpenApiRestCall_588441
proc url_ProximitybeaconNamespacesList_589044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ProximitybeaconNamespacesList_589043(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all attachment namespaces owned by your Google Developers Console
  ## project. Attachment data associated with a beacon must include a
  ## namespaced type, and the namespace must be owned by your project.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id to list namespaces under.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589045 = query.getOrDefault("upload_protocol")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "upload_protocol", valid_589045
  var valid_589046 = query.getOrDefault("fields")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "fields", valid_589046
  var valid_589047 = query.getOrDefault("quotaUser")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "quotaUser", valid_589047
  var valid_589048 = query.getOrDefault("alt")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = newJString("json"))
  if valid_589048 != nil:
    section.add "alt", valid_589048
  var valid_589049 = query.getOrDefault("oauth_token")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "oauth_token", valid_589049
  var valid_589050 = query.getOrDefault("callback")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "callback", valid_589050
  var valid_589051 = query.getOrDefault("access_token")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "access_token", valid_589051
  var valid_589052 = query.getOrDefault("uploadType")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "uploadType", valid_589052
  var valid_589053 = query.getOrDefault("key")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "key", valid_589053
  var valid_589054 = query.getOrDefault("$.xgafv")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("1"))
  if valid_589054 != nil:
    section.add "$.xgafv", valid_589054
  var valid_589055 = query.getOrDefault("projectId")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "projectId", valid_589055
  var valid_589056 = query.getOrDefault("prettyPrint")
  valid_589056 = validateParameter(valid_589056, JBool, required = false,
                                 default = newJBool(true))
  if valid_589056 != nil:
    section.add "prettyPrint", valid_589056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589057: Call_ProximitybeaconNamespacesList_589042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all attachment namespaces owned by your Google Developers Console
  ## project. Attachment data associated with a beacon must include a
  ## namespaced type, and the namespace must be owned by your project.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  let valid = call_589057.validator(path, query, header, formData, body)
  let scheme = call_589057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589057.url(scheme.get, call_589057.host, call_589057.base,
                         call_589057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589057, url, valid)

proc call*(call_589058: Call_ProximitybeaconNamespacesList_589042;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; projectId: string = ""; prettyPrint: bool = true): Recallable =
  ## proximitybeaconNamespacesList
  ## Lists all attachment namespaces owned by your Google Developers Console
  ## project. Attachment data associated with a beacon must include a
  ## namespaced type, and the namespace must be owned by your project.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id to list namespaces under.
  ## Optional.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589059 = newJObject()
  add(query_589059, "upload_protocol", newJString(uploadProtocol))
  add(query_589059, "fields", newJString(fields))
  add(query_589059, "quotaUser", newJString(quotaUser))
  add(query_589059, "alt", newJString(alt))
  add(query_589059, "oauth_token", newJString(oauthToken))
  add(query_589059, "callback", newJString(callback))
  add(query_589059, "access_token", newJString(accessToken))
  add(query_589059, "uploadType", newJString(uploadType))
  add(query_589059, "key", newJString(key))
  add(query_589059, "$.xgafv", newJString(Xgafv))
  add(query_589059, "projectId", newJString(projectId))
  add(query_589059, "prettyPrint", newJBool(prettyPrint))
  result = call_589058.call(nil, query_589059, nil, nil, nil)

var proximitybeaconNamespacesList* = Call_ProximitybeaconNamespacesList_589042(
    name: "proximitybeaconNamespacesList", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/namespaces",
    validator: validate_ProximitybeaconNamespacesList_589043, base: "/",
    url: url_ProximitybeaconNamespacesList_589044, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsAttachmentsDelete_589060 = ref object of OpenApiRestCall_588441
proc url_ProximitybeaconBeaconsAttachmentsDelete_589062(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "attachmentName" in path, "`attachmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "attachmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsAttachmentsDelete_589061(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified attachment for the given beacon. Each attachment has
  ## a unique attachment name (`attachmentName`) which is returned when you
  ## fetch the attachment data via this API. You specify this with the delete
  ## request to control which attachment is removed. This operation cannot be
  ## undone.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   attachmentName: JString (required)
  ##                 : The attachment name (`attachmentName`) of
  ## the attachment to remove. For example:
  ## `beacons/3!893737abc9/attachments/c5e937-af0-494-959-ec49d12738`. For
  ## Eddystone-EID beacons, the beacon ID portion (`3!893737abc9`) may be the
  ## beacon's current EID, or its "stable" Eddystone-UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `attachmentName` field"
  var valid_589077 = path.getOrDefault("attachmentName")
  valid_589077 = validateParameter(valid_589077, JString, required = true,
                                 default = nil)
  if valid_589077 != nil:
    section.add "attachmentName", valid_589077
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the attachment to delete. If not provided, the project
  ## that is making the request is used.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589078 = query.getOrDefault("upload_protocol")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "upload_protocol", valid_589078
  var valid_589079 = query.getOrDefault("fields")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "fields", valid_589079
  var valid_589080 = query.getOrDefault("quotaUser")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "quotaUser", valid_589080
  var valid_589081 = query.getOrDefault("alt")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = newJString("json"))
  if valid_589081 != nil:
    section.add "alt", valid_589081
  var valid_589082 = query.getOrDefault("oauth_token")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "oauth_token", valid_589082
  var valid_589083 = query.getOrDefault("callback")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "callback", valid_589083
  var valid_589084 = query.getOrDefault("access_token")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "access_token", valid_589084
  var valid_589085 = query.getOrDefault("uploadType")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "uploadType", valid_589085
  var valid_589086 = query.getOrDefault("key")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "key", valid_589086
  var valid_589087 = query.getOrDefault("$.xgafv")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = newJString("1"))
  if valid_589087 != nil:
    section.add "$.xgafv", valid_589087
  var valid_589088 = query.getOrDefault("projectId")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "projectId", valid_589088
  var valid_589089 = query.getOrDefault("prettyPrint")
  valid_589089 = validateParameter(valid_589089, JBool, required = false,
                                 default = newJBool(true))
  if valid_589089 != nil:
    section.add "prettyPrint", valid_589089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589090: Call_ProximitybeaconBeaconsAttachmentsDelete_589060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified attachment for the given beacon. Each attachment has
  ## a unique attachment name (`attachmentName`) which is returned when you
  ## fetch the attachment data via this API. You specify this with the delete
  ## request to control which attachment is removed. This operation cannot be
  ## undone.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_589090.validator(path, query, header, formData, body)
  let scheme = call_589090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589090.url(scheme.get, call_589090.host, call_589090.base,
                         call_589090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589090, url, valid)

proc call*(call_589091: Call_ProximitybeaconBeaconsAttachmentsDelete_589060;
          attachmentName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsAttachmentsDelete
  ## Deletes the specified attachment for the given beacon. Each attachment has
  ## a unique attachment name (`attachmentName`) which is returned when you
  ## fetch the attachment data via this API. You specify this with the delete
  ## request to control which attachment is removed. This operation cannot be
  ## undone.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   attachmentName: string (required)
  ##                 : The attachment name (`attachmentName`) of
  ## the attachment to remove. For example:
  ## `beacons/3!893737abc9/attachments/c5e937-af0-494-959-ec49d12738`. For
  ## Eddystone-EID beacons, the beacon ID portion (`3!893737abc9`) may be the
  ## beacon's current EID, or its "stable" Eddystone-UID.
  ## Required.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the attachment to delete. If not provided, the project
  ## that is making the request is used.
  ## Optional.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589092 = newJObject()
  var query_589093 = newJObject()
  add(query_589093, "upload_protocol", newJString(uploadProtocol))
  add(query_589093, "fields", newJString(fields))
  add(query_589093, "quotaUser", newJString(quotaUser))
  add(path_589092, "attachmentName", newJString(attachmentName))
  add(query_589093, "alt", newJString(alt))
  add(query_589093, "oauth_token", newJString(oauthToken))
  add(query_589093, "callback", newJString(callback))
  add(query_589093, "access_token", newJString(accessToken))
  add(query_589093, "uploadType", newJString(uploadType))
  add(query_589093, "key", newJString(key))
  add(query_589093, "$.xgafv", newJString(Xgafv))
  add(query_589093, "projectId", newJString(projectId))
  add(query_589093, "prettyPrint", newJBool(prettyPrint))
  result = call_589091.call(path_589092, query_589093, nil, nil, nil)

var proximitybeaconBeaconsAttachmentsDelete* = Call_ProximitybeaconBeaconsAttachmentsDelete_589060(
    name: "proximitybeaconBeaconsAttachmentsDelete", meth: HttpMethod.HttpDelete,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{attachmentName}",
    validator: validate_ProximitybeaconBeaconsAttachmentsDelete_589061, base: "/",
    url: url_ProximitybeaconBeaconsAttachmentsDelete_589062,
    schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsUpdate_589114 = ref object of OpenApiRestCall_588441
proc url_ProximitybeaconBeaconsUpdate_589116(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsUpdate_589115(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the information about the specified beacon. **Any field that you do
  ## not populate in the submitted beacon will be permanently erased**, so you
  ## should follow the "read, modify, write" pattern to avoid inadvertently
  ## destroying data.
  ## 
  ## Changes to the beacon status via this method will be  silently ignored.
  ## To update beacon status, use the separate methods on this API for
  ## activation, deactivation, and decommissioning.
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Resource name of this beacon. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone, `1` for iBeacon, or `5` for AltBeacon.
  ## 
  ## This field must be left empty when registering. After reading a beacon,
  ## clients can use the name for future operations.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_589117 = path.getOrDefault("beaconName")
  valid_589117 = validateParameter(valid_589117, JString, required = true,
                                 default = nil)
  if valid_589117 != nil:
    section.add "beaconName", valid_589117
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the beacon to update. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589118 = query.getOrDefault("upload_protocol")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "upload_protocol", valid_589118
  var valid_589119 = query.getOrDefault("fields")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "fields", valid_589119
  var valid_589120 = query.getOrDefault("quotaUser")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "quotaUser", valid_589120
  var valid_589121 = query.getOrDefault("alt")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = newJString("json"))
  if valid_589121 != nil:
    section.add "alt", valid_589121
  var valid_589122 = query.getOrDefault("oauth_token")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "oauth_token", valid_589122
  var valid_589123 = query.getOrDefault("callback")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "callback", valid_589123
  var valid_589124 = query.getOrDefault("access_token")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "access_token", valid_589124
  var valid_589125 = query.getOrDefault("uploadType")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "uploadType", valid_589125
  var valid_589126 = query.getOrDefault("key")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "key", valid_589126
  var valid_589127 = query.getOrDefault("$.xgafv")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = newJString("1"))
  if valid_589127 != nil:
    section.add "$.xgafv", valid_589127
  var valid_589128 = query.getOrDefault("projectId")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "projectId", valid_589128
  var valid_589129 = query.getOrDefault("prettyPrint")
  valid_589129 = validateParameter(valid_589129, JBool, required = false,
                                 default = newJBool(true))
  if valid_589129 != nil:
    section.add "prettyPrint", valid_589129
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

proc call*(call_589131: Call_ProximitybeaconBeaconsUpdate_589114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the information about the specified beacon. **Any field that you do
  ## not populate in the submitted beacon will be permanently erased**, so you
  ## should follow the "read, modify, write" pattern to avoid inadvertently
  ## destroying data.
  ## 
  ## Changes to the beacon status via this method will be  silently ignored.
  ## To update beacon status, use the separate methods on this API for
  ## activation, deactivation, and decommissioning.
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_589131.validator(path, query, header, formData, body)
  let scheme = call_589131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589131.url(scheme.get, call_589131.host, call_589131.base,
                         call_589131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589131, url, valid)

proc call*(call_589132: Call_ProximitybeaconBeaconsUpdate_589114;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsUpdate
  ## Updates the information about the specified beacon. **Any field that you do
  ## not populate in the submitted beacon will be permanently erased**, so you
  ## should follow the "read, modify, write" pattern to avoid inadvertently
  ## destroying data.
  ## 
  ## Changes to the beacon status via this method will be  silently ignored.
  ## To update beacon status, use the separate methods on this API for
  ## activation, deactivation, and decommissioning.
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the beacon to update. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  ##   beaconName: string (required)
  ##             : Resource name of this beacon. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone, `1` for iBeacon, or `5` for AltBeacon.
  ## 
  ## This field must be left empty when registering. After reading a beacon,
  ## clients can use the name for future operations.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589133 = newJObject()
  var query_589134 = newJObject()
  var body_589135 = newJObject()
  add(query_589134, "upload_protocol", newJString(uploadProtocol))
  add(query_589134, "fields", newJString(fields))
  add(query_589134, "quotaUser", newJString(quotaUser))
  add(query_589134, "alt", newJString(alt))
  add(query_589134, "oauth_token", newJString(oauthToken))
  add(query_589134, "callback", newJString(callback))
  add(query_589134, "access_token", newJString(accessToken))
  add(query_589134, "uploadType", newJString(uploadType))
  add(query_589134, "key", newJString(key))
  add(query_589134, "$.xgafv", newJString(Xgafv))
  add(query_589134, "projectId", newJString(projectId))
  add(path_589133, "beaconName", newJString(beaconName))
  if body != nil:
    body_589135 = body
  add(query_589134, "prettyPrint", newJBool(prettyPrint))
  result = call_589132.call(path_589133, query_589134, nil, nil, body_589135)

var proximitybeaconBeaconsUpdate* = Call_ProximitybeaconBeaconsUpdate_589114(
    name: "proximitybeaconBeaconsUpdate", meth: HttpMethod.HttpPut,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{beaconName}",
    validator: validate_ProximitybeaconBeaconsUpdate_589115, base: "/",
    url: url_ProximitybeaconBeaconsUpdate_589116, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsGet_589094 = ref object of OpenApiRestCall_588441
proc url_ProximitybeaconBeaconsGet_589096(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsGet_589095(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns detailed information about the specified beacon.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  ## Requests may supply an Eddystone-EID beacon name in the form:
  ## `beacons/4!beaconId` where the `beaconId` is the base16 ephemeral ID
  ## broadcast by the beacon. The returned `Beacon` object will contain the
  ## beacon's stable Eddystone-UID. Clients not authorized to resolve the
  ## beacon's ephemeral Eddystone-EID broadcast will receive an error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Resource name of this beacon. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_589097 = path.getOrDefault("beaconName")
  valid_589097 = validateParameter(valid_589097, JString, required = true,
                                 default = nil)
  if valid_589097 != nil:
    section.add "beaconName", valid_589097
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the beacon to request. If the project id is not specified
  ## then the project making the request is used. The project id must match the
  ## project that owns the beacon.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589098 = query.getOrDefault("upload_protocol")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "upload_protocol", valid_589098
  var valid_589099 = query.getOrDefault("fields")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "fields", valid_589099
  var valid_589100 = query.getOrDefault("quotaUser")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "quotaUser", valid_589100
  var valid_589101 = query.getOrDefault("alt")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = newJString("json"))
  if valid_589101 != nil:
    section.add "alt", valid_589101
  var valid_589102 = query.getOrDefault("oauth_token")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "oauth_token", valid_589102
  var valid_589103 = query.getOrDefault("callback")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "callback", valid_589103
  var valid_589104 = query.getOrDefault("access_token")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "access_token", valid_589104
  var valid_589105 = query.getOrDefault("uploadType")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "uploadType", valid_589105
  var valid_589106 = query.getOrDefault("key")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "key", valid_589106
  var valid_589107 = query.getOrDefault("$.xgafv")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = newJString("1"))
  if valid_589107 != nil:
    section.add "$.xgafv", valid_589107
  var valid_589108 = query.getOrDefault("projectId")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "projectId", valid_589108
  var valid_589109 = query.getOrDefault("prettyPrint")
  valid_589109 = validateParameter(valid_589109, JBool, required = false,
                                 default = newJBool(true))
  if valid_589109 != nil:
    section.add "prettyPrint", valid_589109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589110: Call_ProximitybeaconBeaconsGet_589094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns detailed information about the specified beacon.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  ## Requests may supply an Eddystone-EID beacon name in the form:
  ## `beacons/4!beaconId` where the `beaconId` is the base16 ephemeral ID
  ## broadcast by the beacon. The returned `Beacon` object will contain the
  ## beacon's stable Eddystone-UID. Clients not authorized to resolve the
  ## beacon's ephemeral Eddystone-EID broadcast will receive an error.
  ## 
  let valid = call_589110.validator(path, query, header, formData, body)
  let scheme = call_589110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589110.url(scheme.get, call_589110.host, call_589110.base,
                         call_589110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589110, url, valid)

proc call*(call_589111: Call_ProximitybeaconBeaconsGet_589094; beaconName: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; projectId: string = ""; prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsGet
  ## Returns detailed information about the specified beacon.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  ## Requests may supply an Eddystone-EID beacon name in the form:
  ## `beacons/4!beaconId` where the `beaconId` is the base16 ephemeral ID
  ## broadcast by the beacon. The returned `Beacon` object will contain the
  ## beacon's stable Eddystone-UID. Clients not authorized to resolve the
  ## beacon's ephemeral Eddystone-EID broadcast will receive an error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the beacon to request. If the project id is not specified
  ## then the project making the request is used. The project id must match the
  ## project that owns the beacon.
  ## Optional.
  ##   beaconName: string (required)
  ##             : Resource name of this beacon. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589112 = newJObject()
  var query_589113 = newJObject()
  add(query_589113, "upload_protocol", newJString(uploadProtocol))
  add(query_589113, "fields", newJString(fields))
  add(query_589113, "quotaUser", newJString(quotaUser))
  add(query_589113, "alt", newJString(alt))
  add(query_589113, "oauth_token", newJString(oauthToken))
  add(query_589113, "callback", newJString(callback))
  add(query_589113, "access_token", newJString(accessToken))
  add(query_589113, "uploadType", newJString(uploadType))
  add(query_589113, "key", newJString(key))
  add(query_589113, "$.xgafv", newJString(Xgafv))
  add(query_589113, "projectId", newJString(projectId))
  add(path_589112, "beaconName", newJString(beaconName))
  add(query_589113, "prettyPrint", newJBool(prettyPrint))
  result = call_589111.call(path_589112, query_589113, nil, nil, nil)

var proximitybeaconBeaconsGet* = Call_ProximitybeaconBeaconsGet_589094(
    name: "proximitybeaconBeaconsGet", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{beaconName}",
    validator: validate_ProximitybeaconBeaconsGet_589095, base: "/",
    url: url_ProximitybeaconBeaconsGet_589096, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsDelete_589136 = ref object of OpenApiRestCall_588441
proc url_ProximitybeaconBeaconsDelete_589138(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsDelete_589137(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified beacon including all diagnostics data for the beacon
  ## as well as any attachments on the beacon (including those belonging to
  ## other projects). This operation cannot be undone.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon that should be deleted. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_589139 = path.getOrDefault("beaconName")
  valid_589139 = validateParameter(valid_589139, JString, required = true,
                                 default = nil)
  if valid_589139 != nil:
    section.add "beaconName", valid_589139
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the beacon to delete. If not provided, the project
  ## that is making the request is used.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589140 = query.getOrDefault("upload_protocol")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "upload_protocol", valid_589140
  var valid_589141 = query.getOrDefault("fields")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "fields", valid_589141
  var valid_589142 = query.getOrDefault("quotaUser")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "quotaUser", valid_589142
  var valid_589143 = query.getOrDefault("alt")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = newJString("json"))
  if valid_589143 != nil:
    section.add "alt", valid_589143
  var valid_589144 = query.getOrDefault("oauth_token")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "oauth_token", valid_589144
  var valid_589145 = query.getOrDefault("callback")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "callback", valid_589145
  var valid_589146 = query.getOrDefault("access_token")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "access_token", valid_589146
  var valid_589147 = query.getOrDefault("uploadType")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "uploadType", valid_589147
  var valid_589148 = query.getOrDefault("key")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "key", valid_589148
  var valid_589149 = query.getOrDefault("$.xgafv")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = newJString("1"))
  if valid_589149 != nil:
    section.add "$.xgafv", valid_589149
  var valid_589150 = query.getOrDefault("projectId")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "projectId", valid_589150
  var valid_589151 = query.getOrDefault("prettyPrint")
  valid_589151 = validateParameter(valid_589151, JBool, required = false,
                                 default = newJBool(true))
  if valid_589151 != nil:
    section.add "prettyPrint", valid_589151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589152: Call_ProximitybeaconBeaconsDelete_589136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified beacon including all diagnostics data for the beacon
  ## as well as any attachments on the beacon (including those belonging to
  ## other projects). This operation cannot be undone.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_589152.validator(path, query, header, formData, body)
  let scheme = call_589152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589152.url(scheme.get, call_589152.host, call_589152.base,
                         call_589152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589152, url, valid)

proc call*(call_589153: Call_ProximitybeaconBeaconsDelete_589136;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsDelete
  ## Deletes the specified beacon including all diagnostics data for the beacon
  ## as well as any attachments on the beacon (including those belonging to
  ## other projects). This operation cannot be undone.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the beacon to delete. If not provided, the project
  ## that is making the request is used.
  ## Optional.
  ##   beaconName: string (required)
  ##             : Beacon that should be deleted. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589154 = newJObject()
  var query_589155 = newJObject()
  add(query_589155, "upload_protocol", newJString(uploadProtocol))
  add(query_589155, "fields", newJString(fields))
  add(query_589155, "quotaUser", newJString(quotaUser))
  add(query_589155, "alt", newJString(alt))
  add(query_589155, "oauth_token", newJString(oauthToken))
  add(query_589155, "callback", newJString(callback))
  add(query_589155, "access_token", newJString(accessToken))
  add(query_589155, "uploadType", newJString(uploadType))
  add(query_589155, "key", newJString(key))
  add(query_589155, "$.xgafv", newJString(Xgafv))
  add(query_589155, "projectId", newJString(projectId))
  add(path_589154, "beaconName", newJString(beaconName))
  add(query_589155, "prettyPrint", newJBool(prettyPrint))
  result = call_589153.call(path_589154, query_589155, nil, nil, nil)

var proximitybeaconBeaconsDelete* = Call_ProximitybeaconBeaconsDelete_589136(
    name: "proximitybeaconBeaconsDelete", meth: HttpMethod.HttpDelete,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{beaconName}",
    validator: validate_ProximitybeaconBeaconsDelete_589137, base: "/",
    url: url_ProximitybeaconBeaconsDelete_589138, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsAttachmentsCreate_589177 = ref object of OpenApiRestCall_588441
proc url_ProximitybeaconBeaconsAttachmentsCreate_589179(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: "/attachments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsAttachmentsCreate_589178(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Associates the given data with the specified beacon. Attachment data must
  ## contain two parts:
  ## <ul>
  ## <li>A namespaced type.</li>
  ## <li>The actual attachment data itself.</li>
  ## </ul>
  ## The namespaced type consists of two parts, the namespace and the type.
  ## The namespace must be one of the values returned by the `namespaces`
  ## endpoint, while the type can be a string of any characters except for the
  ## forward slash (`/`) up to 100 characters in length.
  ## 
  ## Attachment data can be up to 1024 bytes long.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon on which the attachment should be created. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_589180 = path.getOrDefault("beaconName")
  valid_589180 = validateParameter(valid_589180, JString, required = true,
                                 default = nil)
  if valid_589180 != nil:
    section.add "beaconName", valid_589180
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the project the attachment will belong to. If
  ## the project id is not specified then the project making the request
  ## is used.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589181 = query.getOrDefault("upload_protocol")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "upload_protocol", valid_589181
  var valid_589182 = query.getOrDefault("fields")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "fields", valid_589182
  var valid_589183 = query.getOrDefault("quotaUser")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "quotaUser", valid_589183
  var valid_589184 = query.getOrDefault("alt")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = newJString("json"))
  if valid_589184 != nil:
    section.add "alt", valid_589184
  var valid_589185 = query.getOrDefault("oauth_token")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "oauth_token", valid_589185
  var valid_589186 = query.getOrDefault("callback")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "callback", valid_589186
  var valid_589187 = query.getOrDefault("access_token")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "access_token", valid_589187
  var valid_589188 = query.getOrDefault("uploadType")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "uploadType", valid_589188
  var valid_589189 = query.getOrDefault("key")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "key", valid_589189
  var valid_589190 = query.getOrDefault("$.xgafv")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = newJString("1"))
  if valid_589190 != nil:
    section.add "$.xgafv", valid_589190
  var valid_589191 = query.getOrDefault("projectId")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "projectId", valid_589191
  var valid_589192 = query.getOrDefault("prettyPrint")
  valid_589192 = validateParameter(valid_589192, JBool, required = false,
                                 default = newJBool(true))
  if valid_589192 != nil:
    section.add "prettyPrint", valid_589192
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

proc call*(call_589194: Call_ProximitybeaconBeaconsAttachmentsCreate_589177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Associates the given data with the specified beacon. Attachment data must
  ## contain two parts:
  ## <ul>
  ## <li>A namespaced type.</li>
  ## <li>The actual attachment data itself.</li>
  ## </ul>
  ## The namespaced type consists of two parts, the namespace and the type.
  ## The namespace must be one of the values returned by the `namespaces`
  ## endpoint, while the type can be a string of any characters except for the
  ## forward slash (`/`) up to 100 characters in length.
  ## 
  ## Attachment data can be up to 1024 bytes long.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_589194.validator(path, query, header, formData, body)
  let scheme = call_589194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589194.url(scheme.get, call_589194.host, call_589194.base,
                         call_589194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589194, url, valid)

proc call*(call_589195: Call_ProximitybeaconBeaconsAttachmentsCreate_589177;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsAttachmentsCreate
  ## Associates the given data with the specified beacon. Attachment data must
  ## contain two parts:
  ## <ul>
  ## <li>A namespaced type.</li>
  ## <li>The actual attachment data itself.</li>
  ## </ul>
  ## The namespaced type consists of two parts, the namespace and the type.
  ## The namespace must be one of the values returned by the `namespaces`
  ## endpoint, while the type can be a string of any characters except for the
  ## forward slash (`/`) up to 100 characters in length.
  ## 
  ## Attachment data can be up to 1024 bytes long.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the project the attachment will belong to. If
  ## the project id is not specified then the project making the request
  ## is used.
  ## Optional.
  ##   beaconName: string (required)
  ##             : Beacon on which the attachment should be created. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589196 = newJObject()
  var query_589197 = newJObject()
  var body_589198 = newJObject()
  add(query_589197, "upload_protocol", newJString(uploadProtocol))
  add(query_589197, "fields", newJString(fields))
  add(query_589197, "quotaUser", newJString(quotaUser))
  add(query_589197, "alt", newJString(alt))
  add(query_589197, "oauth_token", newJString(oauthToken))
  add(query_589197, "callback", newJString(callback))
  add(query_589197, "access_token", newJString(accessToken))
  add(query_589197, "uploadType", newJString(uploadType))
  add(query_589197, "key", newJString(key))
  add(query_589197, "$.xgafv", newJString(Xgafv))
  add(query_589197, "projectId", newJString(projectId))
  add(path_589196, "beaconName", newJString(beaconName))
  if body != nil:
    body_589198 = body
  add(query_589197, "prettyPrint", newJBool(prettyPrint))
  result = call_589195.call(path_589196, query_589197, nil, nil, body_589198)

var proximitybeaconBeaconsAttachmentsCreate* = Call_ProximitybeaconBeaconsAttachmentsCreate_589177(
    name: "proximitybeaconBeaconsAttachmentsCreate", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}/attachments",
    validator: validate_ProximitybeaconBeaconsAttachmentsCreate_589178, base: "/",
    url: url_ProximitybeaconBeaconsAttachmentsCreate_589179,
    schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsAttachmentsList_589156 = ref object of OpenApiRestCall_588441
proc url_ProximitybeaconBeaconsAttachmentsList_589158(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: "/attachments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsAttachmentsList_589157(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the attachments for the specified beacon that match the specified
  ## namespaced-type pattern.
  ## 
  ## To control which namespaced types are returned, you add the
  ## `namespacedType` query parameter to the request. You must either use
  ## `*/*`, to return all attachments, or the namespace must be one of
  ## the ones returned from the  `namespaces` endpoint.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon whose attachments should be fetched. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_589159 = path.getOrDefault("beaconName")
  valid_589159 = validateParameter(valid_589159, JString, required = true,
                                 default = nil)
  if valid_589159 != nil:
    section.add "beaconName", valid_589159
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id to list beacon attachments under. This field can be
  ## used when "*" is specified to mean all attachment namespaces. Projects
  ## may have multiple attachments with multiple namespaces. If "*" is
  ## specified and the projectId string is empty, then the project
  ## making the request is used.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   namespacedType: JString
  ##                 : Specifies the namespace and type of attachment to include in response in
  ## <var>namespace/type</var> format. Accepts `*/*` to specify
  ## "all types in all namespaces".
  section = newJObject()
  var valid_589160 = query.getOrDefault("upload_protocol")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "upload_protocol", valid_589160
  var valid_589161 = query.getOrDefault("fields")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "fields", valid_589161
  var valid_589162 = query.getOrDefault("quotaUser")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "quotaUser", valid_589162
  var valid_589163 = query.getOrDefault("alt")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = newJString("json"))
  if valid_589163 != nil:
    section.add "alt", valid_589163
  var valid_589164 = query.getOrDefault("oauth_token")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "oauth_token", valid_589164
  var valid_589165 = query.getOrDefault("callback")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "callback", valid_589165
  var valid_589166 = query.getOrDefault("access_token")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "access_token", valid_589166
  var valid_589167 = query.getOrDefault("uploadType")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "uploadType", valid_589167
  var valid_589168 = query.getOrDefault("key")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "key", valid_589168
  var valid_589169 = query.getOrDefault("$.xgafv")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = newJString("1"))
  if valid_589169 != nil:
    section.add "$.xgafv", valid_589169
  var valid_589170 = query.getOrDefault("projectId")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "projectId", valid_589170
  var valid_589171 = query.getOrDefault("prettyPrint")
  valid_589171 = validateParameter(valid_589171, JBool, required = false,
                                 default = newJBool(true))
  if valid_589171 != nil:
    section.add "prettyPrint", valid_589171
  var valid_589172 = query.getOrDefault("namespacedType")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "namespacedType", valid_589172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589173: Call_ProximitybeaconBeaconsAttachmentsList_589156;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the attachments for the specified beacon that match the specified
  ## namespaced-type pattern.
  ## 
  ## To control which namespaced types are returned, you add the
  ## `namespacedType` query parameter to the request. You must either use
  ## `*/*`, to return all attachments, or the namespace must be one of
  ## the ones returned from the  `namespaces` endpoint.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  let valid = call_589173.validator(path, query, header, formData, body)
  let scheme = call_589173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589173.url(scheme.get, call_589173.host, call_589173.base,
                         call_589173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589173, url, valid)

proc call*(call_589174: Call_ProximitybeaconBeaconsAttachmentsList_589156;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true; namespacedType: string = ""): Recallable =
  ## proximitybeaconBeaconsAttachmentsList
  ## Returns the attachments for the specified beacon that match the specified
  ## namespaced-type pattern.
  ## 
  ## To control which namespaced types are returned, you add the
  ## `namespacedType` query parameter to the request. You must either use
  ## `*/*`, to return all attachments, or the namespace must be one of
  ## the ones returned from the  `namespaces` endpoint.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id to list beacon attachments under. This field can be
  ## used when "*" is specified to mean all attachment namespaces. Projects
  ## may have multiple attachments with multiple namespaces. If "*" is
  ## specified and the projectId string is empty, then the project
  ## making the request is used.
  ## Optional.
  ##   beaconName: string (required)
  ##             : Beacon whose attachments should be fetched. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   namespacedType: string
  ##                 : Specifies the namespace and type of attachment to include in response in
  ## <var>namespace/type</var> format. Accepts `*/*` to specify
  ## "all types in all namespaces".
  var path_589175 = newJObject()
  var query_589176 = newJObject()
  add(query_589176, "upload_protocol", newJString(uploadProtocol))
  add(query_589176, "fields", newJString(fields))
  add(query_589176, "quotaUser", newJString(quotaUser))
  add(query_589176, "alt", newJString(alt))
  add(query_589176, "oauth_token", newJString(oauthToken))
  add(query_589176, "callback", newJString(callback))
  add(query_589176, "access_token", newJString(accessToken))
  add(query_589176, "uploadType", newJString(uploadType))
  add(query_589176, "key", newJString(key))
  add(query_589176, "$.xgafv", newJString(Xgafv))
  add(query_589176, "projectId", newJString(projectId))
  add(path_589175, "beaconName", newJString(beaconName))
  add(query_589176, "prettyPrint", newJBool(prettyPrint))
  add(query_589176, "namespacedType", newJString(namespacedType))
  result = call_589174.call(path_589175, query_589176, nil, nil, nil)

var proximitybeaconBeaconsAttachmentsList* = Call_ProximitybeaconBeaconsAttachmentsList_589156(
    name: "proximitybeaconBeaconsAttachmentsList", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}/attachments",
    validator: validate_ProximitybeaconBeaconsAttachmentsList_589157, base: "/",
    url: url_ProximitybeaconBeaconsAttachmentsList_589158, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsAttachmentsBatchDelete_589199 = ref object of OpenApiRestCall_588441
proc url_ProximitybeaconBeaconsAttachmentsBatchDelete_589201(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: "/attachments:batchDelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsAttachmentsBatchDelete_589200(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes multiple attachments on a given beacon. This operation is
  ## permanent and cannot be undone.
  ## 
  ## You can optionally specify `namespacedType` to choose which attachments
  ## should be deleted. If you do not specify `namespacedType`,  all your
  ## attachments on the given beacon will be deleted. You also may explicitly
  ## specify `*/*` to delete all.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : The beacon whose attachments should be deleted. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_589202 = path.getOrDefault("beaconName")
  valid_589202 = validateParameter(valid_589202, JString, required = true,
                                 default = nil)
  if valid_589202 != nil:
    section.add "beaconName", valid_589202
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id to delete beacon attachments under. This field can be
  ## used when "*" is specified to mean all attachment namespaces. Projects
  ## may have multiple attachments with multiple namespaces. If "*" is
  ## specified and the projectId string is empty, then the project
  ## making the request is used.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   namespacedType: JString
  ##                 : Specifies the namespace and type of attachments to delete in
  ## `namespace/type` format. Accepts `*/*` to specify
  ## "all types in all namespaces".
  ## Optional.
  section = newJObject()
  var valid_589203 = query.getOrDefault("upload_protocol")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "upload_protocol", valid_589203
  var valid_589204 = query.getOrDefault("fields")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "fields", valid_589204
  var valid_589205 = query.getOrDefault("quotaUser")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "quotaUser", valid_589205
  var valid_589206 = query.getOrDefault("alt")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = newJString("json"))
  if valid_589206 != nil:
    section.add "alt", valid_589206
  var valid_589207 = query.getOrDefault("oauth_token")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "oauth_token", valid_589207
  var valid_589208 = query.getOrDefault("callback")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "callback", valid_589208
  var valid_589209 = query.getOrDefault("access_token")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "access_token", valid_589209
  var valid_589210 = query.getOrDefault("uploadType")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "uploadType", valid_589210
  var valid_589211 = query.getOrDefault("key")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "key", valid_589211
  var valid_589212 = query.getOrDefault("$.xgafv")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = newJString("1"))
  if valid_589212 != nil:
    section.add "$.xgafv", valid_589212
  var valid_589213 = query.getOrDefault("projectId")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "projectId", valid_589213
  var valid_589214 = query.getOrDefault("prettyPrint")
  valid_589214 = validateParameter(valid_589214, JBool, required = false,
                                 default = newJBool(true))
  if valid_589214 != nil:
    section.add "prettyPrint", valid_589214
  var valid_589215 = query.getOrDefault("namespacedType")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "namespacedType", valid_589215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589216: Call_ProximitybeaconBeaconsAttachmentsBatchDelete_589199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes multiple attachments on a given beacon. This operation is
  ## permanent and cannot be undone.
  ## 
  ## You can optionally specify `namespacedType` to choose which attachments
  ## should be deleted. If you do not specify `namespacedType`,  all your
  ## attachments on the given beacon will be deleted. You also may explicitly
  ## specify `*/*` to delete all.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_589216.validator(path, query, header, formData, body)
  let scheme = call_589216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589216.url(scheme.get, call_589216.host, call_589216.base,
                         call_589216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589216, url, valid)

proc call*(call_589217: Call_ProximitybeaconBeaconsAttachmentsBatchDelete_589199;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true; namespacedType: string = ""): Recallable =
  ## proximitybeaconBeaconsAttachmentsBatchDelete
  ## Deletes multiple attachments on a given beacon. This operation is
  ## permanent and cannot be undone.
  ## 
  ## You can optionally specify `namespacedType` to choose which attachments
  ## should be deleted. If you do not specify `namespacedType`,  all your
  ## attachments on the given beacon will be deleted. You also may explicitly
  ## specify `*/*` to delete all.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id to delete beacon attachments under. This field can be
  ## used when "*" is specified to mean all attachment namespaces. Projects
  ## may have multiple attachments with multiple namespaces. If "*" is
  ## specified and the projectId string is empty, then the project
  ## making the request is used.
  ## Optional.
  ##   beaconName: string (required)
  ##             : The beacon whose attachments should be deleted. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   namespacedType: string
  ##                 : Specifies the namespace and type of attachments to delete in
  ## `namespace/type` format. Accepts `*/*` to specify
  ## "all types in all namespaces".
  ## Optional.
  var path_589218 = newJObject()
  var query_589219 = newJObject()
  add(query_589219, "upload_protocol", newJString(uploadProtocol))
  add(query_589219, "fields", newJString(fields))
  add(query_589219, "quotaUser", newJString(quotaUser))
  add(query_589219, "alt", newJString(alt))
  add(query_589219, "oauth_token", newJString(oauthToken))
  add(query_589219, "callback", newJString(callback))
  add(query_589219, "access_token", newJString(accessToken))
  add(query_589219, "uploadType", newJString(uploadType))
  add(query_589219, "key", newJString(key))
  add(query_589219, "$.xgafv", newJString(Xgafv))
  add(query_589219, "projectId", newJString(projectId))
  add(path_589218, "beaconName", newJString(beaconName))
  add(query_589219, "prettyPrint", newJBool(prettyPrint))
  add(query_589219, "namespacedType", newJString(namespacedType))
  result = call_589217.call(path_589218, query_589219, nil, nil, nil)

var proximitybeaconBeaconsAttachmentsBatchDelete* = Call_ProximitybeaconBeaconsAttachmentsBatchDelete_589199(
    name: "proximitybeaconBeaconsAttachmentsBatchDelete",
    meth: HttpMethod.HttpPost, host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}/attachments:batchDelete",
    validator: validate_ProximitybeaconBeaconsAttachmentsBatchDelete_589200,
    base: "/", url: url_ProximitybeaconBeaconsAttachmentsBatchDelete_589201,
    schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsDiagnosticsList_589220 = ref object of OpenApiRestCall_588441
proc url_ProximitybeaconBeaconsDiagnosticsList_589222(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: "/diagnostics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsDiagnosticsList_589221(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the diagnostics for a single beacon. You can also list diagnostics for
  ## all the beacons owned by your Google Developers Console project by using
  ## the beacon name `beacons/-`.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon that the diagnostics are for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_589223 = path.getOrDefault("beaconName")
  valid_589223 = validateParameter(valid_589223, JString, required = true,
                                 default = nil)
  if valid_589223 != nil:
    section.add "beaconName", valid_589223
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   alertFilter: JString
  ##              : Requests only beacons that have the given alert. For example, to find
  ## beacons that have low batteries use `alert_filter=LOW_BATTERY`.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Requests results that occur after the `page_token`, obtained from the
  ## response to a previous request. Optional.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Specifies the maximum number of results to return. Defaults to
  ## 10. Maximum 1000. Optional.
  ##   projectId: JString
  ##            : Requests only diagnostic records for the given project id. If not set,
  ## then the project making the request will be used for looking up
  ## diagnostic records. Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589224 = query.getOrDefault("upload_protocol")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "upload_protocol", valid_589224
  var valid_589225 = query.getOrDefault("fields")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "fields", valid_589225
  var valid_589226 = query.getOrDefault("alertFilter")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = newJString("ALERT_UNSPECIFIED"))
  if valid_589226 != nil:
    section.add "alertFilter", valid_589226
  var valid_589227 = query.getOrDefault("quotaUser")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "quotaUser", valid_589227
  var valid_589228 = query.getOrDefault("pageToken")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "pageToken", valid_589228
  var valid_589229 = query.getOrDefault("alt")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = newJString("json"))
  if valid_589229 != nil:
    section.add "alt", valid_589229
  var valid_589230 = query.getOrDefault("oauth_token")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "oauth_token", valid_589230
  var valid_589231 = query.getOrDefault("callback")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "callback", valid_589231
  var valid_589232 = query.getOrDefault("access_token")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "access_token", valid_589232
  var valid_589233 = query.getOrDefault("uploadType")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "uploadType", valid_589233
  var valid_589234 = query.getOrDefault("key")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "key", valid_589234
  var valid_589235 = query.getOrDefault("$.xgafv")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = newJString("1"))
  if valid_589235 != nil:
    section.add "$.xgafv", valid_589235
  var valid_589236 = query.getOrDefault("pageSize")
  valid_589236 = validateParameter(valid_589236, JInt, required = false, default = nil)
  if valid_589236 != nil:
    section.add "pageSize", valid_589236
  var valid_589237 = query.getOrDefault("projectId")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "projectId", valid_589237
  var valid_589238 = query.getOrDefault("prettyPrint")
  valid_589238 = validateParameter(valid_589238, JBool, required = false,
                                 default = newJBool(true))
  if valid_589238 != nil:
    section.add "prettyPrint", valid_589238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589239: Call_ProximitybeaconBeaconsDiagnosticsList_589220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the diagnostics for a single beacon. You can also list diagnostics for
  ## all the beacons owned by your Google Developers Console project by using
  ## the beacon name `beacons/-`.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  let valid = call_589239.validator(path, query, header, formData, body)
  let scheme = call_589239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589239.url(scheme.get, call_589239.host, call_589239.base,
                         call_589239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589239, url, valid)

proc call*(call_589240: Call_ProximitybeaconBeaconsDiagnosticsList_589220;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          alertFilter: string = "ALERT_UNSPECIFIED"; quotaUser: string = "";
          pageToken: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; projectId: string = "";
          prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsDiagnosticsList
  ## List the diagnostics for a single beacon. You can also list diagnostics for
  ## all the beacons owned by your Google Developers Console project by using
  ## the beacon name `beacons/-`.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   alertFilter: string
  ##              : Requests only beacons that have the given alert. For example, to find
  ## beacons that have low batteries use `alert_filter=LOW_BATTERY`.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Requests results that occur after the `page_token`, obtained from the
  ## response to a previous request. Optional.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the maximum number of results to return. Defaults to
  ## 10. Maximum 1000. Optional.
  ##   projectId: string
  ##            : Requests only diagnostic records for the given project id. If not set,
  ## then the project making the request will be used for looking up
  ## diagnostic records. Optional.
  ##   beaconName: string (required)
  ##             : Beacon that the diagnostics are for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589241 = newJObject()
  var query_589242 = newJObject()
  add(query_589242, "upload_protocol", newJString(uploadProtocol))
  add(query_589242, "fields", newJString(fields))
  add(query_589242, "alertFilter", newJString(alertFilter))
  add(query_589242, "quotaUser", newJString(quotaUser))
  add(query_589242, "pageToken", newJString(pageToken))
  add(query_589242, "alt", newJString(alt))
  add(query_589242, "oauth_token", newJString(oauthToken))
  add(query_589242, "callback", newJString(callback))
  add(query_589242, "access_token", newJString(accessToken))
  add(query_589242, "uploadType", newJString(uploadType))
  add(query_589242, "key", newJString(key))
  add(query_589242, "$.xgafv", newJString(Xgafv))
  add(query_589242, "pageSize", newJInt(pageSize))
  add(query_589242, "projectId", newJString(projectId))
  add(path_589241, "beaconName", newJString(beaconName))
  add(query_589242, "prettyPrint", newJBool(prettyPrint))
  result = call_589240.call(path_589241, query_589242, nil, nil, nil)

var proximitybeaconBeaconsDiagnosticsList* = Call_ProximitybeaconBeaconsDiagnosticsList_589220(
    name: "proximitybeaconBeaconsDiagnosticsList", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}/diagnostics",
    validator: validate_ProximitybeaconBeaconsDiagnosticsList_589221, base: "/",
    url: url_ProximitybeaconBeaconsDiagnosticsList_589222, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsActivate_589243 = ref object of OpenApiRestCall_588441
proc url_ProximitybeaconBeaconsActivate_589245(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: ":activate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsActivate_589244(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Activates a beacon. A beacon that is active will return information
  ## and attachment data when queried via `beaconinfo.getforobserved`.
  ## Calling this method on an already active beacon will do nothing (but
  ## will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon that should be activated. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_589246 = path.getOrDefault("beaconName")
  valid_589246 = validateParameter(valid_589246, JString, required = true,
                                 default = nil)
  if valid_589246 != nil:
    section.add "beaconName", valid_589246
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the beacon to activate. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589247 = query.getOrDefault("upload_protocol")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "upload_protocol", valid_589247
  var valid_589248 = query.getOrDefault("fields")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "fields", valid_589248
  var valid_589249 = query.getOrDefault("quotaUser")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "quotaUser", valid_589249
  var valid_589250 = query.getOrDefault("alt")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = newJString("json"))
  if valid_589250 != nil:
    section.add "alt", valid_589250
  var valid_589251 = query.getOrDefault("oauth_token")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "oauth_token", valid_589251
  var valid_589252 = query.getOrDefault("callback")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "callback", valid_589252
  var valid_589253 = query.getOrDefault("access_token")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "access_token", valid_589253
  var valid_589254 = query.getOrDefault("uploadType")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "uploadType", valid_589254
  var valid_589255 = query.getOrDefault("key")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "key", valid_589255
  var valid_589256 = query.getOrDefault("$.xgafv")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = newJString("1"))
  if valid_589256 != nil:
    section.add "$.xgafv", valid_589256
  var valid_589257 = query.getOrDefault("projectId")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "projectId", valid_589257
  var valid_589258 = query.getOrDefault("prettyPrint")
  valid_589258 = validateParameter(valid_589258, JBool, required = false,
                                 default = newJBool(true))
  if valid_589258 != nil:
    section.add "prettyPrint", valid_589258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589259: Call_ProximitybeaconBeaconsActivate_589243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activates a beacon. A beacon that is active will return information
  ## and attachment data when queried via `beaconinfo.getforobserved`.
  ## Calling this method on an already active beacon will do nothing (but
  ## will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_589259.validator(path, query, header, formData, body)
  let scheme = call_589259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589259.url(scheme.get, call_589259.host, call_589259.base,
                         call_589259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589259, url, valid)

proc call*(call_589260: Call_ProximitybeaconBeaconsActivate_589243;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsActivate
  ## Activates a beacon. A beacon that is active will return information
  ## and attachment data when queried via `beaconinfo.getforobserved`.
  ## Calling this method on an already active beacon will do nothing (but
  ## will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the beacon to activate. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  ##   beaconName: string (required)
  ##             : Beacon that should be activated. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589261 = newJObject()
  var query_589262 = newJObject()
  add(query_589262, "upload_protocol", newJString(uploadProtocol))
  add(query_589262, "fields", newJString(fields))
  add(query_589262, "quotaUser", newJString(quotaUser))
  add(query_589262, "alt", newJString(alt))
  add(query_589262, "oauth_token", newJString(oauthToken))
  add(query_589262, "callback", newJString(callback))
  add(query_589262, "access_token", newJString(accessToken))
  add(query_589262, "uploadType", newJString(uploadType))
  add(query_589262, "key", newJString(key))
  add(query_589262, "$.xgafv", newJString(Xgafv))
  add(query_589262, "projectId", newJString(projectId))
  add(path_589261, "beaconName", newJString(beaconName))
  add(query_589262, "prettyPrint", newJBool(prettyPrint))
  result = call_589260.call(path_589261, query_589262, nil, nil, nil)

var proximitybeaconBeaconsActivate* = Call_ProximitybeaconBeaconsActivate_589243(
    name: "proximitybeaconBeaconsActivate", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}:activate",
    validator: validate_ProximitybeaconBeaconsActivate_589244, base: "/",
    url: url_ProximitybeaconBeaconsActivate_589245, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsDeactivate_589263 = ref object of OpenApiRestCall_588441
proc url_ProximitybeaconBeaconsDeactivate_589265(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: ":deactivate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsDeactivate_589264(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deactivates a beacon. Once deactivated, the API will not return
  ## information nor attachment data for the beacon when queried via
  ## `beaconinfo.getforobserved`. Calling this method on an already inactive
  ## beacon will do nothing (but will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon that should be deactivated. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_589266 = path.getOrDefault("beaconName")
  valid_589266 = validateParameter(valid_589266, JString, required = true,
                                 default = nil)
  if valid_589266 != nil:
    section.add "beaconName", valid_589266
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the beacon to deactivate. If the project id is not
  ## specified then the project making the request is used. The project id must
  ## match the project that owns the beacon.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589267 = query.getOrDefault("upload_protocol")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "upload_protocol", valid_589267
  var valid_589268 = query.getOrDefault("fields")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "fields", valid_589268
  var valid_589269 = query.getOrDefault("quotaUser")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "quotaUser", valid_589269
  var valid_589270 = query.getOrDefault("alt")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = newJString("json"))
  if valid_589270 != nil:
    section.add "alt", valid_589270
  var valid_589271 = query.getOrDefault("oauth_token")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "oauth_token", valid_589271
  var valid_589272 = query.getOrDefault("callback")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "callback", valid_589272
  var valid_589273 = query.getOrDefault("access_token")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "access_token", valid_589273
  var valid_589274 = query.getOrDefault("uploadType")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "uploadType", valid_589274
  var valid_589275 = query.getOrDefault("key")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "key", valid_589275
  var valid_589276 = query.getOrDefault("$.xgafv")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = newJString("1"))
  if valid_589276 != nil:
    section.add "$.xgafv", valid_589276
  var valid_589277 = query.getOrDefault("projectId")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "projectId", valid_589277
  var valid_589278 = query.getOrDefault("prettyPrint")
  valid_589278 = validateParameter(valid_589278, JBool, required = false,
                                 default = newJBool(true))
  if valid_589278 != nil:
    section.add "prettyPrint", valid_589278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589279: Call_ProximitybeaconBeaconsDeactivate_589263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deactivates a beacon. Once deactivated, the API will not return
  ## information nor attachment data for the beacon when queried via
  ## `beaconinfo.getforobserved`. Calling this method on an already inactive
  ## beacon will do nothing (but will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_589279.validator(path, query, header, formData, body)
  let scheme = call_589279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589279.url(scheme.get, call_589279.host, call_589279.base,
                         call_589279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589279, url, valid)

proc call*(call_589280: Call_ProximitybeaconBeaconsDeactivate_589263;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsDeactivate
  ## Deactivates a beacon. Once deactivated, the API will not return
  ## information nor attachment data for the beacon when queried via
  ## `beaconinfo.getforobserved`. Calling this method on an already inactive
  ## beacon will do nothing (but will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the beacon to deactivate. If the project id is not
  ## specified then the project making the request is used. The project id must
  ## match the project that owns the beacon.
  ## Optional.
  ##   beaconName: string (required)
  ##             : Beacon that should be deactivated. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589281 = newJObject()
  var query_589282 = newJObject()
  add(query_589282, "upload_protocol", newJString(uploadProtocol))
  add(query_589282, "fields", newJString(fields))
  add(query_589282, "quotaUser", newJString(quotaUser))
  add(query_589282, "alt", newJString(alt))
  add(query_589282, "oauth_token", newJString(oauthToken))
  add(query_589282, "callback", newJString(callback))
  add(query_589282, "access_token", newJString(accessToken))
  add(query_589282, "uploadType", newJString(uploadType))
  add(query_589282, "key", newJString(key))
  add(query_589282, "$.xgafv", newJString(Xgafv))
  add(query_589282, "projectId", newJString(projectId))
  add(path_589281, "beaconName", newJString(beaconName))
  add(query_589282, "prettyPrint", newJBool(prettyPrint))
  result = call_589280.call(path_589281, query_589282, nil, nil, nil)

var proximitybeaconBeaconsDeactivate* = Call_ProximitybeaconBeaconsDeactivate_589263(
    name: "proximitybeaconBeaconsDeactivate", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}:deactivate",
    validator: validate_ProximitybeaconBeaconsDeactivate_589264, base: "/",
    url: url_ProximitybeaconBeaconsDeactivate_589265, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsDecommission_589283 = ref object of OpenApiRestCall_588441
proc url_ProximitybeaconBeaconsDecommission_589285(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: ":decommission")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsDecommission_589284(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Decommissions the specified beacon in the service. This beacon will no
  ## longer be returned from `beaconinfo.getforobserved`. This operation is
  ## permanent -- you will not be able to re-register a beacon with this ID
  ## again.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon that should be decommissioned. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID of the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_589286 = path.getOrDefault("beaconName")
  valid_589286 = validateParameter(valid_589286, JString, required = true,
                                 default = nil)
  if valid_589286 != nil:
    section.add "beaconName", valid_589286
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the beacon to decommission. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589287 = query.getOrDefault("upload_protocol")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "upload_protocol", valid_589287
  var valid_589288 = query.getOrDefault("fields")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "fields", valid_589288
  var valid_589289 = query.getOrDefault("quotaUser")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "quotaUser", valid_589289
  var valid_589290 = query.getOrDefault("alt")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = newJString("json"))
  if valid_589290 != nil:
    section.add "alt", valid_589290
  var valid_589291 = query.getOrDefault("oauth_token")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "oauth_token", valid_589291
  var valid_589292 = query.getOrDefault("callback")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "callback", valid_589292
  var valid_589293 = query.getOrDefault("access_token")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "access_token", valid_589293
  var valid_589294 = query.getOrDefault("uploadType")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "uploadType", valid_589294
  var valid_589295 = query.getOrDefault("key")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "key", valid_589295
  var valid_589296 = query.getOrDefault("$.xgafv")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = newJString("1"))
  if valid_589296 != nil:
    section.add "$.xgafv", valid_589296
  var valid_589297 = query.getOrDefault("projectId")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "projectId", valid_589297
  var valid_589298 = query.getOrDefault("prettyPrint")
  valid_589298 = validateParameter(valid_589298, JBool, required = false,
                                 default = newJBool(true))
  if valid_589298 != nil:
    section.add "prettyPrint", valid_589298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589299: Call_ProximitybeaconBeaconsDecommission_589283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Decommissions the specified beacon in the service. This beacon will no
  ## longer be returned from `beaconinfo.getforobserved`. This operation is
  ## permanent -- you will not be able to re-register a beacon with this ID
  ## again.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_589299.validator(path, query, header, formData, body)
  let scheme = call_589299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589299.url(scheme.get, call_589299.host, call_589299.base,
                         call_589299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589299, url, valid)

proc call*(call_589300: Call_ProximitybeaconBeaconsDecommission_589283;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsDecommission
  ## Decommissions the specified beacon in the service. This beacon will no
  ## longer be returned from `beaconinfo.getforobserved`. This operation is
  ## permanent -- you will not be able to re-register a beacon with this ID
  ## again.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the beacon to decommission. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  ##   beaconName: string (required)
  ##             : Beacon that should be decommissioned. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID of the beacon's "stable" UID.
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589301 = newJObject()
  var query_589302 = newJObject()
  add(query_589302, "upload_protocol", newJString(uploadProtocol))
  add(query_589302, "fields", newJString(fields))
  add(query_589302, "quotaUser", newJString(quotaUser))
  add(query_589302, "alt", newJString(alt))
  add(query_589302, "oauth_token", newJString(oauthToken))
  add(query_589302, "callback", newJString(callback))
  add(query_589302, "access_token", newJString(accessToken))
  add(query_589302, "uploadType", newJString(uploadType))
  add(query_589302, "key", newJString(key))
  add(query_589302, "$.xgafv", newJString(Xgafv))
  add(query_589302, "projectId", newJString(projectId))
  add(path_589301, "beaconName", newJString(beaconName))
  add(query_589302, "prettyPrint", newJBool(prettyPrint))
  result = call_589300.call(path_589301, query_589302, nil, nil, nil)

var proximitybeaconBeaconsDecommission* = Call_ProximitybeaconBeaconsDecommission_589283(
    name: "proximitybeaconBeaconsDecommission", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}:decommission",
    validator: validate_ProximitybeaconBeaconsDecommission_589284, base: "/",
    url: url_ProximitybeaconBeaconsDecommission_589285, schemes: {Scheme.Https})
type
  Call_ProximitybeaconNamespacesUpdate_589303 = ref object of OpenApiRestCall_588441
proc url_ProximitybeaconNamespacesUpdate_589305(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconNamespacesUpdate_589304(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the information about the specified namespace. Only the namespace
  ## visibility can be updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : Resource name of this namespace. Namespaces names have the format:
  ## <code>namespaces/<var>namespace</var></code>.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_589306 = path.getOrDefault("namespaceName")
  valid_589306 = validateParameter(valid_589306, JString, required = true,
                                 default = nil)
  if valid_589306 != nil:
    section.add "namespaceName", valid_589306
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the namespace to update. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589307 = query.getOrDefault("upload_protocol")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "upload_protocol", valid_589307
  var valid_589308 = query.getOrDefault("fields")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "fields", valid_589308
  var valid_589309 = query.getOrDefault("quotaUser")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "quotaUser", valid_589309
  var valid_589310 = query.getOrDefault("alt")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = newJString("json"))
  if valid_589310 != nil:
    section.add "alt", valid_589310
  var valid_589311 = query.getOrDefault("oauth_token")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "oauth_token", valid_589311
  var valid_589312 = query.getOrDefault("callback")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "callback", valid_589312
  var valid_589313 = query.getOrDefault("access_token")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "access_token", valid_589313
  var valid_589314 = query.getOrDefault("uploadType")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "uploadType", valid_589314
  var valid_589315 = query.getOrDefault("key")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "key", valid_589315
  var valid_589316 = query.getOrDefault("$.xgafv")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = newJString("1"))
  if valid_589316 != nil:
    section.add "$.xgafv", valid_589316
  var valid_589317 = query.getOrDefault("projectId")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "projectId", valid_589317
  var valid_589318 = query.getOrDefault("prettyPrint")
  valid_589318 = validateParameter(valid_589318, JBool, required = false,
                                 default = newJBool(true))
  if valid_589318 != nil:
    section.add "prettyPrint", valid_589318
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

proc call*(call_589320: Call_ProximitybeaconNamespacesUpdate_589303;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the information about the specified namespace. Only the namespace
  ## visibility can be updated.
  ## 
  let valid = call_589320.validator(path, query, header, formData, body)
  let scheme = call_589320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589320.url(scheme.get, call_589320.host, call_589320.base,
                         call_589320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589320, url, valid)

proc call*(call_589321: Call_ProximitybeaconNamespacesUpdate_589303;
          namespaceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## proximitybeaconNamespacesUpdate
  ## Updates the information about the specified namespace. Only the namespace
  ## visibility can be updated.
  ##   namespaceName: string (required)
  ##                : Resource name of this namespace. Namespaces names have the format:
  ## <code>namespaces/<var>namespace</var></code>.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the namespace to update. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589322 = newJObject()
  var query_589323 = newJObject()
  var body_589324 = newJObject()
  add(path_589322, "namespaceName", newJString(namespaceName))
  add(query_589323, "upload_protocol", newJString(uploadProtocol))
  add(query_589323, "fields", newJString(fields))
  add(query_589323, "quotaUser", newJString(quotaUser))
  add(query_589323, "alt", newJString(alt))
  add(query_589323, "oauth_token", newJString(oauthToken))
  add(query_589323, "callback", newJString(callback))
  add(query_589323, "access_token", newJString(accessToken))
  add(query_589323, "uploadType", newJString(uploadType))
  add(query_589323, "key", newJString(key))
  add(query_589323, "$.xgafv", newJString(Xgafv))
  add(query_589323, "projectId", newJString(projectId))
  if body != nil:
    body_589324 = body
  add(query_589323, "prettyPrint", newJBool(prettyPrint))
  result = call_589321.call(path_589322, query_589323, nil, nil, body_589324)

var proximitybeaconNamespacesUpdate* = Call_ProximitybeaconNamespacesUpdate_589303(
    name: "proximitybeaconNamespacesUpdate", meth: HttpMethod.HttpPut,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{namespaceName}",
    validator: validate_ProximitybeaconNamespacesUpdate_589304, base: "/",
    url: url_ProximitybeaconNamespacesUpdate_589305, schemes: {Scheme.Https})
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
