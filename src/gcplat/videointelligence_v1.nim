
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VideointelligenceOperationsProjectsLocationsOperationsGet_593690 = ref object of OpenApiRestCall_593421
proc url_VideointelligenceOperationsProjectsLocationsOperationsGet_593692(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/operations/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VideointelligenceOperationsProjectsLocationsOperationsGet_593691(
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
  var valid_593818 = path.getOrDefault("name")
  valid_593818 = validateParameter(valid_593818, JString, required = true,
                                 default = nil)
  if valid_593818 != nil:
    section.add "name", valid_593818
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
  var valid_593819 = query.getOrDefault("upload_protocol")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = nil)
  if valid_593819 != nil:
    section.add "upload_protocol", valid_593819
  var valid_593820 = query.getOrDefault("fields")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = nil)
  if valid_593820 != nil:
    section.add "fields", valid_593820
  var valid_593821 = query.getOrDefault("quotaUser")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "quotaUser", valid_593821
  var valid_593835 = query.getOrDefault("alt")
  valid_593835 = validateParameter(valid_593835, JString, required = false,
                                 default = newJString("json"))
  if valid_593835 != nil:
    section.add "alt", valid_593835
  var valid_593836 = query.getOrDefault("oauth_token")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = nil)
  if valid_593836 != nil:
    section.add "oauth_token", valid_593836
  var valid_593837 = query.getOrDefault("callback")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = nil)
  if valid_593837 != nil:
    section.add "callback", valid_593837
  var valid_593838 = query.getOrDefault("access_token")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "access_token", valid_593838
  var valid_593839 = query.getOrDefault("uploadType")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "uploadType", valid_593839
  var valid_593840 = query.getOrDefault("key")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "key", valid_593840
  var valid_593841 = query.getOrDefault("$.xgafv")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = newJString("1"))
  if valid_593841 != nil:
    section.add "$.xgafv", valid_593841
  var valid_593842 = query.getOrDefault("prettyPrint")
  valid_593842 = validateParameter(valid_593842, JBool, required = false,
                                 default = newJBool(true))
  if valid_593842 != nil:
    section.add "prettyPrint", valid_593842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593865: Call_VideointelligenceOperationsProjectsLocationsOperationsGet_593690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_593865.validator(path, query, header, formData, body)
  let scheme = call_593865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593865.url(scheme.get, call_593865.host, call_593865.base,
                         call_593865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593865, url, valid)

