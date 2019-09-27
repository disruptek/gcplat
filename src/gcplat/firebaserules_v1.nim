
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Firebase Rules
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Creates and manages rules that determine when a Firebase Rules-enabled service should permit a request.
## 
## 
## https://firebase.google.com/docs/storage/security
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  gcpServiceName = "firebaserules"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirebaserulesProjectsReleasesGet_593677 = ref object of OpenApiRestCall_593408
proc url_FirebaserulesProjectsReleasesGet_593679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirebaserulesProjectsReleasesGet_593678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a `Release` by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the `Release`.
  ## 
  ## Format: `projects/{project_id}/releases/{release_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593805 = path.getOrDefault("name")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "name", valid_593805
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
  var valid_593806 = query.getOrDefault("upload_protocol")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "upload_protocol", valid_593806
  var valid_593807 = query.getOrDefault("fields")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "fields", valid_593807
  var valid_593808 = query.getOrDefault("quotaUser")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "quotaUser", valid_593808
  var valid_593822 = query.getOrDefault("alt")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = newJString("json"))
  if valid_593822 != nil:
    section.add "alt", valid_593822
  var valid_593823 = query.getOrDefault("oauth_token")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "oauth_token", valid_593823
  var valid_593824 = query.getOrDefault("callback")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "callback", valid_593824
  var valid_593825 = query.getOrDefault("access_token")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "access_token", valid_593825
  var valid_593826 = query.getOrDefault("uploadType")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "uploadType", valid_593826
  var valid_593827 = query.getOrDefault("key")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "key", valid_593827
  var valid_593828 = query.getOrDefault("$.xgafv")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = newJString("1"))
  if valid_593828 != nil:
    section.add "$.xgafv", valid_593828
  var valid_593829 = query.getOrDefault("prettyPrint")
  valid_593829 = validateParameter(valid_593829, JBool, required = false,
                                 default = newJBool(true))
  if valid_593829 != nil:
    section.add "prettyPrint", valid_593829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593852: Call_FirebaserulesProjectsReleasesGet_593677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a `Release` by name.
  ## 
  let valid = call_593852.validator(path, query, header, formData, body)
  let scheme = call_593852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593852.url(scheme.get, call_593852.host, call_593852.base,
                         call_593852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593852, url, valid)

proc call*(call_593923: Call_FirebaserulesProjectsReleasesGet_593677; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## firebaserulesProjectsReleasesGet
  ## Get a `Release` by name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the `Release`.
  ## 
  ## Format: `projects/{project_id}/releases/{release_id}`
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
  var path_593924 = newJObject()
  var query_593926 = newJObject()
  add(query_593926, "upload_protocol", newJString(uploadProtocol))
  add(query_593926, "fields", newJString(fields))
  add(query_593926, "quotaUser", newJString(quotaUser))
  add(path_593924, "name", newJString(name))
  add(query_593926, "alt", newJString(alt))
  add(query_593926, "oauth_token", newJString(oauthToken))
  add(query_593926, "callback", newJString(callback))
  add(query_593926, "access_token", newJString(accessToken))
  add(query_593926, "uploadType", newJString(uploadType))
  add(query_593926, "key", newJString(key))
  add(query_593926, "$.xgafv", newJString(Xgafv))
  add(query_593926, "prettyPrint", newJBool(prettyPrint))
  result = call_593923.call(path_593924, query_593926, nil, nil, nil)

var firebaserulesProjectsReleasesGet* = Call_FirebaserulesProjectsReleasesGet_593677(
    name: "firebaserulesProjectsReleasesGet", meth: HttpMethod.HttpGet,
    host: "firebaserules.googleapis.com", route: "/v1/{name}",
    validator: validate_FirebaserulesProjectsReleasesGet_593678, base: "/",
    url: url_FirebaserulesProjectsReleasesGet_593679, schemes: {Scheme.Https})
type
  Call_FirebaserulesProjectsReleasesPatch_593984 = ref object of OpenApiRestCall_593408
proc url_FirebaserulesProjectsReleasesPatch_593986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirebaserulesProjectsReleasesPatch_593985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a `Release` via PATCH.
  ## 
  ## Only updates to the `ruleset_name` and `test_suite_name` fields will be
  ## honored. `Release` rename is not supported. To create a `Release` use the
  ## CreateRelease method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name for the project which owns this `Release`.
  ## 
  ## Format: `projects/{project_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593987 = path.getOrDefault("name")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "name", valid_593987
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
  var valid_593988 = query.getOrDefault("upload_protocol")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "upload_protocol", valid_593988
  var valid_593989 = query.getOrDefault("fields")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "fields", valid_593989
  var valid_593990 = query.getOrDefault("quotaUser")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "quotaUser", valid_593990
  var valid_593991 = query.getOrDefault("alt")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("json"))
  if valid_593991 != nil:
    section.add "alt", valid_593991
  var valid_593992 = query.getOrDefault("oauth_token")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "oauth_token", valid_593992
  var valid_593993 = query.getOrDefault("callback")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "callback", valid_593993
  var valid_593994 = query.getOrDefault("access_token")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "access_token", valid_593994
  var valid_593995 = query.getOrDefault("uploadType")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "uploadType", valid_593995
  var valid_593996 = query.getOrDefault("key")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "key", valid_593996
  var valid_593997 = query.getOrDefault("$.xgafv")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = newJString("1"))
  if valid_593997 != nil:
    section.add "$.xgafv", valid_593997
  var valid_593998 = query.getOrDefault("prettyPrint")
  valid_593998 = validateParameter(valid_593998, JBool, required = false,
                                 default = newJBool(true))
  if valid_593998 != nil:
    section.add "prettyPrint", valid_593998
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

