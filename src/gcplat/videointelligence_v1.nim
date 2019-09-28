
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Video Intelligence
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Detects objects, explicit content, and scene changes in videos. It also specifies the region for annotation and transcribes speech to text. Supports both asynchronous API and streaming API.
## 
## https://cloud.google.com/video-intelligence/docs/
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  gcpServiceName = "videointelligence"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VideointelligenceOperationsProjectsLocationsOperationsGet_579690 = ref object of OpenApiRestCall_579421
proc url_VideointelligenceOperationsProjectsLocationsOperationsGet_579692(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/operations/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VideointelligenceOperationsProjectsLocationsOperationsGet_579691(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579818 = path.getOrDefault("name")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "name", valid_579818
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
  var valid_579819 = query.getOrDefault("upload_protocol")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "upload_protocol", valid_579819
  var valid_579820 = query.getOrDefault("fields")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "fields", valid_579820
  var valid_579821 = query.getOrDefault("quotaUser")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "quotaUser", valid_579821
  var valid_579835 = query.getOrDefault("alt")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = newJString("json"))
  if valid_579835 != nil:
    section.add "alt", valid_579835
  var valid_579836 = query.getOrDefault("oauth_token")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "oauth_token", valid_579836
  var valid_579837 = query.getOrDefault("callback")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "callback", valid_579837
  var valid_579838 = query.getOrDefault("access_token")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "access_token", valid_579838
  var valid_579839 = query.getOrDefault("uploadType")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "uploadType", valid_579839
  var valid_579840 = query.getOrDefault("key")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "key", valid_579840
  var valid_579841 = query.getOrDefault("$.xgafv")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = newJString("1"))
  if valid_579841 != nil:
    section.add "$.xgafv", valid_579841
  var valid_579842 = query.getOrDefault("prettyPrint")
  valid_579842 = validateParameter(valid_579842, JBool, required = false,
                                 default = newJBool(true))
  if valid_579842 != nil:
    section.add "prettyPrint", valid_579842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579865: Call_VideointelligenceOperationsProjectsLocationsOperationsGet_579690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_579865.validator(path, query, header, formData, body)
  let scheme = call_579865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579865.url(scheme.get, call_579865.host, call_579865.base,
                         call_579865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579865, url, valid)