proc call*(call_593936: Call_VideointelligenceOperationsProjectsLocationsOperationsGet_593690;
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
  var path_593937 = newJObject()
  var query_593939 = newJObject()
  add(query_593939, "upload_protocol", newJString(uploadProtocol))
  add(query_593939, "fields", newJString(fields))
  add(query_593939, "quotaUser", newJString(quotaUser))
  add(path_593937, "name", newJString(name))
  add(query_593939, "alt", newJString(alt))
  add(query_593939, "oauth_token", newJString(oauthToken))
  add(query_593939, "callback", newJString(callback))
  add(query_593939, "access_token", newJString(accessToken))
  add(query_593939, "uploadType", newJString(uploadType))
  add(query_593939, "key", newJString(key))
  add(query_593939, "$.xgafv", newJString(Xgafv))
  add(query_593939, "prettyPrint", newJBool(prettyPrint))
  result = call_593936.call(path_593937, query_593939, nil, nil, nil)

var videointelligenceOperationsProjectsLocationsOperationsGet* = Call_VideointelligenceOperationsProjectsLocationsOperationsGet_593690(
    name: "videointelligenceOperationsProjectsLocationsOperationsGet",
    meth: HttpMethod.HttpGet, host: "videointelligence.googleapis.com",
    route: "/v1/operations/{name}", validator: validate_VideointelligenceOperationsProjectsLocationsOperationsGet_593691,
    base: "/", url: url_VideointelligenceOperationsProjectsLocationsOperationsGet_593692,
    schemes: {Scheme.Https})
type
  Call_VideointelligenceOperationsProjectsLocationsOperationsDelete_593978 = ref object of OpenApiRestCall_593421
proc url_VideointelligenceOperationsProjectsLocationsOperationsDelete_593980(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/operations/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VideointelligenceOperationsProjectsLocationsOperationsDelete_593979(
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
  var valid_593981 = path.getOrDefault("name")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "name", valid_593981
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
  var valid_593982 = query.getOrDefault("upload_protocol")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "upload_protocol", valid_593982
  var valid_593983 = query.getOrDefault("fields")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "fields", valid_593983
  var valid_593984 = query.getOrDefault("quotaUser")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "quotaUser", valid_593984
  var valid_593985 = query.getOrDefault("alt")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = newJString("json"))
  if valid_593985 != nil:
    section.add "alt", valid_593985
  var valid_593986 = query.getOrDefault("oauth_token")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "oauth_token", valid_593986
  var valid_593987 = query.getOrDefault("callback")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "callback", valid_593987
  var valid_593988 = query.getOrDefault("access_token")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "access_token", valid_593988
  var valid_593989 = query.getOrDefault("uploadType")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "uploadType", valid_593989
  var valid_593990 = query.getOrDefault("key")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "key", valid_593990
  var valid_593991 = query.getOrDefault("$.xgafv")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("1"))
  if valid_593991 != nil:
    section.add "$.xgafv", valid_593991
  var valid_593992 = query.getOrDefault("prettyPrint")
  valid_593992 = validateParameter(valid_593992, JBool, required = false,
                                 default = newJBool(true))
  if valid_593992 != nil:
    section.add "prettyPrint", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_VideointelligenceOperationsProjectsLocationsOperationsDelete_593978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_VideointelligenceOperationsProjectsLocationsOperationsDelete_593978;
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
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(query_593996, "upload_protocol", newJString(uploadProtocol))
  add(query_593996, "fields", newJString(fields))
  add(query_593996, "quotaUser", newJString(quotaUser))
  add(path_593995, "name", newJString(name))
  add(query_593996, "alt", newJString(alt))
  add(query_593996, "oauth_token", newJString(oauthToken))
  add(query_593996, "callback", newJString(callback))
  add(query_593996, "access_token", newJString(accessToken))
  add(query_593996, "uploadType", newJString(uploadType))
  add(query_593996, "key", newJString(key))
  add(query_593996, "$.xgafv", newJString(Xgafv))
  add(query_593996, "prettyPrint", newJBool(prettyPrint))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var videointelligenceOperationsProjectsLocationsOperationsDelete* = Call_VideointelligenceOperationsProjectsLocationsOperationsDelete_593978(
    name: "videointelligenceOperationsProjectsLocationsOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "videointelligence.googleapis.com",
    route: "/v1/operations/{name}", validator: validate_VideointelligenceOperationsProjectsLocationsOperationsDelete_593979,
    base: "/",
    url: url_VideointelligenceOperationsProjectsLocationsOperationsDelete_593980,
    schemes: {Scheme.Https})
type
  Call_VideointelligenceOperationsProjectsLocationsOperationsCancel_593997 = ref object of OpenApiRestCall_593421
proc url_VideointelligenceOperationsProjectsLocationsOperationsCancel_593999(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VideointelligenceOperationsProjectsLocationsOperationsCancel_593998(
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
  var valid_594000 = path.getOrDefault("name")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "name", valid_594000
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
  var valid_594001 = query.getOrDefault("upload_protocol")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "upload_protocol", valid_594001
  var valid_594002 = query.getOrDefault("fields")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "fields", valid_594002
  var valid_594003 = query.getOrDefault("quotaUser")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "quotaUser", valid_594003
  var valid_594004 = query.getOrDefault("alt")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = newJString("json"))
  if valid_594004 != nil:
    section.add "alt", valid_594004
  var valid_594005 = query.getOrDefault("oauth_token")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "oauth_token", valid_594005
  var valid_594006 = query.getOrDefault("callback")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "callback", valid_594006
  var valid_594007 = query.getOrDefault("access_token")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "access_token", valid_594007
  var valid_594008 = query.getOrDefault("uploadType")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "uploadType", valid_594008
  var valid_594009 = query.getOrDefault("key")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "key", valid_594009
  var valid_594010 = query.getOrDefault("$.xgafv")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = newJString("1"))
  if valid_594010 != nil:
    section.add "$.xgafv", valid_594010
  var valid_594011 = query.getOrDefault("prettyPrint")
  valid_594011 = validateParameter(valid_594011, JBool, required = false,
                                 default = newJBool(true))
  if valid_594011 != nil:
    section.add "prettyPrint", valid_594011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594012: Call_VideointelligenceOperationsProjectsLocationsOperationsCancel_593997;
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
  let valid = call_594012.validator(path, query, header, formData, body)
  let scheme = call_594012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594012.url(scheme.get, call_594012.host, call_594012.base,
                         call_594012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594012, url, valid)

proc call*(call_594013: Call_VideointelligenceOperationsProjectsLocationsOperationsCancel_593997;
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
  var path_594014 = newJObject()
  var query_594015 = newJObject()
  add(query_594015, "upload_protocol", newJString(uploadProtocol))
  add(query_594015, "fields", newJString(fields))
  add(query_594015, "quotaUser", newJString(quotaUser))
  add(path_594014, "name", newJString(name))
  add(query_594015, "alt", newJString(alt))
  add(query_594015, "oauth_token", newJString(oauthToken))
  add(query_594015, "callback", newJString(callback))
  add(query_594015, "access_token", newJString(accessToken))
  add(query_594015, "uploadType", newJString(uploadType))
  add(query_594015, "key", newJString(key))
  add(query_594015, "$.xgafv", newJString(Xgafv))
  add(query_594015, "prettyPrint", newJBool(prettyPrint))
  result = call_594013.call(path_594014, query_594015, nil, nil, nil)

var videointelligenceOperationsProjectsLocationsOperationsCancel* = Call_VideointelligenceOperationsProjectsLocationsOperationsCancel_593997(
    name: "videointelligenceOperationsProjectsLocationsOperationsCancel",
    meth: HttpMethod.HttpPost, host: "videointelligence.googleapis.com",
    route: "/v1/operations/{name}:cancel", validator: validate_VideointelligenceOperationsProjectsLocationsOperationsCancel_593998,
    base: "/",
    url: url_VideointelligenceOperationsProjectsLocationsOperationsCancel_593999,
    schemes: {Scheme.Https})
type
  Call_VideointelligenceVideosAnnotate_594016 = ref object of OpenApiRestCall_593421
proc url_VideointelligenceVideosAnnotate_594018(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_VideointelligenceVideosAnnotate_594017(path: JsonNode;
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
  var valid_594019 = query.getOrDefault("upload_protocol")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "upload_protocol", valid_594019
  var valid_594020 = query.getOrDefault("fields")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "fields", valid_594020
  var valid_594021 = query.getOrDefault("quotaUser")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "quotaUser", valid_594021
  var valid_594022 = query.getOrDefault("alt")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = newJString("json"))
  if valid_594022 != nil:
    section.add "alt", valid_594022
  var valid_594023 = query.getOrDefault("oauth_token")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "oauth_token", valid_594023
  var valid_594024 = query.getOrDefault("callback")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "callback", valid_594024
  var valid_594025 = query.getOrDefault("access_token")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "access_token", valid_594025
  var valid_594026 = query.getOrDefault("uploadType")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "uploadType", valid_594026
  var valid_594027 = query.getOrDefault("key")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "key", valid_594027
  var valid_594028 = query.getOrDefault("$.xgafv")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = newJString("1"))
  if valid_594028 != nil:
    section.add "$.xgafv", valid_594028
  var valid_594029 = query.getOrDefault("prettyPrint")
  valid_594029 = validateParameter(valid_594029, JBool, required = false,
                                 default = newJBool(true))
  if valid_594029 != nil:
    section.add "prettyPrint", valid_594029
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

proc call*(call_594031: Call_VideointelligenceVideosAnnotate_594016;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Performs asynchronous video annotation. Progress and results can be
  ## retrieved through the `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `AnnotateVideoProgress` (progress).
  ## `Operation.response` contains `AnnotateVideoResponse` (results).
  ## 
  let valid = call_594031.validator(path, query, header, formData, body)
  let scheme = call_594031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594031.url(scheme.get, call_594031.host, call_594031.base,
                         call_594031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594031, url, valid)

proc call*(call_594032: Call_VideointelligenceVideosAnnotate_594016;
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
  var query_594033 = newJObject()
  var body_594034 = newJObject()
  add(query_594033, "upload_protocol", newJString(uploadProtocol))
  add(query_594033, "fields", newJString(fields))
  add(query_594033, "quotaUser", newJString(quotaUser))
  add(query_594033, "alt", newJString(alt))
  add(query_594033, "oauth_token", newJString(oauthToken))
  add(query_594033, "callback", newJString(callback))
  add(query_594033, "access_token", newJString(accessToken))
  add(query_594033, "uploadType", newJString(uploadType))
  add(query_594033, "key", newJString(key))
  add(query_594033, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594034 = body
  add(query_594033, "prettyPrint", newJBool(prettyPrint))
  result = call_594032.call(nil, query_594033, nil, nil, body_594034)

var videointelligenceVideosAnnotate* = Call_VideointelligenceVideosAnnotate_594016(
    name: "videointelligenceVideosAnnotate", meth: HttpMethod.HttpPost,
    host: "videointelligence.googleapis.com", route: "/v1/videos:annotate",
    validator: validate_VideointelligenceVideosAnnotate_594017, base: "/",
    url: url_VideointelligenceVideosAnnotate_594018, schemes: {Scheme.Https})
type
  Call_VideointelligenceProjectsLocationsOperationsGet_594035 = ref object of OpenApiRestCall_593421
proc url_VideointelligenceProjectsLocationsOperationsGet_594037(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VideointelligenceProjectsLocationsOperationsGet_594036(
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
  var valid_594038 = path.getOrDefault("name")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "name", valid_594038
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
  var valid_594039 = query.getOrDefault("upload_protocol")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "upload_protocol", valid_594039
  var valid_594040 = query.getOrDefault("fields")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "fields", valid_594040
  var valid_594041 = query.getOrDefault("quotaUser")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "quotaUser", valid_594041
  var valid_594042 = query.getOrDefault("alt")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = newJString("json"))
  if valid_594042 != nil:
    section.add "alt", valid_594042
  var valid_594043 = query.getOrDefault("oauth_token")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "oauth_token", valid_594043
  var valid_594044 = query.getOrDefault("callback")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "callback", valid_594044
  var valid_594045 = query.getOrDefault("access_token")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "access_token", valid_594045
  var valid_594046 = query.getOrDefault("uploadType")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "uploadType", valid_594046
  var valid_594047 = query.getOrDefault("key")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "key", valid_594047
  var valid_594048 = query.getOrDefault("$.xgafv")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = newJString("1"))
  if valid_594048 != nil:
    section.add "$.xgafv", valid_594048
  var valid_594049 = query.getOrDefault("prettyPrint")
  valid_594049 = validateParameter(valid_594049, JBool, required = false,
                                 default = newJBool(true))
  if valid_594049 != nil:
    section.add "prettyPrint", valid_594049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594050: Call_VideointelligenceProjectsLocationsOperationsGet_594035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_VideointelligenceProjectsLocationsOperationsGet_594035;
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
  var path_594052 = newJObject()
  var query_594053 = newJObject()
  add(query_594053, "upload_protocol", newJString(uploadProtocol))
  add(query_594053, "fields", newJString(fields))
  add(query_594053, "quotaUser", newJString(quotaUser))
  add(path_594052, "name", newJString(name))
  add(query_594053, "alt", newJString(alt))
  add(query_594053, "oauth_token", newJString(oauthToken))
  add(query_594053, "callback", newJString(callback))
  add(query_594053, "access_token", newJString(accessToken))
  add(query_594053, "uploadType", newJString(uploadType))
  add(query_594053, "key", newJString(key))
  add(query_594053, "$.xgafv", newJString(Xgafv))
  add(query_594053, "prettyPrint", newJBool(prettyPrint))
  result = call_594051.call(path_594052, query_594053, nil, nil, nil)

var videointelligenceProjectsLocationsOperationsGet* = Call_VideointelligenceProjectsLocationsOperationsGet_594035(
    name: "videointelligenceProjectsLocationsOperationsGet",
    meth: HttpMethod.HttpGet, host: "videointelligence.googleapis.com",
    route: "/v1/{name}",
    validator: validate_VideointelligenceProjectsLocationsOperationsGet_594036,
    base: "/", url: url_VideointelligenceProjectsLocationsOperationsGet_594037,
    schemes: {Scheme.Https})
type
  Call_VideointelligenceProjectsLocationsOperationsDelete_594054 = ref object of OpenApiRestCall_593421
proc url_VideointelligenceProjectsLocationsOperationsDelete_594056(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VideointelligenceProjectsLocationsOperationsDelete_594055(
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
  var valid_594057 = path.getOrDefault("name")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "name", valid_594057
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
  var valid_594058 = query.getOrDefault("upload_protocol")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "upload_protocol", valid_594058
  var valid_594059 = query.getOrDefault("fields")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "fields", valid_594059
  var valid_594060 = query.getOrDefault("quotaUser")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "quotaUser", valid_594060
  var valid_594061 = query.getOrDefault("alt")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = newJString("json"))
  if valid_594061 != nil:
    section.add "alt", valid_594061
  var valid_594062 = query.getOrDefault("oauth_token")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "oauth_token", valid_594062
  var valid_594063 = query.getOrDefault("callback")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "callback", valid_594063
  var valid_594064 = query.getOrDefault("access_token")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "access_token", valid_594064
  var valid_594065 = query.getOrDefault("uploadType")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "uploadType", valid_594065
  var valid_594066 = query.getOrDefault("key")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "key", valid_594066
  var valid_594067 = query.getOrDefault("$.xgafv")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = newJString("1"))
  if valid_594067 != nil:
    section.add "$.xgafv", valid_594067
  var valid_594068 = query.getOrDefault("prettyPrint")
  valid_594068 = validateParameter(valid_594068, JBool, required = false,
                                 default = newJBool(true))
  if valid_594068 != nil:
    section.add "prettyPrint", valid_594068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594069: Call_VideointelligenceProjectsLocationsOperationsDelete_594054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_594069.validator(path, query, header, formData, body)
  let scheme = call_594069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594069.url(scheme.get, call_594069.host, call_594069.base,
                         call_594069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594069, url, valid)

proc call*(call_594070: Call_VideointelligenceProjectsLocationsOperationsDelete_594054;
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
  var path_594071 = newJObject()
  var query_594072 = newJObject()
  add(query_594072, "upload_protocol", newJString(uploadProtocol))
  add(query_594072, "fields", newJString(fields))
  add(query_594072, "quotaUser", newJString(quotaUser))
  add(path_594071, "name", newJString(name))
  add(query_594072, "alt", newJString(alt))
  add(query_594072, "oauth_token", newJString(oauthToken))
  add(query_594072, "callback", newJString(callback))
  add(query_594072, "access_token", newJString(accessToken))
  add(query_594072, "uploadType", newJString(uploadType))
  add(query_594072, "key", newJString(key))
  add(query_594072, "$.xgafv", newJString(Xgafv))
  add(query_594072, "prettyPrint", newJBool(prettyPrint))
  result = call_594070.call(path_594071, query_594072, nil, nil, nil)

var videointelligenceProjectsLocationsOperationsDelete* = Call_VideointelligenceProjectsLocationsOperationsDelete_594054(
    name: "videointelligenceProjectsLocationsOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "videointelligence.googleapis.com",
    route: "/v1/{name}",
    validator: validate_VideointelligenceProjectsLocationsOperationsDelete_594055,
    base: "/", url: url_VideointelligenceProjectsLocationsOperationsDelete_594056,
    schemes: {Scheme.Https})
type
  Call_VideointelligenceProjectsLocationsOperationsList_594073 = ref object of OpenApiRestCall_593421
proc url_VideointelligenceProjectsLocationsOperationsList_594075(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VideointelligenceProjectsLocationsOperationsList_594074(
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
  var valid_594076 = path.getOrDefault("name")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "name", valid_594076
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
  var valid_594077 = query.getOrDefault("upload_protocol")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "upload_protocol", valid_594077
  var valid_594078 = query.getOrDefault("fields")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "fields", valid_594078
  var valid_594079 = query.getOrDefault("pageToken")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "pageToken", valid_594079
  var valid_594080 = query.getOrDefault("quotaUser")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "quotaUser", valid_594080
  var valid_594081 = query.getOrDefault("alt")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = newJString("json"))
  if valid_594081 != nil:
    section.add "alt", valid_594081
  var valid_594082 = query.getOrDefault("oauth_token")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "oauth_token", valid_594082
  var valid_594083 = query.getOrDefault("callback")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "callback", valid_594083
  var valid_594084 = query.getOrDefault("access_token")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "access_token", valid_594084
  var valid_594085 = query.getOrDefault("uploadType")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "uploadType", valid_594085
  var valid_594086 = query.getOrDefault("key")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "key", valid_594086
  var valid_594087 = query.getOrDefault("$.xgafv")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = newJString("1"))
  if valid_594087 != nil:
    section.add "$.xgafv", valid_594087
  var valid_594088 = query.getOrDefault("pageSize")
  valid_594088 = validateParameter(valid_594088, JInt, required = false, default = nil)
  if valid_594088 != nil:
    section.add "pageSize", valid_594088
  var valid_594089 = query.getOrDefault("prettyPrint")
  valid_594089 = validateParameter(valid_594089, JBool, required = false,
                                 default = newJBool(true))
  if valid_594089 != nil:
    section.add "prettyPrint", valid_594089
  var valid_594090 = query.getOrDefault("filter")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "filter", valid_594090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594091: Call_VideointelligenceProjectsLocationsOperationsList_594073;
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
  let valid = call_594091.validator(path, query, header, formData, body)
  let scheme = call_594091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594091.url(scheme.get, call_594091.host, call_594091.base,
                         call_594091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594091, url, valid)

proc call*(call_594092: Call_VideointelligenceProjectsLocationsOperationsList_594073;
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
  var path_594093 = newJObject()
  var query_594094 = newJObject()
  add(query_594094, "upload_protocol", newJString(uploadProtocol))
  add(query_594094, "fields", newJString(fields))
  add(query_594094, "pageToken", newJString(pageToken))
  add(query_594094, "quotaUser", newJString(quotaUser))
  add(path_594093, "name", newJString(name))
  add(query_594094, "alt", newJString(alt))
  add(query_594094, "oauth_token", newJString(oauthToken))
  add(query_594094, "callback", newJString(callback))
  add(query_594094, "access_token", newJString(accessToken))
  add(query_594094, "uploadType", newJString(uploadType))
  add(query_594094, "key", newJString(key))
  add(query_594094, "$.xgafv", newJString(Xgafv))
  add(query_594094, "pageSize", newJInt(pageSize))
  add(query_594094, "prettyPrint", newJBool(prettyPrint))
  add(query_594094, "filter", newJString(filter))
  result = call_594092.call(path_594093, query_594094, nil, nil, nil)

var videointelligenceProjectsLocationsOperationsList* = Call_VideointelligenceProjectsLocationsOperationsList_594073(
    name: "videointelligenceProjectsLocationsOperationsList",
    meth: HttpMethod.HttpGet, host: "videointelligence.googleapis.com",
    route: "/v1/{name}/operations",
    validator: validate_VideointelligenceProjectsLocationsOperationsList_594074,
    base: "/", url: url_VideointelligenceProjectsLocationsOperationsList_594075,
    schemes: {Scheme.Https})
type
  Call_VideointelligenceProjectsLocationsOperationsCancel_594095 = ref object of OpenApiRestCall_593421
proc url_VideointelligenceProjectsLocationsOperationsCancel_594097(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VideointelligenceProjectsLocationsOperationsCancel_594096(
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
  var valid_594098 = path.getOrDefault("name")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "name", valid_594098
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
  var valid_594099 = query.getOrDefault("upload_protocol")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "upload_protocol", valid_594099
  var valid_594100 = query.getOrDefault("fields")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "fields", valid_594100
  var valid_594101 = query.getOrDefault("quotaUser")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "quotaUser", valid_594101
  var valid_594102 = query.getOrDefault("alt")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = newJString("json"))
  if valid_594102 != nil:
    section.add "alt", valid_594102
  var valid_594103 = query.getOrDefault("oauth_token")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "oauth_token", valid_594103
  var valid_594104 = query.getOrDefault("callback")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "callback", valid_594104
  var valid_594105 = query.getOrDefault("access_token")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "access_token", valid_594105
  var valid_594106 = query.getOrDefault("uploadType")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "uploadType", valid_594106
  var valid_594107 = query.getOrDefault("key")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "key", valid_594107
  var valid_594108 = query.getOrDefault("$.xgafv")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = newJString("1"))
  if valid_594108 != nil:
    section.add "$.xgafv", valid_594108
  var valid_594109 = query.getOrDefault("prettyPrint")
  valid_594109 = validateParameter(valid_594109, JBool, required = false,
                                 default = newJBool(true))
  if valid_594109 != nil:
    section.add "prettyPrint", valid_594109
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

proc call*(call_594111: Call_VideointelligenceProjectsLocationsOperationsCancel_594095;
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
  let valid = call_594111.validator(path, query, header, formData, body)
  let scheme = call_594111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594111.url(scheme.get, call_594111.host, call_594111.base,
                         call_594111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594111, url, valid)

proc call*(call_594112: Call_VideointelligenceProjectsLocationsOperationsCancel_594095;
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
  var path_594113 = newJObject()
  var query_594114 = newJObject()
  var body_594115 = newJObject()
  add(query_594114, "upload_protocol", newJString(uploadProtocol))
  add(query_594114, "fields", newJString(fields))
  add(query_594114, "quotaUser", newJString(quotaUser))
  add(path_594113, "name", newJString(name))
  add(query_594114, "alt", newJString(alt))
  add(query_594114, "oauth_token", newJString(oauthToken))
  add(query_594114, "callback", newJString(callback))
  add(query_594114, "access_token", newJString(accessToken))
  add(query_594114, "uploadType", newJString(uploadType))
  add(query_594114, "key", newJString(key))
  add(query_594114, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594115 = body
  add(query_594114, "prettyPrint", newJBool(prettyPrint))
  result = call_594112.call(path_594113, query_594114, nil, nil, body_594115)

var videointelligenceProjectsLocationsOperationsCancel* = Call_VideointelligenceProjectsLocationsOperationsCancel_594095(
    name: "videointelligenceProjectsLocationsOperationsCancel",
    meth: HttpMethod.HttpPost, host: "videointelligence.googleapis.com",
    route: "/v1/{name}:cancel",
    validator: validate_VideointelligenceProjectsLocationsOperationsCancel_594096,
    base: "/", url: url_VideointelligenceProjectsLocationsOperationsCancel_594097,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