proc call*(call_594000: Call_FirebaserulesProjectsReleasesPatch_593984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a `Release` via PATCH.
  ## 
  ## Only updates to the `ruleset_name` and `test_suite_name` fields will be
  ## honored. `Release` rename is not supported. To create a `Release` use the
  ## CreateRelease method.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_FirebaserulesProjectsReleasesPatch_593984;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firebaserulesProjectsReleasesPatch
  ## Update a `Release` via PATCH.
  ## 
  ## Only updates to the `ruleset_name` and `test_suite_name` fields will be
  ## honored. `Release` rename is not supported. To create a `Release` use the
  ## CreateRelease method.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name for the project which owns this `Release`.
  ## 
  ## Format: `projects/{project_id}`
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
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  var body_594004 = newJObject()
  add(query_594003, "upload_protocol", newJString(uploadProtocol))
  add(query_594003, "fields", newJString(fields))
  add(query_594003, "quotaUser", newJString(quotaUser))
  add(path_594002, "name", newJString(name))
  add(query_594003, "alt", newJString(alt))
  add(query_594003, "oauth_token", newJString(oauthToken))
  add(query_594003, "callback", newJString(callback))
  add(query_594003, "access_token", newJString(accessToken))
  add(query_594003, "uploadType", newJString(uploadType))
  add(query_594003, "key", newJString(key))
  add(query_594003, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594004 = body
  add(query_594003, "prettyPrint", newJBool(prettyPrint))
  result = call_594001.call(path_594002, query_594003, nil, nil, body_594004)

var firebaserulesProjectsReleasesPatch* = Call_FirebaserulesProjectsReleasesPatch_593984(
    name: "firebaserulesProjectsReleasesPatch", meth: HttpMethod.HttpPatch,
    host: "firebaserules.googleapis.com", route: "/v1/{name}",
    validator: validate_FirebaserulesProjectsReleasesPatch_593985, base: "/",
    url: url_FirebaserulesProjectsReleasesPatch_593986, schemes: {Scheme.Https})
type
  Call_FirebaserulesProjectsReleasesDelete_593965 = ref object of OpenApiRestCall_593408
proc url_FirebaserulesProjectsReleasesDelete_593967(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirebaserulesProjectsReleasesDelete_593966(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a `Release` by resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name for the `Release` to delete.
  ## 
  ## Format: `projects/{project_id}/releases/{release_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593968 = path.getOrDefault("name")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "name", valid_593968
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
  var valid_593969 = query.getOrDefault("upload_protocol")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "upload_protocol", valid_593969
  var valid_593970 = query.getOrDefault("fields")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "fields", valid_593970
  var valid_593971 = query.getOrDefault("quotaUser")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "quotaUser", valid_593971
  var valid_593972 = query.getOrDefault("alt")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = newJString("json"))
  if valid_593972 != nil:
    section.add "alt", valid_593972
  var valid_593973 = query.getOrDefault("oauth_token")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "oauth_token", valid_593973
  var valid_593974 = query.getOrDefault("callback")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "callback", valid_593974
  var valid_593975 = query.getOrDefault("access_token")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "access_token", valid_593975
  var valid_593976 = query.getOrDefault("uploadType")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "uploadType", valid_593976
  var valid_593977 = query.getOrDefault("key")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "key", valid_593977
  var valid_593978 = query.getOrDefault("$.xgafv")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = newJString("1"))
  if valid_593978 != nil:
    section.add "$.xgafv", valid_593978
  var valid_593979 = query.getOrDefault("prettyPrint")
  valid_593979 = validateParameter(valid_593979, JBool, required = false,
                                 default = newJBool(true))
  if valid_593979 != nil:
    section.add "prettyPrint", valid_593979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593980: Call_FirebaserulesProjectsReleasesDelete_593965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a `Release` by resource name.
  ## 
  let valid = call_593980.validator(path, query, header, formData, body)
  let scheme = call_593980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593980.url(scheme.get, call_593980.host, call_593980.base,
                         call_593980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593980, url, valid)

proc call*(call_593981: Call_FirebaserulesProjectsReleasesDelete_593965;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## firebaserulesProjectsReleasesDelete
  ## Delete a `Release` by resource name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name for the `Release` to delete.
  ## 
  ## Format: `projects/{project_id}/releases/{release_id}`
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
  var path_593982 = newJObject()
  var query_593983 = newJObject()
  add(query_593983, "upload_protocol", newJString(uploadProtocol))
  add(query_593983, "fields", newJString(fields))
  add(query_593983, "quotaUser", newJString(quotaUser))
  add(path_593982, "name", newJString(name))
  add(query_593983, "alt", newJString(alt))
  add(query_593983, "oauth_token", newJString(oauthToken))
  add(query_593983, "callback", newJString(callback))
  add(query_593983, "access_token", newJString(accessToken))
  add(query_593983, "uploadType", newJString(uploadType))
  add(query_593983, "key", newJString(key))
  add(query_593983, "$.xgafv", newJString(Xgafv))
  add(query_593983, "prettyPrint", newJBool(prettyPrint))
  result = call_593981.call(path_593982, query_593983, nil, nil, nil)

var firebaserulesProjectsReleasesDelete* = Call_FirebaserulesProjectsReleasesDelete_593965(
    name: "firebaserulesProjectsReleasesDelete", meth: HttpMethod.HttpDelete,
    host: "firebaserules.googleapis.com", route: "/v1/{name}",
    validator: validate_FirebaserulesProjectsReleasesDelete_593966, base: "/",
    url: url_FirebaserulesProjectsReleasesDelete_593967, schemes: {Scheme.Https})
type
  Call_FirebaserulesProjectsReleasesCreate_594027 = ref object of OpenApiRestCall_593408
proc url_FirebaserulesProjectsReleasesCreate_594029(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/releases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaserulesProjectsReleasesCreate_594028(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a `Release`.
  ## 
  ## Release names should reflect the developer's deployment practices. For
  ## example, the release name may include the environment name, application
  ## name, application version, or any other name meaningful to the developer.
  ## Once a `Release` refers to a `Ruleset`, the rules can be enforced by
  ## Firebase Rules-enabled services.
  ## 
  ## More than one `Release` may be 'live' concurrently. Consider the following
  ## three `Release` names for `projects/foo` and the `Ruleset` to which they
  ## refer.
  ## 
  ## Release Name                    | Ruleset Name
  ## --------------------------------|-------------
  ## projects/foo/releases/prod      | projects/foo/rulesets/uuid123
  ## projects/foo/releases/prod/beta | projects/foo/rulesets/uuid123
  ## projects/foo/releases/prod/v23  | projects/foo/rulesets/uuid456
  ## 
  ## The table reflects the `Ruleset` rollout in progress. The `prod` and
  ## `prod/beta` releases refer to the same `Ruleset`. However, `prod/v23`
  ## refers to a new `Ruleset`. The `Ruleset` reference for a `Release` may be
  ## updated using the UpdateRelease method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name for the project which owns this `Release`.
  ## 
  ## Format: `projects/{project_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594030 = path.getOrDefault("name")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "name", valid_594030
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
  var valid_594031 = query.getOrDefault("upload_protocol")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "upload_protocol", valid_594031
  var valid_594032 = query.getOrDefault("fields")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "fields", valid_594032
  var valid_594033 = query.getOrDefault("quotaUser")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "quotaUser", valid_594033
  var valid_594034 = query.getOrDefault("alt")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = newJString("json"))
  if valid_594034 != nil:
    section.add "alt", valid_594034
  var valid_594035 = query.getOrDefault("oauth_token")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "oauth_token", valid_594035
  var valid_594036 = query.getOrDefault("callback")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "callback", valid_594036
  var valid_594037 = query.getOrDefault("access_token")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "access_token", valid_594037
  var valid_594038 = query.getOrDefault("uploadType")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "uploadType", valid_594038
  var valid_594039 = query.getOrDefault("key")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "key", valid_594039
  var valid_594040 = query.getOrDefault("$.xgafv")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = newJString("1"))
  if valid_594040 != nil:
    section.add "$.xgafv", valid_594040
  var valid_594041 = query.getOrDefault("prettyPrint")
  valid_594041 = validateParameter(valid_594041, JBool, required = false,
                                 default = newJBool(true))
  if valid_594041 != nil:
    section.add "prettyPrint", valid_594041
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

proc call*(call_594043: Call_FirebaserulesProjectsReleasesCreate_594027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a `Release`.
  ## 
  ## Release names should reflect the developer's deployment practices. For
  ## example, the release name may include the environment name, application
  ## name, application version, or any other name meaningful to the developer.
  ## Once a `Release` refers to a `Ruleset`, the rules can be enforced by
  ## Firebase Rules-enabled services.
  ## 
  ## More than one `Release` may be 'live' concurrently. Consider the following
  ## three `Release` names for `projects/foo` and the `Ruleset` to which they
  ## refer.
  ## 
  ## Release Name                    | Ruleset Name
  ## --------------------------------|-------------
  ## projects/foo/releases/prod      | projects/foo/rulesets/uuid123
  ## projects/foo/releases/prod/beta | projects/foo/rulesets/uuid123
  ## projects/foo/releases/prod/v23  | projects/foo/rulesets/uuid456
  ## 
  ## The table reflects the `Ruleset` rollout in progress. The `prod` and
  ## `prod/beta` releases refer to the same `Ruleset`. However, `prod/v23`
  ## refers to a new `Ruleset`. The `Ruleset` reference for a `Release` may be
  ## updated using the UpdateRelease method.
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_FirebaserulesProjectsReleasesCreate_594027;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firebaserulesProjectsReleasesCreate
  ## Create a `Release`.
  ## 
  ## Release names should reflect the developer's deployment practices. For
  ## example, the release name may include the environment name, application
  ## name, application version, or any other name meaningful to the developer.
  ## Once a `Release` refers to a `Ruleset`, the rules can be enforced by
  ## Firebase Rules-enabled services.
  ## 
  ## More than one `Release` may be 'live' concurrently. Consider the following
  ## three `Release` names for `projects/foo` and the `Ruleset` to which they
  ## refer.
  ## 
  ## Release Name                    | Ruleset Name
  ## --------------------------------|-------------
  ## projects/foo/releases/prod      | projects/foo/rulesets/uuid123
  ## projects/foo/releases/prod/beta | projects/foo/rulesets/uuid123
  ## projects/foo/releases/prod/v23  | projects/foo/rulesets/uuid456
  ## 
  ## The table reflects the `Ruleset` rollout in progress. The `prod` and
  ## `prod/beta` releases refer to the same `Ruleset`. However, `prod/v23`
  ## refers to a new `Ruleset`. The `Ruleset` reference for a `Release` may be
  ## updated using the UpdateRelease method.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name for the project which owns this `Release`.
  ## 
  ## Format: `projects/{project_id}`
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
  var path_594045 = newJObject()
  var query_594046 = newJObject()
  var body_594047 = newJObject()
  add(query_594046, "upload_protocol", newJString(uploadProtocol))
  add(query_594046, "fields", newJString(fields))
  add(query_594046, "quotaUser", newJString(quotaUser))
  add(path_594045, "name", newJString(name))
  add(query_594046, "alt", newJString(alt))
  add(query_594046, "oauth_token", newJString(oauthToken))
  add(query_594046, "callback", newJString(callback))
  add(query_594046, "access_token", newJString(accessToken))
  add(query_594046, "uploadType", newJString(uploadType))
  add(query_594046, "key", newJString(key))
  add(query_594046, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594047 = body
  add(query_594046, "prettyPrint", newJBool(prettyPrint))
  result = call_594044.call(path_594045, query_594046, nil, nil, body_594047)

var firebaserulesProjectsReleasesCreate* = Call_FirebaserulesProjectsReleasesCreate_594027(
    name: "firebaserulesProjectsReleasesCreate", meth: HttpMethod.HttpPost,
    host: "firebaserules.googleapis.com", route: "/v1/{name}/releases",
    validator: validate_FirebaserulesProjectsReleasesCreate_594028, base: "/",
    url: url_FirebaserulesProjectsReleasesCreate_594029, schemes: {Scheme.Https})
type
  Call_FirebaserulesProjectsReleasesList_594005 = ref object of OpenApiRestCall_593408
proc url_FirebaserulesProjectsReleasesList_594007(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/releases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaserulesProjectsReleasesList_594006(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the `Release` values for a project. This list may optionally be
  ## filtered by `Release` name, `Ruleset` name, `TestSuite` name, or any
  ## combination thereof.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name for the project.
  ## 
  ## Format: `projects/{project_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594008 = path.getOrDefault("name")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "name", valid_594008
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Next page token for the next batch of `Release` instances.
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
  ##           : Page size to load. Maximum of 100. Defaults to 10.
  ## Note: `page_size` is just a hint and the service may choose to load fewer
  ## than `page_size` results due to the size of the output. To traverse all of
  ## the releases, the caller should iterate until the `page_token` on the
  ## response is empty.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : `Release` filter. The list method supports filters with restrictions on the
  ## `Release.name`, `Release.ruleset_name`, and `Release.test_suite_name`.
  ## 
  ## Example 1: A filter of 'name=prod*' might return `Release`s with names
  ## within 'projects/foo' prefixed with 'prod':
  ## 
  ## Name                          | Ruleset Name
  ## ------------------------------|-------------
  ## projects/foo/releases/prod    | projects/foo/rulesets/uuid1234
  ## projects/foo/releases/prod/v1 | projects/foo/rulesets/uuid1234
  ## projects/foo/releases/prod/v2 | projects/foo/rulesets/uuid8888
  ## 
  ## Example 2: A filter of `name=prod* ruleset_name=uuid1234` would return only
  ## `Release` instances for 'projects/foo' with names prefixed with 'prod'
  ## referring to the same `Ruleset` name of 'uuid1234':
  ## 
  ## Name                          | Ruleset Name
  ## ------------------------------|-------------
  ## projects/foo/releases/prod    | projects/foo/rulesets/1234
  ## projects/foo/releases/prod/v1 | projects/foo/rulesets/1234
  ## 
  ## In the examples, the filter parameters refer to the search filters are
  ## relative to the project. Fully qualified prefixed may also be used. e.g.
  ## `test_suite_name=projects/foo/testsuites/uuid1`
  section = newJObject()
  var valid_594009 = query.getOrDefault("upload_protocol")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "upload_protocol", valid_594009
  var valid_594010 = query.getOrDefault("fields")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "fields", valid_594010
  var valid_594011 = query.getOrDefault("pageToken")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "pageToken", valid_594011
  var valid_594012 = query.getOrDefault("quotaUser")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "quotaUser", valid_594012
  var valid_594013 = query.getOrDefault("alt")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = newJString("json"))
  if valid_594013 != nil:
    section.add "alt", valid_594013
  var valid_594014 = query.getOrDefault("oauth_token")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "oauth_token", valid_594014
  var valid_594015 = query.getOrDefault("callback")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "callback", valid_594015
  var valid_594016 = query.getOrDefault("access_token")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "access_token", valid_594016
  var valid_594017 = query.getOrDefault("uploadType")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "uploadType", valid_594017
  var valid_594018 = query.getOrDefault("key")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "key", valid_594018
  var valid_594019 = query.getOrDefault("$.xgafv")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = newJString("1"))
  if valid_594019 != nil:
    section.add "$.xgafv", valid_594019
  var valid_594020 = query.getOrDefault("pageSize")
  valid_594020 = validateParameter(valid_594020, JInt, required = false, default = nil)
  if valid_594020 != nil:
    section.add "pageSize", valid_594020
  var valid_594021 = query.getOrDefault("prettyPrint")
  valid_594021 = validateParameter(valid_594021, JBool, required = false,
                                 default = newJBool(true))
  if valid_594021 != nil:
    section.add "prettyPrint", valid_594021
  var valid_594022 = query.getOrDefault("filter")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "filter", valid_594022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594023: Call_FirebaserulesProjectsReleasesList_594005;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the `Release` values for a project. This list may optionally be
  ## filtered by `Release` name, `Ruleset` name, `TestSuite` name, or any
  ## combination thereof.
  ## 
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_FirebaserulesProjectsReleasesList_594005;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## firebaserulesProjectsReleasesList
  ## List the `Release` values for a project. This list may optionally be
  ## filtered by `Release` name, `Ruleset` name, `TestSuite` name, or any
  ## combination thereof.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Next page token for the next batch of `Release` instances.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name for the project.
  ## 
  ## Format: `projects/{project_id}`
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
  ##           : Page size to load. Maximum of 100. Defaults to 10.
  ## Note: `page_size` is just a hint and the service may choose to load fewer
  ## than `page_size` results due to the size of the output. To traverse all of
  ## the releases, the caller should iterate until the `page_token` on the
  ## response is empty.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : `Release` filter. The list method supports filters with restrictions on the
  ## `Release.name`, `Release.ruleset_name`, and `Release.test_suite_name`.
  ## 
  ## Example 1: A filter of 'name=prod*' might return `Release`s with names
  ## within 'projects/foo' prefixed with 'prod':
  ## 
  ## Name                          | Ruleset Name
  ## ------------------------------|-------------
  ## projects/foo/releases/prod    | projects/foo/rulesets/uuid1234
  ## projects/foo/releases/prod/v1 | projects/foo/rulesets/uuid1234
  ## projects/foo/releases/prod/v2 | projects/foo/rulesets/uuid8888
  ## 
  ## Example 2: A filter of `name=prod* ruleset_name=uuid1234` would return only
  ## `Release` instances for 'projects/foo' with names prefixed with 'prod'
  ## referring to the same `Ruleset` name of 'uuid1234':
  ## 
  ## Name                          | Ruleset Name
  ## ------------------------------|-------------
  ## projects/foo/releases/prod    | projects/foo/rulesets/1234
  ## projects/foo/releases/prod/v1 | projects/foo/rulesets/1234
  ## 
  ## In the examples, the filter parameters refer to the search filters are
  ## relative to the project. Fully qualified prefixed may also be used. e.g.
  ## `test_suite_name=projects/foo/testsuites/uuid1`
  var path_594025 = newJObject()
  var query_594026 = newJObject()
  add(query_594026, "upload_protocol", newJString(uploadProtocol))
  add(query_594026, "fields", newJString(fields))
  add(query_594026, "pageToken", newJString(pageToken))
  add(query_594026, "quotaUser", newJString(quotaUser))
  add(path_594025, "name", newJString(name))
  add(query_594026, "alt", newJString(alt))
  add(query_594026, "oauth_token", newJString(oauthToken))
  add(query_594026, "callback", newJString(callback))
  add(query_594026, "access_token", newJString(accessToken))
  add(query_594026, "uploadType", newJString(uploadType))
  add(query_594026, "key", newJString(key))
  add(query_594026, "$.xgafv", newJString(Xgafv))
  add(query_594026, "pageSize", newJInt(pageSize))
  add(query_594026, "prettyPrint", newJBool(prettyPrint))
  add(query_594026, "filter", newJString(filter))
  result = call_594024.call(path_594025, query_594026, nil, nil, nil)

var firebaserulesProjectsReleasesList* = Call_FirebaserulesProjectsReleasesList_594005(
    name: "firebaserulesProjectsReleasesList", meth: HttpMethod.HttpGet,
    host: "firebaserules.googleapis.com", route: "/v1/{name}/releases",
    validator: validate_FirebaserulesProjectsReleasesList_594006, base: "/",
    url: url_FirebaserulesProjectsReleasesList_594007, schemes: {Scheme.Https})
type
  Call_FirebaserulesProjectsRulesetsCreate_594070 = ref object of OpenApiRestCall_593408
proc url_FirebaserulesProjectsRulesetsCreate_594072(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/rulesets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaserulesProjectsRulesetsCreate_594071(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a `Ruleset` from `Source`.
  ## 
  ## The `Ruleset` is given a unique generated name which is returned to the
  ## caller. `Source` containing syntactic or semantics errors will result in an
  ## error response indicating the first error encountered. For a detailed view
  ## of `Source` issues, use TestRuleset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name for Project which owns this `Ruleset`.
  ## 
  ## Format: `projects/{project_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594073 = path.getOrDefault("name")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "name", valid_594073
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
  var valid_594074 = query.getOrDefault("upload_protocol")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "upload_protocol", valid_594074
  var valid_594075 = query.getOrDefault("fields")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "fields", valid_594075
  var valid_594076 = query.getOrDefault("quotaUser")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "quotaUser", valid_594076
  var valid_594077 = query.getOrDefault("alt")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = newJString("json"))
  if valid_594077 != nil:
    section.add "alt", valid_594077
  var valid_594078 = query.getOrDefault("oauth_token")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "oauth_token", valid_594078
  var valid_594079 = query.getOrDefault("callback")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "callback", valid_594079
  var valid_594080 = query.getOrDefault("access_token")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "access_token", valid_594080
  var valid_594081 = query.getOrDefault("uploadType")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "uploadType", valid_594081
  var valid_594082 = query.getOrDefault("key")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "key", valid_594082
  var valid_594083 = query.getOrDefault("$.xgafv")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = newJString("1"))
  if valid_594083 != nil:
    section.add "$.xgafv", valid_594083
  var valid_594084 = query.getOrDefault("prettyPrint")
  valid_594084 = validateParameter(valid_594084, JBool, required = false,
                                 default = newJBool(true))
  if valid_594084 != nil:
    section.add "prettyPrint", valid_594084
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

proc call*(call_594086: Call_FirebaserulesProjectsRulesetsCreate_594070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a `Ruleset` from `Source`.
  ## 
  ## The `Ruleset` is given a unique generated name which is returned to the
  ## caller. `Source` containing syntactic or semantics errors will result in an
  ## error response indicating the first error encountered. For a detailed view
  ## of `Source` issues, use TestRuleset.
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_FirebaserulesProjectsRulesetsCreate_594070;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firebaserulesProjectsRulesetsCreate
  ## Create a `Ruleset` from `Source`.
  ## 
  ## The `Ruleset` is given a unique generated name which is returned to the
  ## caller. `Source` containing syntactic or semantics errors will result in an
  ## error response indicating the first error encountered. For a detailed view
  ## of `Source` issues, use TestRuleset.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name for Project which owns this `Ruleset`.
  ## 
  ## Format: `projects/{project_id}`
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
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  var body_594090 = newJObject()
  add(query_594089, "upload_protocol", newJString(uploadProtocol))
  add(query_594089, "fields", newJString(fields))
  add(query_594089, "quotaUser", newJString(quotaUser))
  add(path_594088, "name", newJString(name))
  add(query_594089, "alt", newJString(alt))
  add(query_594089, "oauth_token", newJString(oauthToken))
  add(query_594089, "callback", newJString(callback))
  add(query_594089, "access_token", newJString(accessToken))
  add(query_594089, "uploadType", newJString(uploadType))
  add(query_594089, "key", newJString(key))
  add(query_594089, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594090 = body
  add(query_594089, "prettyPrint", newJBool(prettyPrint))
  result = call_594087.call(path_594088, query_594089, nil, nil, body_594090)

var firebaserulesProjectsRulesetsCreate* = Call_FirebaserulesProjectsRulesetsCreate_594070(
    name: "firebaserulesProjectsRulesetsCreate", meth: HttpMethod.HttpPost,
    host: "firebaserules.googleapis.com", route: "/v1/{name}/rulesets",
    validator: validate_FirebaserulesProjectsRulesetsCreate_594071, base: "/",
    url: url_FirebaserulesProjectsRulesetsCreate_594072, schemes: {Scheme.Https})
type
  Call_FirebaserulesProjectsRulesetsList_594048 = ref object of OpenApiRestCall_593408
proc url_FirebaserulesProjectsRulesetsList_594050(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/rulesets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaserulesProjectsRulesetsList_594049(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List `Ruleset` metadata only and optionally filter the results by `Ruleset`
  ## name.
  ## 
  ## The full `Source` contents of a `Ruleset` may be retrieved with
  ## GetRuleset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name for the project.
  ## 
  ## Format: `projects/{project_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594051 = path.getOrDefault("name")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "name", valid_594051
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Next page token for loading the next batch of `Ruleset` instances.
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
  ##           : Page size to load. Maximum of 100. Defaults to 10.
  ## Note: `page_size` is just a hint and the service may choose to load less
  ## than `page_size` due to the size of the output. To traverse all of the
  ## releases, caller should iterate until the `page_token` is empty.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : `Ruleset` filter. The list method supports filters with restrictions on
  ## `Ruleset.name`.
  ## 
  ## Filters on `Ruleset.create_time` should use the `date` function which
  ## parses strings that conform to the RFC 3339 date/time specifications.
  ## 
  ## Example: `create_time > date("2017-01-01T00:00:00Z") AND name=UUID-*`
  section = newJObject()
  var valid_594052 = query.getOrDefault("upload_protocol")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "upload_protocol", valid_594052
  var valid_594053 = query.getOrDefault("fields")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "fields", valid_594053
  var valid_594054 = query.getOrDefault("pageToken")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "pageToken", valid_594054
  var valid_594055 = query.getOrDefault("quotaUser")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "quotaUser", valid_594055
  var valid_594056 = query.getOrDefault("alt")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = newJString("json"))
  if valid_594056 != nil:
    section.add "alt", valid_594056
  var valid_594057 = query.getOrDefault("oauth_token")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "oauth_token", valid_594057
  var valid_594058 = query.getOrDefault("callback")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "callback", valid_594058
  var valid_594059 = query.getOrDefault("access_token")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "access_token", valid_594059
  var valid_594060 = query.getOrDefault("uploadType")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "uploadType", valid_594060
  var valid_594061 = query.getOrDefault("key")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "key", valid_594061
  var valid_594062 = query.getOrDefault("$.xgafv")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = newJString("1"))
  if valid_594062 != nil:
    section.add "$.xgafv", valid_594062
  var valid_594063 = query.getOrDefault("pageSize")
  valid_594063 = validateParameter(valid_594063, JInt, required = false, default = nil)
  if valid_594063 != nil:
    section.add "pageSize", valid_594063
  var valid_594064 = query.getOrDefault("prettyPrint")
  valid_594064 = validateParameter(valid_594064, JBool, required = false,
                                 default = newJBool(true))
  if valid_594064 != nil:
    section.add "prettyPrint", valid_594064
  var valid_594065 = query.getOrDefault("filter")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "filter", valid_594065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594066: Call_FirebaserulesProjectsRulesetsList_594048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List `Ruleset` metadata only and optionally filter the results by `Ruleset`
  ## name.
  ## 
  ## The full `Source` contents of a `Ruleset` may be retrieved with
  ## GetRuleset.
  ## 
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_FirebaserulesProjectsRulesetsList_594048;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## firebaserulesProjectsRulesetsList
  ## List `Ruleset` metadata only and optionally filter the results by `Ruleset`
  ## name.
  ## 
  ## The full `Source` contents of a `Ruleset` may be retrieved with
  ## GetRuleset.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Next page token for loading the next batch of `Ruleset` instances.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name for the project.
  ## 
  ## Format: `projects/{project_id}`
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
  ##           : Page size to load. Maximum of 100. Defaults to 10.
  ## Note: `page_size` is just a hint and the service may choose to load less
  ## than `page_size` due to the size of the output. To traverse all of the
  ## releases, caller should iterate until the `page_token` is empty.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : `Ruleset` filter. The list method supports filters with restrictions on
  ## `Ruleset.name`.
  ## 
  ## Filters on `Ruleset.create_time` should use the `date` function which
  ## parses strings that conform to the RFC 3339 date/time specifications.
  ## 
  ## Example: `create_time > date("2017-01-01T00:00:00Z") AND name=UUID-*`
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  add(query_594069, "upload_protocol", newJString(uploadProtocol))
  add(query_594069, "fields", newJString(fields))
  add(query_594069, "pageToken", newJString(pageToken))
  add(query_594069, "quotaUser", newJString(quotaUser))
  add(path_594068, "name", newJString(name))
  add(query_594069, "alt", newJString(alt))
  add(query_594069, "oauth_token", newJString(oauthToken))
  add(query_594069, "callback", newJString(callback))
  add(query_594069, "access_token", newJString(accessToken))
  add(query_594069, "uploadType", newJString(uploadType))
  add(query_594069, "key", newJString(key))
  add(query_594069, "$.xgafv", newJString(Xgafv))
  add(query_594069, "pageSize", newJInt(pageSize))
  add(query_594069, "prettyPrint", newJBool(prettyPrint))
  add(query_594069, "filter", newJString(filter))
  result = call_594067.call(path_594068, query_594069, nil, nil, nil)

var firebaserulesProjectsRulesetsList* = Call_FirebaserulesProjectsRulesetsList_594048(
    name: "firebaserulesProjectsRulesetsList", meth: HttpMethod.HttpGet,
    host: "firebaserules.googleapis.com", route: "/v1/{name}/rulesets",
    validator: validate_FirebaserulesProjectsRulesetsList_594049, base: "/",
    url: url_FirebaserulesProjectsRulesetsList_594050, schemes: {Scheme.Https})
type
  Call_FirebaserulesProjectsReleasesGetExecutable_594091 = ref object of OpenApiRestCall_593408
proc url_FirebaserulesProjectsReleasesGetExecutable_594093(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":getExecutable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaserulesProjectsReleasesGetExecutable_594092(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the `Release` executable to use when enforcing rules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the `Release`.
  ## 
  ## Format: `projects/{project_id}/releases/{release_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594094 = path.getOrDefault("name")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "name", valid_594094
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
  ##   executableVersion: JString
  ##                    : The requested runtime executable version.
  ## Defaults to FIREBASE_RULES_EXECUTABLE_V1.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594095 = query.getOrDefault("upload_protocol")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "upload_protocol", valid_594095
  var valid_594096 = query.getOrDefault("fields")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "fields", valid_594096
  var valid_594097 = query.getOrDefault("quotaUser")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "quotaUser", valid_594097
  var valid_594098 = query.getOrDefault("alt")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = newJString("json"))
  if valid_594098 != nil:
    section.add "alt", valid_594098
  var valid_594099 = query.getOrDefault("oauth_token")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "oauth_token", valid_594099
  var valid_594100 = query.getOrDefault("callback")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "callback", valid_594100
  var valid_594101 = query.getOrDefault("access_token")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "access_token", valid_594101
  var valid_594102 = query.getOrDefault("uploadType")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "uploadType", valid_594102
  var valid_594103 = query.getOrDefault("executableVersion")
  valid_594103 = validateParameter(valid_594103, JString, required = false, default = newJString(
      "RELEASE_EXECUTABLE_VERSION_UNSPECIFIED"))
  if valid_594103 != nil:
    section.add "executableVersion", valid_594103
  var valid_594104 = query.getOrDefault("key")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "key", valid_594104
  var valid_594105 = query.getOrDefault("$.xgafv")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = newJString("1"))
  if valid_594105 != nil:
    section.add "$.xgafv", valid_594105
  var valid_594106 = query.getOrDefault("prettyPrint")
  valid_594106 = validateParameter(valid_594106, JBool, required = false,
                                 default = newJBool(true))
  if valid_594106 != nil:
    section.add "prettyPrint", valid_594106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594107: Call_FirebaserulesProjectsReleasesGetExecutable_594091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the `Release` executable to use when enforcing rules.
  ## 
  let valid = call_594107.validator(path, query, header, formData, body)
  let scheme = call_594107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594107.url(scheme.get, call_594107.host, call_594107.base,
                         call_594107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594107, url, valid)

proc call*(call_594108: Call_FirebaserulesProjectsReleasesGetExecutable_594091;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          executableVersion: string = "RELEASE_EXECUTABLE_VERSION_UNSPECIFIED";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## firebaserulesProjectsReleasesGetExecutable
  ## Get the `Release` executable to use when enforcing rules.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the `Release`.
  ## 
  ## Format: `projects/{project_id}/releases/{release_id}`
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
  ##   executableVersion: string
  ##                    : The requested runtime executable version.
  ## Defaults to FIREBASE_RULES_EXECUTABLE_V1.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594109 = newJObject()
  var query_594110 = newJObject()
  add(query_594110, "upload_protocol", newJString(uploadProtocol))
  add(query_594110, "fields", newJString(fields))
  add(query_594110, "quotaUser", newJString(quotaUser))
  add(path_594109, "name", newJString(name))
  add(query_594110, "alt", newJString(alt))
  add(query_594110, "oauth_token", newJString(oauthToken))
  add(query_594110, "callback", newJString(callback))
  add(query_594110, "access_token", newJString(accessToken))
  add(query_594110, "uploadType", newJString(uploadType))
  add(query_594110, "executableVersion", newJString(executableVersion))
  add(query_594110, "key", newJString(key))
  add(query_594110, "$.xgafv", newJString(Xgafv))
  add(query_594110, "prettyPrint", newJBool(prettyPrint))
  result = call_594108.call(path_594109, query_594110, nil, nil, nil)

var firebaserulesProjectsReleasesGetExecutable* = Call_FirebaserulesProjectsReleasesGetExecutable_594091(
    name: "firebaserulesProjectsReleasesGetExecutable", meth: HttpMethod.HttpGet,
    host: "firebaserules.googleapis.com", route: "/v1/{name}:getExecutable",
    validator: validate_FirebaserulesProjectsReleasesGetExecutable_594092,
    base: "/", url: url_FirebaserulesProjectsReleasesGetExecutable_594093,
    schemes: {Scheme.Https})
type
  Call_FirebaserulesProjectsTest_594111 = ref object of OpenApiRestCall_593408
proc url_FirebaserulesProjectsTest_594113(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":test")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaserulesProjectsTest_594112(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Test `Source` for syntactic and semantic correctness. Issues present, if
  ## any, will be returned to the caller with a description, severity, and
  ## source location.
  ## 
  ## The test method may be executed with `Source` or a `Ruleset` name.
  ## Passing `Source` is useful for unit testing new rules. Passing a `Ruleset`
  ## name is useful for regression testing an existing rule.
  ## 
  ## The following is an example of `Source` that permits users to upload images
  ## to a bucket bearing their user id and matching the correct metadata:
  ## 
  ## _*Example*_
  ## 
  ##     // Users are allowed to subscribe and unsubscribe to the blog.
  ##     service firebase.storage {
  ##       match /users/{userId}/images/{imageName} {
  ##           allow write: if userId == request.auth.uid
  ##               && (imageName.matches('*.png$')
  ##               || imageName.matches('*.jpg$'))
  ##               && resource.mimeType.matches('^image/')
  ##       }
  ##     }
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Tests may either provide `source` or a `Ruleset` resource name.
  ## 
  ## For tests against `source`, the resource name must refer to the project:
  ## Format: `projects/{project_id}`
  ## 
  ## For tests against a `Ruleset`, this must be the `Ruleset` resource name:
  ## Format: `projects/{project_id}/rulesets/{ruleset_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594114 = path.getOrDefault("name")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "name", valid_594114
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
  var valid_594115 = query.getOrDefault("upload_protocol")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "upload_protocol", valid_594115
  var valid_594116 = query.getOrDefault("fields")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "fields", valid_594116
  var valid_594117 = query.getOrDefault("quotaUser")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "quotaUser", valid_594117
  var valid_594118 = query.getOrDefault("alt")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = newJString("json"))
  if valid_594118 != nil:
    section.add "alt", valid_594118
  var valid_594119 = query.getOrDefault("oauth_token")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "oauth_token", valid_594119
  var valid_594120 = query.getOrDefault("callback")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "callback", valid_594120
  var valid_594121 = query.getOrDefault("access_token")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "access_token", valid_594121
  var valid_594122 = query.getOrDefault("uploadType")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "uploadType", valid_594122
  var valid_594123 = query.getOrDefault("key")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "key", valid_594123
  var valid_594124 = query.getOrDefault("$.xgafv")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = newJString("1"))
  if valid_594124 != nil:
    section.add "$.xgafv", valid_594124
  var valid_594125 = query.getOrDefault("prettyPrint")
  valid_594125 = validateParameter(valid_594125, JBool, required = false,
                                 default = newJBool(true))
  if valid_594125 != nil:
    section.add "prettyPrint", valid_594125
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

proc call*(call_594127: Call_FirebaserulesProjectsTest_594111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Test `Source` for syntactic and semantic correctness. Issues present, if
  ## any, will be returned to the caller with a description, severity, and
  ## source location.
  ## 
  ## The test method may be executed with `Source` or a `Ruleset` name.
  ## Passing `Source` is useful for unit testing new rules. Passing a `Ruleset`
  ## name is useful for regression testing an existing rule.
  ## 
  ## The following is an example of `Source` that permits users to upload images
  ## to a bucket bearing their user id and matching the correct metadata:
  ## 
  ## _*Example*_
  ## 
  ##     // Users are allowed to subscribe and unsubscribe to the blog.
  ##     service firebase.storage {
  ##       match /users/{userId}/images/{imageName} {
  ##           allow write: if userId == request.auth.uid
  ##               && (imageName.matches('*.png$')
  ##               || imageName.matches('*.jpg$'))
  ##               && resource.mimeType.matches('^image/')
  ##       }
  ##     }
  ## 
  let valid = call_594127.validator(path, query, header, formData, body)
  let scheme = call_594127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594127.url(scheme.get, call_594127.host, call_594127.base,
                         call_594127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594127, url, valid)

proc call*(call_594128: Call_FirebaserulesProjectsTest_594111; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## firebaserulesProjectsTest
  ## Test `Source` for syntactic and semantic correctness. Issues present, if
  ## any, will be returned to the caller with a description, severity, and
  ## source location.
  ## 
  ## The test method may be executed with `Source` or a `Ruleset` name.
  ## Passing `Source` is useful for unit testing new rules. Passing a `Ruleset`
  ## name is useful for regression testing an existing rule.
  ## 
  ## The following is an example of `Source` that permits users to upload images
  ## to a bucket bearing their user id and matching the correct metadata:
  ## 
  ## _*Example*_
  ## 
  ##     // Users are allowed to subscribe and unsubscribe to the blog.
  ##     service firebase.storage {
  ##       match /users/{userId}/images/{imageName} {
  ##           allow write: if userId == request.auth.uid
  ##               && (imageName.matches('*.png$')
  ##               || imageName.matches('*.jpg$'))
  ##               && resource.mimeType.matches('^image/')
  ##       }
  ##     }
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Tests may either provide `source` or a `Ruleset` resource name.
  ## 
  ## For tests against `source`, the resource name must refer to the project:
  ## Format: `projects/{project_id}`
  ## 
  ## For tests against a `Ruleset`, this must be the `Ruleset` resource name:
  ## Format: `projects/{project_id}/rulesets/{ruleset_id}`
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
  var path_594129 = newJObject()
  var query_594130 = newJObject()
  var body_594131 = newJObject()
  add(query_594130, "upload_protocol", newJString(uploadProtocol))
  add(query_594130, "fields", newJString(fields))
  add(query_594130, "quotaUser", newJString(quotaUser))
  add(path_594129, "name", newJString(name))
  add(query_594130, "alt", newJString(alt))
  add(query_594130, "oauth_token", newJString(oauthToken))
  add(query_594130, "callback", newJString(callback))
  add(query_594130, "access_token", newJString(accessToken))
  add(query_594130, "uploadType", newJString(uploadType))
  add(query_594130, "key", newJString(key))
  add(query_594130, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594131 = body
  add(query_594130, "prettyPrint", newJBool(prettyPrint))
  result = call_594128.call(path_594129, query_594130, nil, nil, body_594131)

var firebaserulesProjectsTest* = Call_FirebaserulesProjectsTest_594111(
    name: "firebaserulesProjectsTest", meth: HttpMethod.HttpPost,
    host: "firebaserules.googleapis.com", route: "/v1/{name}:test",
    validator: validate_FirebaserulesProjectsTest_594112, base: "/",
    url: url_FirebaserulesProjectsTest_594113, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