proc call*(call_579936: Call_VideointelligenceOperationsProjectsLocationsOperationsGet_579690;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## videointelligenceOperationsProjectsLocationsOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
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
  var path_579937 = newJObject()
  var query_579939 = newJObject()
  add(query_579939, "upload_protocol", newJString(uploadProtocol))
  add(query_579939, "fields", newJString(fields))
  add(query_579939, "quotaUser", newJString(quotaUser))
  add(path_579937, "name", newJString(name))
  add(query_579939, "alt", newJString(alt))
  add(query_579939, "oauth_token", newJString(oauthToken))
  add(query_579939, "callback", newJString(callback))
  add(query_579939, "access_token", newJString(accessToken))
  add(query_579939, "uploadType", newJString(uploadType))
  add(query_579939, "key", newJString(key))
  add(query_579939, "$.xgafv", newJString(Xgafv))
  add(query_579939, "prettyPrint", newJBool(prettyPrint))
  result = call_579936.call(path_579937, query_579939, nil, nil, nil)

var videointelligenceOperationsProjectsLocationsOperationsGet* = Call_VideointelligenceOperationsProjectsLocationsOperationsGet_579690(
    name: "videointelligenceOperationsProjectsLocationsOperationsGet",
    meth: HttpMethod.HttpGet, host: "videointelligence.googleapis.com",
    route: "/v1/operations/{name}", validator: validate_VideointelligenceOperationsProjectsLocationsOperationsGet_579691,
    base: "/", url: url_VideointelligenceOperationsProjectsLocationsOperationsGet_579692,
    schemes: {Scheme.Https})
type
  Call_VideointelligenceOperationsProjectsLocationsOperationsDelete_579978 = ref object of OpenApiRestCall_579421
proc url_VideointelligenceOperationsProjectsLocationsOperationsDelete_579980(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/operations/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VideointelligenceOperationsProjectsLocationsOperationsDelete_579979(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579981 = path.getOrDefault("name")
  valid_579981 = validateParameter(valid_579981, JString, required = true,
                                 default = nil)
  if valid_579981 != nil:
    section.add "name", valid_579981
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
  var valid_579982 = query.getOrDefault("upload_protocol")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "upload_protocol", valid_579982
  var valid_579983 = query.getOrDefault("fields")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "fields", valid_579983
  var valid_579984 = query.getOrDefault("quotaUser")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "quotaUser", valid_579984
  var valid_579985 = query.getOrDefault("alt")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("json"))
  if valid_579985 != nil:
    section.add "alt", valid_579985
  var valid_579986 = query.getOrDefault("oauth_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "oauth_token", valid_579986
  var valid_579987 = query.getOrDefault("callback")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "callback", valid_579987
  var valid_579988 = query.getOrDefault("access_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "access_token", valid_579988
  var valid_579989 = query.getOrDefault("uploadType")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "uploadType", valid_579989
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("$.xgafv")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("1"))
  if valid_579991 != nil:
    section.add "$.xgafv", valid_579991
  var valid_579992 = query.getOrDefault("prettyPrint")
  valid_579992 = validateParameter(valid_579992, JBool, required = false,
                                 default = newJBool(true))
  if valid_579992 != nil:
    section.add "prettyPrint", valid_579992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579993: Call_VideointelligenceOperationsProjectsLocationsOperationsDelete_579978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_579993.validator(path, query, header, formData, body)
  let scheme = call_579993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579993.url(scheme.get, call_579993.host, call_579993.base,
                         call_579993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579993, url, valid)

proc call*(call_579994: Call_VideointelligenceOperationsProjectsLocationsOperationsDelete_579978;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## videointelligenceOperationsProjectsLocationsOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
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
  var path_579995 = newJObject()
  var query_579996 = newJObject()
  add(query_579996, "upload_protocol", newJString(uploadProtocol))
  add(query_579996, "fields", newJString(fields))
  add(query_579996, "quotaUser", newJString(quotaUser))
  add(path_579995, "name", newJString(name))
  add(query_579996, "alt", newJString(alt))
  add(query_579996, "oauth_token", newJString(oauthToken))
  add(query_579996, "callback", newJString(callback))
  add(query_579996, "access_token", newJString(accessToken))
  add(query_579996, "uploadType", newJString(uploadType))
  add(query_579996, "key", newJString(key))
  add(query_579996, "$.xgafv", newJString(Xgafv))
  add(query_579996, "prettyPrint", newJBool(prettyPrint))
  result = call_579994.call(path_579995, query_579996, nil, nil, nil)

var videointelligenceOperationsProjectsLocationsOperationsDelete* = Call_VideointelligenceOperationsProjectsLocationsOperationsDelete_579978(
    name: "videointelligenceOperationsProjectsLocationsOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "videointelligence.googleapis.com",
    route: "/v1/operations/{name}", validator: validate_VideointelligenceOperationsProjectsLocationsOperationsDelete_579979,
    base: "/",
    url: url_VideointelligenceOperationsProjectsLocationsOperationsDelete_579980,
    schemes: {Scheme.Https})
type
  Call_VideointelligenceOperationsProjectsLocationsOperationsCancel_579997 = ref object of OpenApiRestCall_579421
proc url_VideointelligenceOperationsProjectsLocationsOperationsCancel_579999(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/operations/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VideointelligenceOperationsProjectsLocationsOperationsCancel_579998(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580000 = path.getOrDefault("name")
  valid_580000 = validateParameter(valid_580000, JString, required = true,
                                 default = nil)
  if valid_580000 != nil:
    section.add "name", valid_580000
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
  var valid_580001 = query.getOrDefault("upload_protocol")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "upload_protocol", valid_580001
  var valid_580002 = query.getOrDefault("fields")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "fields", valid_580002
  var valid_580003 = query.getOrDefault("quotaUser")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "quotaUser", valid_580003
  var valid_580004 = query.getOrDefault("alt")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("json"))
  if valid_580004 != nil:
    section.add "alt", valid_580004
  var valid_580005 = query.getOrDefault("oauth_token")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "oauth_token", valid_580005
  var valid_580006 = query.getOrDefault("callback")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "callback", valid_580006
  var valid_580007 = query.getOrDefault("access_token")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "access_token", valid_580007
  var valid_580008 = query.getOrDefault("uploadType")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "uploadType", valid_580008
  var valid_580009 = query.getOrDefault("key")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "key", valid_580009
  var valid_580010 = query.getOrDefault("$.xgafv")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = newJString("1"))
  if valid_580010 != nil:
    section.add "$.xgafv", valid_580010
  var valid_580011 = query.getOrDefault("prettyPrint")
  valid_580011 = validateParameter(valid_580011, JBool, required = false,
                                 default = newJBool(true))
  if valid_580011 != nil:
    section.add "prettyPrint", valid_580011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580012: Call_VideointelligenceOperationsProjectsLocationsOperationsCancel_579997;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  let valid = call_580012.validator(path, query, header, formData, body)
  let scheme = call_580012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580012.url(scheme.get, call_580012.host, call_580012.base,
                         call_580012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580012, url, valid)

proc call*(call_580013: Call_VideointelligenceOperationsProjectsLocationsOperationsCancel_579997;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## videointelligenceOperationsProjectsLocationsOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
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
  var path_580014 = newJObject()
  var query_580015 = newJObject()
  add(query_580015, "upload_protocol", newJString(uploadProtocol))
  add(query_580015, "fields", newJString(fields))
  add(query_580015, "quotaUser", newJString(quotaUser))
  add(path_580014, "name", newJString(name))
  add(query_580015, "alt", newJString(alt))
  add(query_580015, "oauth_token", newJString(oauthToken))
  add(query_580015, "callback", newJString(callback))
  add(query_580015, "access_token", newJString(accessToken))
  add(query_580015, "uploadType", newJString(uploadType))
  add(query_580015, "key", newJString(key))
  add(query_580015, "$.xgafv", newJString(Xgafv))
  add(query_580015, "prettyPrint", newJBool(prettyPrint))
  result = call_580013.call(path_580014, query_580015, nil, nil, nil)

var videointelligenceOperationsProjectsLocationsOperationsCancel* = Call_VideointelligenceOperationsProjectsLocationsOperationsCancel_579997(
    name: "videointelligenceOperationsProjectsLocationsOperationsCancel",
    meth: HttpMethod.HttpPost, host: "videointelligence.googleapis.com",
    route: "/v1/operations/{name}:cancel", validator: validate_VideointelligenceOperationsProjectsLocationsOperationsCancel_579998,
    base: "/",
    url: url_VideointelligenceOperationsProjectsLocationsOperationsCancel_579999,
    schemes: {Scheme.Https})
type
  Call_VideointelligenceVideosAnnotate_580016 = ref object of OpenApiRestCall_579421
proc url_VideointelligenceVideosAnnotate_580018(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VideointelligenceVideosAnnotate_580017(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Performs asynchronous video annotation. Progress and results can be
  ## retrieved through the `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `AnnotateVideoProgress` (progress).
  ## `Operation.response` contains `AnnotateVideoResponse` (results).
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
  var valid_580019 = query.getOrDefault("upload_protocol")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "upload_protocol", valid_580019
  var valid_580020 = query.getOrDefault("fields")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "fields", valid_580020
  var valid_580021 = query.getOrDefault("quotaUser")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "quotaUser", valid_580021
  var valid_580022 = query.getOrDefault("alt")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = newJString("json"))
  if valid_580022 != nil:
    section.add "alt", valid_580022
  var valid_580023 = query.getOrDefault("oauth_token")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "oauth_token", valid_580023
  var valid_580024 = query.getOrDefault("callback")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "callback", valid_580024
  var valid_580025 = query.getOrDefault("access_token")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "access_token", valid_580025
  var valid_580026 = query.getOrDefault("uploadType")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "uploadType", valid_580026
  var valid_580027 = query.getOrDefault("key")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "key", valid_580027
  var valid_580028 = query.getOrDefault("$.xgafv")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = newJString("1"))
  if valid_580028 != nil:
    section.add "$.xgafv", valid_580028
  var valid_580029 = query.getOrDefault("prettyPrint")
  valid_580029 = validateParameter(valid_580029, JBool, required = false,
                                 default = newJBool(true))
  if valid_580029 != nil:
    section.add "prettyPrint", valid_580029
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

proc call*(call_580031: Call_VideointelligenceVideosAnnotate_580016;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Performs asynchronous video annotation. Progress and results can be
  ## retrieved through the `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `AnnotateVideoProgress` (progress).
  ## `Operation.response` contains `AnnotateVideoResponse` (results).
  ## 
  let valid = call_580031.validator(path, query, header, formData, body)
  let scheme = call_580031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580031.url(scheme.get, call_580031.host, call_580031.base,
                         call_580031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580031, url, valid)

proc call*(call_580032: Call_VideointelligenceVideosAnnotate_580016;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## videointelligenceVideosAnnotate
  ## Performs asynchronous video annotation. Progress and results can be
  ## retrieved through the `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `AnnotateVideoProgress` (progress).
  ## `Operation.response` contains `AnnotateVideoResponse` (results).
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
  var query_580033 = newJObject()
  var body_580034 = newJObject()
  add(query_580033, "upload_protocol", newJString(uploadProtocol))
  add(query_580033, "fields", newJString(fields))
  add(query_580033, "quotaUser", newJString(quotaUser))
  add(query_580033, "alt", newJString(alt))
  add(query_580033, "oauth_token", newJString(oauthToken))
  add(query_580033, "callback", newJString(callback))
  add(query_580033, "access_token", newJString(accessToken))
  add(query_580033, "uploadType", newJString(uploadType))
  add(query_580033, "key", newJString(key))
  add(query_580033, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580034 = body
  add(query_580033, "prettyPrint", newJBool(prettyPrint))
  result = call_580032.call(nil, query_580033, nil, nil, body_580034)

var videointelligenceVideosAnnotate* = Call_VideointelligenceVideosAnnotate_580016(
    name: "videointelligenceVideosAnnotate", meth: HttpMethod.HttpPost,
    host: "videointelligence.googleapis.com", route: "/v1/videos:annotate",
    validator: validate_VideointelligenceVideosAnnotate_580017, base: "/",
    url: url_VideointelligenceVideosAnnotate_580018, schemes: {Scheme.Https})
type
  Call_VideointelligenceProjectsLocationsOperationsGet_580035 = ref object of OpenApiRestCall_579421
proc url_VideointelligenceProjectsLocationsOperationsGet_580037(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VideointelligenceProjectsLocationsOperationsGet_580036(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580038 = path.getOrDefault("name")
  valid_580038 = validateParameter(valid_580038, JString, required = true,
                                 default = nil)
  if valid_580038 != nil:
    section.add "name", valid_580038
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
  var valid_580039 = query.getOrDefault("upload_protocol")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "upload_protocol", valid_580039
  var valid_580040 = query.getOrDefault("fields")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "fields", valid_580040
  var valid_580041 = query.getOrDefault("quotaUser")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "quotaUser", valid_580041
  var valid_580042 = query.getOrDefault("alt")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("json"))
  if valid_580042 != nil:
    section.add "alt", valid_580042
  var valid_580043 = query.getOrDefault("oauth_token")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "oauth_token", valid_580043
  var valid_580044 = query.getOrDefault("callback")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "callback", valid_580044
  var valid_580045 = query.getOrDefault("access_token")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "access_token", valid_580045
  var valid_580046 = query.getOrDefault("uploadType")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "uploadType", valid_580046
  var valid_580047 = query.getOrDefault("key")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "key", valid_580047
  var valid_580048 = query.getOrDefault("$.xgafv")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = newJString("1"))
  if valid_580048 != nil:
    section.add "$.xgafv", valid_580048
  var valid_580049 = query.getOrDefault("prettyPrint")
  valid_580049 = validateParameter(valid_580049, JBool, required = false,
                                 default = newJBool(true))
  if valid_580049 != nil:
    section.add "prettyPrint", valid_580049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580050: Call_VideointelligenceProjectsLocationsOperationsGet_580035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_580050.validator(path, query, header, formData, body)
  let scheme = call_580050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580050.url(scheme.get, call_580050.host, call_580050.base,
                         call_580050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580050, url, valid)

proc call*(call_580051: Call_VideointelligenceProjectsLocationsOperationsGet_580035;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## videointelligenceProjectsLocationsOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
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
  var path_580052 = newJObject()
  var query_580053 = newJObject()
  add(query_580053, "upload_protocol", newJString(uploadProtocol))
  add(query_580053, "fields", newJString(fields))
  add(query_580053, "quotaUser", newJString(quotaUser))
  add(path_580052, "name", newJString(name))
  add(query_580053, "alt", newJString(alt))
  add(query_580053, "oauth_token", newJString(oauthToken))
  add(query_580053, "callback", newJString(callback))
  add(query_580053, "access_token", newJString(accessToken))
  add(query_580053, "uploadType", newJString(uploadType))
  add(query_580053, "key", newJString(key))
  add(query_580053, "$.xgafv", newJString(Xgafv))
  add(query_580053, "prettyPrint", newJBool(prettyPrint))
  result = call_580051.call(path_580052, query_580053, nil, nil, nil)

var videointelligenceProjectsLocationsOperationsGet* = Call_VideointelligenceProjectsLocationsOperationsGet_580035(
    name: "videointelligenceProjectsLocationsOperationsGet",
    meth: HttpMethod.HttpGet, host: "videointelligence.googleapis.com",
    route: "/v1/{name}",
    validator: validate_VideointelligenceProjectsLocationsOperationsGet_580036,
    base: "/", url: url_VideointelligenceProjectsLocationsOperationsGet_580037,
    schemes: {Scheme.Https})
type
  Call_VideointelligenceProjectsLocationsOperationsDelete_580054 = ref object of OpenApiRestCall_579421
proc url_VideointelligenceProjectsLocationsOperationsDelete_580056(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VideointelligenceProjectsLocationsOperationsDelete_580055(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580057 = path.getOrDefault("name")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "name", valid_580057
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
  var valid_580058 = query.getOrDefault("upload_protocol")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "upload_protocol", valid_580058
  var valid_580059 = query.getOrDefault("fields")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "fields", valid_580059
  var valid_580060 = query.getOrDefault("quotaUser")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "quotaUser", valid_580060
  var valid_580061 = query.getOrDefault("alt")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = newJString("json"))
  if valid_580061 != nil:
    section.add "alt", valid_580061
  var valid_580062 = query.getOrDefault("oauth_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "oauth_token", valid_580062
  var valid_580063 = query.getOrDefault("callback")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "callback", valid_580063
  var valid_580064 = query.getOrDefault("access_token")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "access_token", valid_580064
  var valid_580065 = query.getOrDefault("uploadType")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "uploadType", valid_580065
  var valid_580066 = query.getOrDefault("key")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "key", valid_580066
  var valid_580067 = query.getOrDefault("$.xgafv")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = newJString("1"))
  if valid_580067 != nil:
    section.add "$.xgafv", valid_580067
  var valid_580068 = query.getOrDefault("prettyPrint")
  valid_580068 = validateParameter(valid_580068, JBool, required = false,
                                 default = newJBool(true))
  if valid_580068 != nil:
    section.add "prettyPrint", valid_580068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580069: Call_VideointelligenceProjectsLocationsOperationsDelete_580054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_580069.validator(path, query, header, formData, body)
  let scheme = call_580069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580069.url(scheme.get, call_580069.host, call_580069.base,
                         call_580069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580069, url, valid)

proc call*(call_580070: Call_VideointelligenceProjectsLocationsOperationsDelete_580054;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## videointelligenceProjectsLocationsOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
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
  var path_580071 = newJObject()
  var query_580072 = newJObject()
  add(query_580072, "upload_protocol", newJString(uploadProtocol))
  add(query_580072, "fields", newJString(fields))
  add(query_580072, "quotaUser", newJString(quotaUser))
  add(path_580071, "name", newJString(name))
  add(query_580072, "alt", newJString(alt))
  add(query_580072, "oauth_token", newJString(oauthToken))
  add(query_580072, "callback", newJString(callback))
  add(query_580072, "access_token", newJString(accessToken))
  add(query_580072, "uploadType", newJString(uploadType))
  add(query_580072, "key", newJString(key))
  add(query_580072, "$.xgafv", newJString(Xgafv))
  add(query_580072, "prettyPrint", newJBool(prettyPrint))
  result = call_580070.call(path_580071, query_580072, nil, nil, nil)

var videointelligenceProjectsLocationsOperationsDelete* = Call_VideointelligenceProjectsLocationsOperationsDelete_580054(
    name: "videointelligenceProjectsLocationsOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "videointelligence.googleapis.com",
    route: "/v1/{name}",
    validator: validate_VideointelligenceProjectsLocationsOperationsDelete_580055,
    base: "/", url: url_VideointelligenceProjectsLocationsOperationsDelete_580056,
    schemes: {Scheme.Https})
type
  Call_VideointelligenceProjectsLocationsOperationsList_580073 = ref object of OpenApiRestCall_579421
proc url_VideointelligenceProjectsLocationsOperationsList_580075(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VideointelligenceProjectsLocationsOperationsList_580074(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation's parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580076 = path.getOrDefault("name")
  valid_580076 = validateParameter(valid_580076, JString, required = true,
                                 default = nil)
  if valid_580076 != nil:
    section.add "name", valid_580076
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
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
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_580077 = query.getOrDefault("upload_protocol")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "upload_protocol", valid_580077
  var valid_580078 = query.getOrDefault("fields")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "fields", valid_580078
  var valid_580079 = query.getOrDefault("pageToken")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "pageToken", valid_580079
  var valid_580080 = query.getOrDefault("quotaUser")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "quotaUser", valid_580080
  var valid_580081 = query.getOrDefault("alt")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = newJString("json"))
  if valid_580081 != nil:
    section.add "alt", valid_580081
  var valid_580082 = query.getOrDefault("oauth_token")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "oauth_token", valid_580082
  var valid_580083 = query.getOrDefault("callback")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "callback", valid_580083
  var valid_580084 = query.getOrDefault("access_token")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "access_token", valid_580084
  var valid_580085 = query.getOrDefault("uploadType")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "uploadType", valid_580085
  var valid_580086 = query.getOrDefault("key")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "key", valid_580086
  var valid_580087 = query.getOrDefault("$.xgafv")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = newJString("1"))
  if valid_580087 != nil:
    section.add "$.xgafv", valid_580087
  var valid_580088 = query.getOrDefault("pageSize")
  valid_580088 = validateParameter(valid_580088, JInt, required = false, default = nil)
  if valid_580088 != nil:
    section.add "pageSize", valid_580088
  var valid_580089 = query.getOrDefault("prettyPrint")
  valid_580089 = validateParameter(valid_580089, JBool, required = false,
                                 default = newJBool(true))
  if valid_580089 != nil:
    section.add "prettyPrint", valid_580089
  var valid_580090 = query.getOrDefault("filter")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "filter", valid_580090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580091: Call_VideointelligenceProjectsLocationsOperationsList_580073;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  let valid = call_580091.validator(path, query, header, formData, body)
  let scheme = call_580091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580091.url(scheme.get, call_580091.host, call_580091.base,
                         call_580091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580091, url, valid)

proc call*(call_580092: Call_VideointelligenceProjectsLocationsOperationsList_580073;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## videointelligenceProjectsLocationsOperationsList
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation's parent resource.
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
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_580093 = newJObject()
  var query_580094 = newJObject()
  add(query_580094, "upload_protocol", newJString(uploadProtocol))
  add(query_580094, "fields", newJString(fields))
  add(query_580094, "pageToken", newJString(pageToken))
  add(query_580094, "quotaUser", newJString(quotaUser))
  add(path_580093, "name", newJString(name))
  add(query_580094, "alt", newJString(alt))
  add(query_580094, "oauth_token", newJString(oauthToken))
  add(query_580094, "callback", newJString(callback))
  add(query_580094, "access_token", newJString(accessToken))
  add(query_580094, "uploadType", newJString(uploadType))
  add(query_580094, "key", newJString(key))
  add(query_580094, "$.xgafv", newJString(Xgafv))
  add(query_580094, "pageSize", newJInt(pageSize))
  add(query_580094, "prettyPrint", newJBool(prettyPrint))
  add(query_580094, "filter", newJString(filter))
  result = call_580092.call(path_580093, query_580094, nil, nil, nil)

var videointelligenceProjectsLocationsOperationsList* = Call_VideointelligenceProjectsLocationsOperationsList_580073(
    name: "videointelligenceProjectsLocationsOperationsList",
    meth: HttpMethod.HttpGet, host: "videointelligence.googleapis.com",
    route: "/v1/{name}/operations",
    validator: validate_VideointelligenceProjectsLocationsOperationsList_580074,
    base: "/", url: url_VideointelligenceProjectsLocationsOperationsList_580075,
    schemes: {Scheme.Https})
type
  Call_VideointelligenceProjectsLocationsOperationsCancel_580095 = ref object of OpenApiRestCall_579421
proc url_VideointelligenceProjectsLocationsOperationsCancel_580097(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VideointelligenceProjectsLocationsOperationsCancel_580096(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580098 = path.getOrDefault("name")
  valid_580098 = validateParameter(valid_580098, JString, required = true,
                                 default = nil)
  if valid_580098 != nil:
    section.add "name", valid_580098
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
  var valid_580099 = query.getOrDefault("upload_protocol")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "upload_protocol", valid_580099
  var valid_580100 = query.getOrDefault("fields")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "fields", valid_580100
  var valid_580101 = query.getOrDefault("quotaUser")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "quotaUser", valid_580101
  var valid_580102 = query.getOrDefault("alt")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = newJString("json"))
  if valid_580102 != nil:
    section.add "alt", valid_580102
  var valid_580103 = query.getOrDefault("oauth_token")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "oauth_token", valid_580103
  var valid_580104 = query.getOrDefault("callback")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "callback", valid_580104
  var valid_580105 = query.getOrDefault("access_token")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "access_token", valid_580105
  var valid_580106 = query.getOrDefault("uploadType")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "uploadType", valid_580106
  var valid_580107 = query.getOrDefault("key")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "key", valid_580107
  var valid_580108 = query.getOrDefault("$.xgafv")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = newJString("1"))
  if valid_580108 != nil:
    section.add "$.xgafv", valid_580108
  var valid_580109 = query.getOrDefault("prettyPrint")
  valid_580109 = validateParameter(valid_580109, JBool, required = false,
                                 default = newJBool(true))
  if valid_580109 != nil:
    section.add "prettyPrint", valid_580109
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

proc call*(call_580111: Call_VideointelligenceProjectsLocationsOperationsCancel_580095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  let valid = call_580111.validator(path, query, header, formData, body)
  let scheme = call_580111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580111.url(scheme.get, call_580111.host, call_580111.base,
                         call_580111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580111, url, valid)

proc call*(call_580112: Call_VideointelligenceProjectsLocationsOperationsCancel_580095;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## videointelligenceProjectsLocationsOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
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
  var path_580113 = newJObject()
  var query_580114 = newJObject()
  var body_580115 = newJObject()
  add(query_580114, "upload_protocol", newJString(uploadProtocol))
  add(query_580114, "fields", newJString(fields))
  add(query_580114, "quotaUser", newJString(quotaUser))
  add(path_580113, "name", newJString(name))
  add(query_580114, "alt", newJString(alt))
  add(query_580114, "oauth_token", newJString(oauthToken))
  add(query_580114, "callback", newJString(callback))
  add(query_580114, "access_token", newJString(accessToken))
  add(query_580114, "uploadType", newJString(uploadType))
  add(query_580114, "key", newJString(key))
  add(query_580114, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580115 = body
  add(query_580114, "prettyPrint", newJBool(prettyPrint))
  result = call_580112.call(path_580113, query_580114, nil, nil, body_580115)

var videointelligenceProjectsLocationsOperationsCancel* = Call_VideointelligenceProjectsLocationsOperationsCancel_580095(
    name: "videointelligenceProjectsLocationsOperationsCancel",
    meth: HttpMethod.HttpPost, host: "videointelligence.googleapis.com",
    route: "/v1/{name}:cancel",
    validator: validate_VideointelligenceProjectsLocationsOperationsCancel_580096,
    base: "/", url: url_VideointelligenceProjectsLocationsOperationsCancel_580097,
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
