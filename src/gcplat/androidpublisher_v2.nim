
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Play Developer
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Accesses Android application developers' Google Play accounts.
## 
## https://developers.google.com/android-publisher
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  gcpServiceName = "androidpublisher"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidpublisherEditsInsert_588718 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsInsert_588720(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsInsert_588719(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new edit for an app, populated with the app's current state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_588846 = path.getOrDefault("packageName")
  valid_588846 = validateParameter(valid_588846, JString, required = true,
                                 default = nil)
  if valid_588846 != nil:
    section.add "packageName", valid_588846
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588847 = query.getOrDefault("fields")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = nil)
  if valid_588847 != nil:
    section.add "fields", valid_588847
  var valid_588848 = query.getOrDefault("quotaUser")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "quotaUser", valid_588848
  var valid_588862 = query.getOrDefault("alt")
  valid_588862 = validateParameter(valid_588862, JString, required = false,
                                 default = newJString("json"))
  if valid_588862 != nil:
    section.add "alt", valid_588862
  var valid_588863 = query.getOrDefault("oauth_token")
  valid_588863 = validateParameter(valid_588863, JString, required = false,
                                 default = nil)
  if valid_588863 != nil:
    section.add "oauth_token", valid_588863
  var valid_588864 = query.getOrDefault("userIp")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = nil)
  if valid_588864 != nil:
    section.add "userIp", valid_588864
  var valid_588865 = query.getOrDefault("key")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "key", valid_588865
  var valid_588866 = query.getOrDefault("prettyPrint")
  valid_588866 = validateParameter(valid_588866, JBool, required = false,
                                 default = newJBool(true))
  if valid_588866 != nil:
    section.add "prettyPrint", valid_588866
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

proc call*(call_588890: Call_AndroidpublisherEditsInsert_588718; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new edit for an app, populated with the app's current state.
  ## 
  let valid = call_588890.validator(path, query, header, formData, body)
  let scheme = call_588890.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588890.url(scheme.get, call_588890.host, call_588890.base,
                         call_588890.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588890, url, valid)

proc call*(call_588961: Call_AndroidpublisherEditsInsert_588718;
          packageName: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsInsert
  ## Creates a new edit for an app, populated with the app's current state.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_588962 = newJObject()
  var query_588964 = newJObject()
  var body_588965 = newJObject()
  add(query_588964, "fields", newJString(fields))
  add(path_588962, "packageName", newJString(packageName))
  add(query_588964, "quotaUser", newJString(quotaUser))
  add(query_588964, "alt", newJString(alt))
  add(query_588964, "oauth_token", newJString(oauthToken))
  add(query_588964, "userIp", newJString(userIp))
  add(query_588964, "key", newJString(key))
  if body != nil:
    body_588965 = body
  add(query_588964, "prettyPrint", newJBool(prettyPrint))
  result = call_588961.call(path_588962, query_588964, nil, nil, body_588965)

var androidpublisherEditsInsert* = Call_AndroidpublisherEditsInsert_588718(
    name: "androidpublisherEditsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits",
    validator: validate_AndroidpublisherEditsInsert_588719,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsInsert_588720, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsGet_589004 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsGet_589006(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsGet_589005(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns information about the edit specified. Calls will fail if the edit is no long active (e.g. has been deleted, superseded or expired).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589007 = path.getOrDefault("packageName")
  valid_589007 = validateParameter(valid_589007, JString, required = true,
                                 default = nil)
  if valid_589007 != nil:
    section.add "packageName", valid_589007
  var valid_589008 = path.getOrDefault("editId")
  valid_589008 = validateParameter(valid_589008, JString, required = true,
                                 default = nil)
  if valid_589008 != nil:
    section.add "editId", valid_589008
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
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
  var valid_589013 = query.getOrDefault("userIp")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "userIp", valid_589013
  var valid_589014 = query.getOrDefault("key")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "key", valid_589014
  var valid_589015 = query.getOrDefault("prettyPrint")
  valid_589015 = validateParameter(valid_589015, JBool, required = false,
                                 default = newJBool(true))
  if valid_589015 != nil:
    section.add "prettyPrint", valid_589015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589016: Call_AndroidpublisherEditsGet_589004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the edit specified. Calls will fail if the edit is no long active (e.g. has been deleted, superseded or expired).
  ## 
  let valid = call_589016.validator(path, query, header, formData, body)
  let scheme = call_589016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589016.url(scheme.get, call_589016.host, call_589016.base,
                         call_589016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589016, url, valid)

proc call*(call_589017: Call_AndroidpublisherEditsGet_589004; packageName: string;
          editId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsGet
  ## Returns information about the edit specified. Calls will fail if the edit is no long active (e.g. has been deleted, superseded or expired).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589018 = newJObject()
  var query_589019 = newJObject()
  add(query_589019, "fields", newJString(fields))
  add(path_589018, "packageName", newJString(packageName))
  add(query_589019, "quotaUser", newJString(quotaUser))
  add(query_589019, "alt", newJString(alt))
  add(path_589018, "editId", newJString(editId))
  add(query_589019, "oauth_token", newJString(oauthToken))
  add(query_589019, "userIp", newJString(userIp))
  add(query_589019, "key", newJString(key))
  add(query_589019, "prettyPrint", newJBool(prettyPrint))
  result = call_589017.call(path_589018, query_589019, nil, nil, nil)

var androidpublisherEditsGet* = Call_AndroidpublisherEditsGet_589004(
    name: "androidpublisherEditsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}",
    validator: validate_AndroidpublisherEditsGet_589005,
    base: "/androidpublisher/v2/applications", url: url_AndroidpublisherEditsGet_589006,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDelete_589020 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsDelete_589022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsDelete_589021(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an edit for an app. Creating a new edit will automatically delete any of your previous edits so this method need only be called if you want to preemptively abandon an edit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589023 = path.getOrDefault("packageName")
  valid_589023 = validateParameter(valid_589023, JString, required = true,
                                 default = nil)
  if valid_589023 != nil:
    section.add "packageName", valid_589023
  var valid_589024 = path.getOrDefault("editId")
  valid_589024 = validateParameter(valid_589024, JString, required = true,
                                 default = nil)
  if valid_589024 != nil:
    section.add "editId", valid_589024
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589025 = query.getOrDefault("fields")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "fields", valid_589025
  var valid_589026 = query.getOrDefault("quotaUser")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "quotaUser", valid_589026
  var valid_589027 = query.getOrDefault("alt")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = newJString("json"))
  if valid_589027 != nil:
    section.add "alt", valid_589027
  var valid_589028 = query.getOrDefault("oauth_token")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "oauth_token", valid_589028
  var valid_589029 = query.getOrDefault("userIp")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "userIp", valid_589029
  var valid_589030 = query.getOrDefault("key")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "key", valid_589030
  var valid_589031 = query.getOrDefault("prettyPrint")
  valid_589031 = validateParameter(valid_589031, JBool, required = false,
                                 default = newJBool(true))
  if valid_589031 != nil:
    section.add "prettyPrint", valid_589031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589032: Call_AndroidpublisherEditsDelete_589020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an edit for an app. Creating a new edit will automatically delete any of your previous edits so this method need only be called if you want to preemptively abandon an edit.
  ## 
  let valid = call_589032.validator(path, query, header, formData, body)
  let scheme = call_589032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589032.url(scheme.get, call_589032.host, call_589032.base,
                         call_589032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589032, url, valid)

proc call*(call_589033: Call_AndroidpublisherEditsDelete_589020;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsDelete
  ## Deletes an edit for an app. Creating a new edit will automatically delete any of your previous edits so this method need only be called if you want to preemptively abandon an edit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589034 = newJObject()
  var query_589035 = newJObject()
  add(query_589035, "fields", newJString(fields))
  add(path_589034, "packageName", newJString(packageName))
  add(query_589035, "quotaUser", newJString(quotaUser))
  add(query_589035, "alt", newJString(alt))
  add(path_589034, "editId", newJString(editId))
  add(query_589035, "oauth_token", newJString(oauthToken))
  add(query_589035, "userIp", newJString(userIp))
  add(query_589035, "key", newJString(key))
  add(query_589035, "prettyPrint", newJBool(prettyPrint))
  result = call_589033.call(path_589034, query_589035, nil, nil, nil)

var androidpublisherEditsDelete* = Call_AndroidpublisherEditsDelete_589020(
    name: "androidpublisherEditsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}",
    validator: validate_AndroidpublisherEditsDelete_589021,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDelete_589022, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksUpload_589052 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsApksUpload_589054(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApksUpload_589053(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589055 = path.getOrDefault("packageName")
  valid_589055 = validateParameter(valid_589055, JString, required = true,
                                 default = nil)
  if valid_589055 != nil:
    section.add "packageName", valid_589055
  var valid_589056 = path.getOrDefault("editId")
  valid_589056 = validateParameter(valid_589056, JString, required = true,
                                 default = nil)
  if valid_589056 != nil:
    section.add "editId", valid_589056
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589057 = query.getOrDefault("fields")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "fields", valid_589057
  var valid_589058 = query.getOrDefault("quotaUser")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "quotaUser", valid_589058
  var valid_589059 = query.getOrDefault("alt")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = newJString("json"))
  if valid_589059 != nil:
    section.add "alt", valid_589059
  var valid_589060 = query.getOrDefault("oauth_token")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "oauth_token", valid_589060
  var valid_589061 = query.getOrDefault("userIp")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "userIp", valid_589061
  var valid_589062 = query.getOrDefault("key")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "key", valid_589062
  var valid_589063 = query.getOrDefault("prettyPrint")
  valid_589063 = validateParameter(valid_589063, JBool, required = false,
                                 default = newJBool(true))
  if valid_589063 != nil:
    section.add "prettyPrint", valid_589063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589064: Call_AndroidpublisherEditsApksUpload_589052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_589064.validator(path, query, header, formData, body)
  let scheme = call_589064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589064.url(scheme.get, call_589064.host, call_589064.base,
                         call_589064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589064, url, valid)

proc call*(call_589065: Call_AndroidpublisherEditsApksUpload_589052;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsApksUpload
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589066 = newJObject()
  var query_589067 = newJObject()
  add(query_589067, "fields", newJString(fields))
  add(path_589066, "packageName", newJString(packageName))
  add(query_589067, "quotaUser", newJString(quotaUser))
  add(query_589067, "alt", newJString(alt))
  add(path_589066, "editId", newJString(editId))
  add(query_589067, "oauth_token", newJString(oauthToken))
  add(query_589067, "userIp", newJString(userIp))
  add(query_589067, "key", newJString(key))
  add(query_589067, "prettyPrint", newJBool(prettyPrint))
  result = call_589065.call(path_589066, query_589067, nil, nil, nil)

var androidpublisherEditsApksUpload* = Call_AndroidpublisherEditsApksUpload_589052(
    name: "androidpublisherEditsApksUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks",
    validator: validate_AndroidpublisherEditsApksUpload_589053,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApksUpload_589054, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksList_589036 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsApksList_589038(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApksList_589037(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589039 = path.getOrDefault("packageName")
  valid_589039 = validateParameter(valid_589039, JString, required = true,
                                 default = nil)
  if valid_589039 != nil:
    section.add "packageName", valid_589039
  var valid_589040 = path.getOrDefault("editId")
  valid_589040 = validateParameter(valid_589040, JString, required = true,
                                 default = nil)
  if valid_589040 != nil:
    section.add "editId", valid_589040
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589041 = query.getOrDefault("fields")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "fields", valid_589041
  var valid_589042 = query.getOrDefault("quotaUser")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "quotaUser", valid_589042
  var valid_589043 = query.getOrDefault("alt")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = newJString("json"))
  if valid_589043 != nil:
    section.add "alt", valid_589043
  var valid_589044 = query.getOrDefault("oauth_token")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "oauth_token", valid_589044
  var valid_589045 = query.getOrDefault("userIp")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "userIp", valid_589045
  var valid_589046 = query.getOrDefault("key")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "key", valid_589046
  var valid_589047 = query.getOrDefault("prettyPrint")
  valid_589047 = validateParameter(valid_589047, JBool, required = false,
                                 default = newJBool(true))
  if valid_589047 != nil:
    section.add "prettyPrint", valid_589047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589048: Call_AndroidpublisherEditsApksList_589036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_589048.validator(path, query, header, formData, body)
  let scheme = call_589048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589048.url(scheme.get, call_589048.host, call_589048.base,
                         call_589048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589048, url, valid)

proc call*(call_589049: Call_AndroidpublisherEditsApksList_589036;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsApksList
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589050 = newJObject()
  var query_589051 = newJObject()
  add(query_589051, "fields", newJString(fields))
  add(path_589050, "packageName", newJString(packageName))
  add(query_589051, "quotaUser", newJString(quotaUser))
  add(query_589051, "alt", newJString(alt))
  add(path_589050, "editId", newJString(editId))
  add(query_589051, "oauth_token", newJString(oauthToken))
  add(query_589051, "userIp", newJString(userIp))
  add(query_589051, "key", newJString(key))
  add(query_589051, "prettyPrint", newJBool(prettyPrint))
  result = call_589049.call(path_589050, query_589051, nil, nil, nil)

var androidpublisherEditsApksList* = Call_AndroidpublisherEditsApksList_589036(
    name: "androidpublisherEditsApksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks",
    validator: validate_AndroidpublisherEditsApksList_589037,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApksList_589038, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksAddexternallyhosted_589068 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsApksAddexternallyhosted_589070(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/externallyHosted")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApksAddexternallyhosted_589069(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new APK without uploading the APK itself to Google Play, instead hosting the APK at a specified URL. This function is only available to enterprises using Google Play for Work whose application is configured to restrict distribution to the enterprise domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589071 = path.getOrDefault("packageName")
  valid_589071 = validateParameter(valid_589071, JString, required = true,
                                 default = nil)
  if valid_589071 != nil:
    section.add "packageName", valid_589071
  var valid_589072 = path.getOrDefault("editId")
  valid_589072 = validateParameter(valid_589072, JString, required = true,
                                 default = nil)
  if valid_589072 != nil:
    section.add "editId", valid_589072
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589073 = query.getOrDefault("fields")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "fields", valid_589073
  var valid_589074 = query.getOrDefault("quotaUser")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "quotaUser", valid_589074
  var valid_589075 = query.getOrDefault("alt")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("json"))
  if valid_589075 != nil:
    section.add "alt", valid_589075
  var valid_589076 = query.getOrDefault("oauth_token")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "oauth_token", valid_589076
  var valid_589077 = query.getOrDefault("userIp")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "userIp", valid_589077
  var valid_589078 = query.getOrDefault("key")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "key", valid_589078
  var valid_589079 = query.getOrDefault("prettyPrint")
  valid_589079 = validateParameter(valid_589079, JBool, required = false,
                                 default = newJBool(true))
  if valid_589079 != nil:
    section.add "prettyPrint", valid_589079
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

proc call*(call_589081: Call_AndroidpublisherEditsApksAddexternallyhosted_589068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new APK without uploading the APK itself to Google Play, instead hosting the APK at a specified URL. This function is only available to enterprises using Google Play for Work whose application is configured to restrict distribution to the enterprise domain.
  ## 
  let valid = call_589081.validator(path, query, header, formData, body)
  let scheme = call_589081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589081.url(scheme.get, call_589081.host, call_589081.base,
                         call_589081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589081, url, valid)

proc call*(call_589082: Call_AndroidpublisherEditsApksAddexternallyhosted_589068;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsApksAddexternallyhosted
  ## Creates a new APK without uploading the APK itself to Google Play, instead hosting the APK at a specified URL. This function is only available to enterprises using Google Play for Work whose application is configured to restrict distribution to the enterprise domain.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589083 = newJObject()
  var query_589084 = newJObject()
  var body_589085 = newJObject()
  add(query_589084, "fields", newJString(fields))
  add(path_589083, "packageName", newJString(packageName))
  add(query_589084, "quotaUser", newJString(quotaUser))
  add(query_589084, "alt", newJString(alt))
  add(path_589083, "editId", newJString(editId))
  add(query_589084, "oauth_token", newJString(oauthToken))
  add(query_589084, "userIp", newJString(userIp))
  add(query_589084, "key", newJString(key))
  if body != nil:
    body_589085 = body
  add(query_589084, "prettyPrint", newJBool(prettyPrint))
  result = call_589082.call(path_589083, query_589084, nil, nil, body_589085)

var androidpublisherEditsApksAddexternallyhosted* = Call_AndroidpublisherEditsApksAddexternallyhosted_589068(
    name: "androidpublisherEditsApksAddexternallyhosted",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/apks/externallyHosted",
    validator: validate_AndroidpublisherEditsApksAddexternallyhosted_589069,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApksAddexternallyhosted_589070,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDeobfuscationfilesUpload_589086 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsDeobfuscationfilesUpload_589088(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "deobfuscationFileType" in path,
        "`deobfuscationFileType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/deobfuscationFiles/"),
               (kind: VariableSegment, value: "deobfuscationFileType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsDeobfuscationfilesUpload_589087(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Uploads the deobfuscation file of the specified APK. If a deobfuscation file already exists, it will be replaced.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier of the Android app for which the deobfuscatiuon files are being uploaded; for example, "com.spiffygame".
  ##   deobfuscationFileType: JString (required)
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   apkVersionCode: JInt (required)
  ##                 : The version code of the APK whose deobfuscation file is being uploaded.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589089 = path.getOrDefault("packageName")
  valid_589089 = validateParameter(valid_589089, JString, required = true,
                                 default = nil)
  if valid_589089 != nil:
    section.add "packageName", valid_589089
  var valid_589090 = path.getOrDefault("deobfuscationFileType")
  valid_589090 = validateParameter(valid_589090, JString, required = true,
                                 default = newJString("proguard"))
  if valid_589090 != nil:
    section.add "deobfuscationFileType", valid_589090
  var valid_589091 = path.getOrDefault("editId")
  valid_589091 = validateParameter(valid_589091, JString, required = true,
                                 default = nil)
  if valid_589091 != nil:
    section.add "editId", valid_589091
  var valid_589092 = path.getOrDefault("apkVersionCode")
  valid_589092 = validateParameter(valid_589092, JInt, required = true, default = nil)
  if valid_589092 != nil:
    section.add "apkVersionCode", valid_589092
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589093 = query.getOrDefault("fields")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "fields", valid_589093
  var valid_589094 = query.getOrDefault("quotaUser")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "quotaUser", valid_589094
  var valid_589095 = query.getOrDefault("alt")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = newJString("json"))
  if valid_589095 != nil:
    section.add "alt", valid_589095
  var valid_589096 = query.getOrDefault("oauth_token")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "oauth_token", valid_589096
  var valid_589097 = query.getOrDefault("userIp")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "userIp", valid_589097
  var valid_589098 = query.getOrDefault("key")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "key", valid_589098
  var valid_589099 = query.getOrDefault("prettyPrint")
  valid_589099 = validateParameter(valid_589099, JBool, required = false,
                                 default = newJBool(true))
  if valid_589099 != nil:
    section.add "prettyPrint", valid_589099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589100: Call_AndroidpublisherEditsDeobfuscationfilesUpload_589086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads the deobfuscation file of the specified APK. If a deobfuscation file already exists, it will be replaced.
  ## 
  let valid = call_589100.validator(path, query, header, formData, body)
  let scheme = call_589100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589100.url(scheme.get, call_589100.host, call_589100.base,
                         call_589100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589100, url, valid)

proc call*(call_589101: Call_AndroidpublisherEditsDeobfuscationfilesUpload_589086;
          packageName: string; editId: string; apkVersionCode: int;
          fields: string = ""; quotaUser: string = "";
          deobfuscationFileType: string = "proguard"; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsDeobfuscationfilesUpload
  ## Uploads the deobfuscation file of the specified APK. If a deobfuscation file already exists, it will be replaced.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier of the Android app for which the deobfuscatiuon files are being uploaded; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   deobfuscationFileType: string (required)
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   apkVersionCode: int (required)
  ##                 : The version code of the APK whose deobfuscation file is being uploaded.
  var path_589102 = newJObject()
  var query_589103 = newJObject()
  add(query_589103, "fields", newJString(fields))
  add(path_589102, "packageName", newJString(packageName))
  add(query_589103, "quotaUser", newJString(quotaUser))
  add(path_589102, "deobfuscationFileType", newJString(deobfuscationFileType))
  add(query_589103, "alt", newJString(alt))
  add(path_589102, "editId", newJString(editId))
  add(query_589103, "oauth_token", newJString(oauthToken))
  add(query_589103, "userIp", newJString(userIp))
  add(query_589103, "key", newJString(key))
  add(query_589103, "prettyPrint", newJBool(prettyPrint))
  add(path_589102, "apkVersionCode", newJInt(apkVersionCode))
  result = call_589101.call(path_589102, query_589103, nil, nil, nil)

var androidpublisherEditsDeobfuscationfilesUpload* = Call_AndroidpublisherEditsDeobfuscationfilesUpload_589086(
    name: "androidpublisherEditsDeobfuscationfilesUpload",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/deobfuscationFiles/{deobfuscationFileType}",
    validator: validate_AndroidpublisherEditsDeobfuscationfilesUpload_589087,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDeobfuscationfilesUpload_589088,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesUpdate_589122 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsExpansionfilesUpdate_589124(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "expansionFileType" in path,
        "`expansionFileType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/expansionFiles/"),
               (kind: VariableSegment, value: "expansionFileType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsExpansionfilesUpdate_589123(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   expansionFileType: JString (required)
  ##   apkVersionCode: JInt (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589125 = path.getOrDefault("packageName")
  valid_589125 = validateParameter(valid_589125, JString, required = true,
                                 default = nil)
  if valid_589125 != nil:
    section.add "packageName", valid_589125
  var valid_589126 = path.getOrDefault("editId")
  valid_589126 = validateParameter(valid_589126, JString, required = true,
                                 default = nil)
  if valid_589126 != nil:
    section.add "editId", valid_589126
  var valid_589127 = path.getOrDefault("expansionFileType")
  valid_589127 = validateParameter(valid_589127, JString, required = true,
                                 default = newJString("main"))
  if valid_589127 != nil:
    section.add "expansionFileType", valid_589127
  var valid_589128 = path.getOrDefault("apkVersionCode")
  valid_589128 = validateParameter(valid_589128, JInt, required = true, default = nil)
  if valid_589128 != nil:
    section.add "apkVersionCode", valid_589128
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589129 = query.getOrDefault("fields")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "fields", valid_589129
  var valid_589130 = query.getOrDefault("quotaUser")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "quotaUser", valid_589130
  var valid_589131 = query.getOrDefault("alt")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = newJString("json"))
  if valid_589131 != nil:
    section.add "alt", valid_589131
  var valid_589132 = query.getOrDefault("oauth_token")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "oauth_token", valid_589132
  var valid_589133 = query.getOrDefault("userIp")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "userIp", valid_589133
  var valid_589134 = query.getOrDefault("key")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "key", valid_589134
  var valid_589135 = query.getOrDefault("prettyPrint")
  valid_589135 = validateParameter(valid_589135, JBool, required = false,
                                 default = newJBool(true))
  if valid_589135 != nil:
    section.add "prettyPrint", valid_589135
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

proc call*(call_589137: Call_AndroidpublisherEditsExpansionfilesUpdate_589122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method.
  ## 
  let valid = call_589137.validator(path, query, header, formData, body)
  let scheme = call_589137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589137.url(scheme.get, call_589137.host, call_589137.base,
                         call_589137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589137, url, valid)

proc call*(call_589138: Call_AndroidpublisherEditsExpansionfilesUpdate_589122;
          packageName: string; editId: string; apkVersionCode: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          expansionFileType: string = "main"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsExpansionfilesUpdate
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   expansionFileType: string (required)
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   apkVersionCode: int (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  var path_589139 = newJObject()
  var query_589140 = newJObject()
  var body_589141 = newJObject()
  add(query_589140, "fields", newJString(fields))
  add(path_589139, "packageName", newJString(packageName))
  add(query_589140, "quotaUser", newJString(quotaUser))
  add(query_589140, "alt", newJString(alt))
  add(path_589139, "editId", newJString(editId))
  add(query_589140, "oauth_token", newJString(oauthToken))
  add(query_589140, "userIp", newJString(userIp))
  add(query_589140, "key", newJString(key))
  add(path_589139, "expansionFileType", newJString(expansionFileType))
  if body != nil:
    body_589141 = body
  add(query_589140, "prettyPrint", newJBool(prettyPrint))
  add(path_589139, "apkVersionCode", newJInt(apkVersionCode))
  result = call_589138.call(path_589139, query_589140, nil, nil, body_589141)

var androidpublisherEditsExpansionfilesUpdate* = Call_AndroidpublisherEditsExpansionfilesUpdate_589122(
    name: "androidpublisherEditsExpansionfilesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesUpdate_589123,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsExpansionfilesUpdate_589124,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesUpload_589142 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsExpansionfilesUpload_589144(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "expansionFileType" in path,
        "`expansionFileType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/expansionFiles/"),
               (kind: VariableSegment, value: "expansionFileType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsExpansionfilesUpload_589143(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads and attaches a new Expansion File to the APK specified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   expansionFileType: JString (required)
  ##   apkVersionCode: JInt (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589145 = path.getOrDefault("packageName")
  valid_589145 = validateParameter(valid_589145, JString, required = true,
                                 default = nil)
  if valid_589145 != nil:
    section.add "packageName", valid_589145
  var valid_589146 = path.getOrDefault("editId")
  valid_589146 = validateParameter(valid_589146, JString, required = true,
                                 default = nil)
  if valid_589146 != nil:
    section.add "editId", valid_589146
  var valid_589147 = path.getOrDefault("expansionFileType")
  valid_589147 = validateParameter(valid_589147, JString, required = true,
                                 default = newJString("main"))
  if valid_589147 != nil:
    section.add "expansionFileType", valid_589147
  var valid_589148 = path.getOrDefault("apkVersionCode")
  valid_589148 = validateParameter(valid_589148, JInt, required = true, default = nil)
  if valid_589148 != nil:
    section.add "apkVersionCode", valid_589148
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589149 = query.getOrDefault("fields")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "fields", valid_589149
  var valid_589150 = query.getOrDefault("quotaUser")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "quotaUser", valid_589150
  var valid_589151 = query.getOrDefault("alt")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = newJString("json"))
  if valid_589151 != nil:
    section.add "alt", valid_589151
  var valid_589152 = query.getOrDefault("oauth_token")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "oauth_token", valid_589152
  var valid_589153 = query.getOrDefault("userIp")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "userIp", valid_589153
  var valid_589154 = query.getOrDefault("key")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "key", valid_589154
  var valid_589155 = query.getOrDefault("prettyPrint")
  valid_589155 = validateParameter(valid_589155, JBool, required = false,
                                 default = newJBool(true))
  if valid_589155 != nil:
    section.add "prettyPrint", valid_589155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589156: Call_AndroidpublisherEditsExpansionfilesUpload_589142;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads and attaches a new Expansion File to the APK specified.
  ## 
  let valid = call_589156.validator(path, query, header, formData, body)
  let scheme = call_589156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589156.url(scheme.get, call_589156.host, call_589156.base,
                         call_589156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589156, url, valid)

proc call*(call_589157: Call_AndroidpublisherEditsExpansionfilesUpload_589142;
          packageName: string; editId: string; apkVersionCode: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          expansionFileType: string = "main"; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsExpansionfilesUpload
  ## Uploads and attaches a new Expansion File to the APK specified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   expansionFileType: string (required)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   apkVersionCode: int (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  var path_589158 = newJObject()
  var query_589159 = newJObject()
  add(query_589159, "fields", newJString(fields))
  add(path_589158, "packageName", newJString(packageName))
  add(query_589159, "quotaUser", newJString(quotaUser))
  add(query_589159, "alt", newJString(alt))
  add(path_589158, "editId", newJString(editId))
  add(query_589159, "oauth_token", newJString(oauthToken))
  add(query_589159, "userIp", newJString(userIp))
  add(query_589159, "key", newJString(key))
  add(path_589158, "expansionFileType", newJString(expansionFileType))
  add(query_589159, "prettyPrint", newJBool(prettyPrint))
  add(path_589158, "apkVersionCode", newJInt(apkVersionCode))
  result = call_589157.call(path_589158, query_589159, nil, nil, nil)

var androidpublisherEditsExpansionfilesUpload* = Call_AndroidpublisherEditsExpansionfilesUpload_589142(
    name: "androidpublisherEditsExpansionfilesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesUpload_589143,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsExpansionfilesUpload_589144,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesGet_589104 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsExpansionfilesGet_589106(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "expansionFileType" in path,
        "`expansionFileType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/expansionFiles/"),
               (kind: VariableSegment, value: "expansionFileType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsExpansionfilesGet_589105(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the Expansion File configuration for the APK specified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   expansionFileType: JString (required)
  ##   apkVersionCode: JInt (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589107 = path.getOrDefault("packageName")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "packageName", valid_589107
  var valid_589108 = path.getOrDefault("editId")
  valid_589108 = validateParameter(valid_589108, JString, required = true,
                                 default = nil)
  if valid_589108 != nil:
    section.add "editId", valid_589108
  var valid_589109 = path.getOrDefault("expansionFileType")
  valid_589109 = validateParameter(valid_589109, JString, required = true,
                                 default = newJString("main"))
  if valid_589109 != nil:
    section.add "expansionFileType", valid_589109
  var valid_589110 = path.getOrDefault("apkVersionCode")
  valid_589110 = validateParameter(valid_589110, JInt, required = true, default = nil)
  if valid_589110 != nil:
    section.add "apkVersionCode", valid_589110
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589111 = query.getOrDefault("fields")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "fields", valid_589111
  var valid_589112 = query.getOrDefault("quotaUser")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "quotaUser", valid_589112
  var valid_589113 = query.getOrDefault("alt")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = newJString("json"))
  if valid_589113 != nil:
    section.add "alt", valid_589113
  var valid_589114 = query.getOrDefault("oauth_token")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "oauth_token", valid_589114
  var valid_589115 = query.getOrDefault("userIp")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "userIp", valid_589115
  var valid_589116 = query.getOrDefault("key")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "key", valid_589116
  var valid_589117 = query.getOrDefault("prettyPrint")
  valid_589117 = validateParameter(valid_589117, JBool, required = false,
                                 default = newJBool(true))
  if valid_589117 != nil:
    section.add "prettyPrint", valid_589117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589118: Call_AndroidpublisherEditsExpansionfilesGet_589104;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the Expansion File configuration for the APK specified.
  ## 
  let valid = call_589118.validator(path, query, header, formData, body)
  let scheme = call_589118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589118.url(scheme.get, call_589118.host, call_589118.base,
                         call_589118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589118, url, valid)

proc call*(call_589119: Call_AndroidpublisherEditsExpansionfilesGet_589104;
          packageName: string; editId: string; apkVersionCode: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          expansionFileType: string = "main"; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsExpansionfilesGet
  ## Fetches the Expansion File configuration for the APK specified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   expansionFileType: string (required)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   apkVersionCode: int (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  var path_589120 = newJObject()
  var query_589121 = newJObject()
  add(query_589121, "fields", newJString(fields))
  add(path_589120, "packageName", newJString(packageName))
  add(query_589121, "quotaUser", newJString(quotaUser))
  add(query_589121, "alt", newJString(alt))
  add(path_589120, "editId", newJString(editId))
  add(query_589121, "oauth_token", newJString(oauthToken))
  add(query_589121, "userIp", newJString(userIp))
  add(query_589121, "key", newJString(key))
  add(path_589120, "expansionFileType", newJString(expansionFileType))
  add(query_589121, "prettyPrint", newJBool(prettyPrint))
  add(path_589120, "apkVersionCode", newJInt(apkVersionCode))
  result = call_589119.call(path_589120, query_589121, nil, nil, nil)

var androidpublisherEditsExpansionfilesGet* = Call_AndroidpublisherEditsExpansionfilesGet_589104(
    name: "androidpublisherEditsExpansionfilesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesGet_589105,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsExpansionfilesGet_589106,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesPatch_589160 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsExpansionfilesPatch_589162(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "expansionFileType" in path,
        "`expansionFileType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/expansionFiles/"),
               (kind: VariableSegment, value: "expansionFileType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsExpansionfilesPatch_589161(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   expansionFileType: JString (required)
  ##   apkVersionCode: JInt (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589163 = path.getOrDefault("packageName")
  valid_589163 = validateParameter(valid_589163, JString, required = true,
                                 default = nil)
  if valid_589163 != nil:
    section.add "packageName", valid_589163
  var valid_589164 = path.getOrDefault("editId")
  valid_589164 = validateParameter(valid_589164, JString, required = true,
                                 default = nil)
  if valid_589164 != nil:
    section.add "editId", valid_589164
  var valid_589165 = path.getOrDefault("expansionFileType")
  valid_589165 = validateParameter(valid_589165, JString, required = true,
                                 default = newJString("main"))
  if valid_589165 != nil:
    section.add "expansionFileType", valid_589165
  var valid_589166 = path.getOrDefault("apkVersionCode")
  valid_589166 = validateParameter(valid_589166, JInt, required = true, default = nil)
  if valid_589166 != nil:
    section.add "apkVersionCode", valid_589166
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589167 = query.getOrDefault("fields")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "fields", valid_589167
  var valid_589168 = query.getOrDefault("quotaUser")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "quotaUser", valid_589168
  var valid_589169 = query.getOrDefault("alt")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = newJString("json"))
  if valid_589169 != nil:
    section.add "alt", valid_589169
  var valid_589170 = query.getOrDefault("oauth_token")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "oauth_token", valid_589170
  var valid_589171 = query.getOrDefault("userIp")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "userIp", valid_589171
  var valid_589172 = query.getOrDefault("key")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "key", valid_589172
  var valid_589173 = query.getOrDefault("prettyPrint")
  valid_589173 = validateParameter(valid_589173, JBool, required = false,
                                 default = newJBool(true))
  if valid_589173 != nil:
    section.add "prettyPrint", valid_589173
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

proc call*(call_589175: Call_AndroidpublisherEditsExpansionfilesPatch_589160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method. This method supports patch semantics.
  ## 
  let valid = call_589175.validator(path, query, header, formData, body)
  let scheme = call_589175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589175.url(scheme.get, call_589175.host, call_589175.base,
                         call_589175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589175, url, valid)

proc call*(call_589176: Call_AndroidpublisherEditsExpansionfilesPatch_589160;
          packageName: string; editId: string; apkVersionCode: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          expansionFileType: string = "main"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsExpansionfilesPatch
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   expansionFileType: string (required)
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   apkVersionCode: int (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  var path_589177 = newJObject()
  var query_589178 = newJObject()
  var body_589179 = newJObject()
  add(query_589178, "fields", newJString(fields))
  add(path_589177, "packageName", newJString(packageName))
  add(query_589178, "quotaUser", newJString(quotaUser))
  add(query_589178, "alt", newJString(alt))
  add(path_589177, "editId", newJString(editId))
  add(query_589178, "oauth_token", newJString(oauthToken))
  add(query_589178, "userIp", newJString(userIp))
  add(query_589178, "key", newJString(key))
  add(path_589177, "expansionFileType", newJString(expansionFileType))
  if body != nil:
    body_589179 = body
  add(query_589178, "prettyPrint", newJBool(prettyPrint))
  add(path_589177, "apkVersionCode", newJInt(apkVersionCode))
  result = call_589176.call(path_589177, query_589178, nil, nil, body_589179)

var androidpublisherEditsExpansionfilesPatch* = Call_AndroidpublisherEditsExpansionfilesPatch_589160(
    name: "androidpublisherEditsExpansionfilesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesPatch_589161,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsExpansionfilesPatch_589162,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsList_589180 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsApklistingsList_589182(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/listings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApklistingsList_589181(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the APK-specific localized listings for a specified APK.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   apkVersionCode: JInt (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589183 = path.getOrDefault("packageName")
  valid_589183 = validateParameter(valid_589183, JString, required = true,
                                 default = nil)
  if valid_589183 != nil:
    section.add "packageName", valid_589183
  var valid_589184 = path.getOrDefault("editId")
  valid_589184 = validateParameter(valid_589184, JString, required = true,
                                 default = nil)
  if valid_589184 != nil:
    section.add "editId", valid_589184
  var valid_589185 = path.getOrDefault("apkVersionCode")
  valid_589185 = validateParameter(valid_589185, JInt, required = true, default = nil)
  if valid_589185 != nil:
    section.add "apkVersionCode", valid_589185
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589186 = query.getOrDefault("fields")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "fields", valid_589186
  var valid_589187 = query.getOrDefault("quotaUser")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "quotaUser", valid_589187
  var valid_589188 = query.getOrDefault("alt")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = newJString("json"))
  if valid_589188 != nil:
    section.add "alt", valid_589188
  var valid_589189 = query.getOrDefault("oauth_token")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "oauth_token", valid_589189
  var valid_589190 = query.getOrDefault("userIp")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "userIp", valid_589190
  var valid_589191 = query.getOrDefault("key")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "key", valid_589191
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
  if body != nil:
    result.add "body", body

proc call*(call_589193: Call_AndroidpublisherEditsApklistingsList_589180;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the APK-specific localized listings for a specified APK.
  ## 
  let valid = call_589193.validator(path, query, header, formData, body)
  let scheme = call_589193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589193.url(scheme.get, call_589193.host, call_589193.base,
                         call_589193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589193, url, valid)

proc call*(call_589194: Call_AndroidpublisherEditsApklistingsList_589180;
          packageName: string; editId: string; apkVersionCode: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsApklistingsList
  ## Lists all the APK-specific localized listings for a specified APK.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   apkVersionCode: int (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  var path_589195 = newJObject()
  var query_589196 = newJObject()
  add(query_589196, "fields", newJString(fields))
  add(path_589195, "packageName", newJString(packageName))
  add(query_589196, "quotaUser", newJString(quotaUser))
  add(query_589196, "alt", newJString(alt))
  add(path_589195, "editId", newJString(editId))
  add(query_589196, "oauth_token", newJString(oauthToken))
  add(query_589196, "userIp", newJString(userIp))
  add(query_589196, "key", newJString(key))
  add(query_589196, "prettyPrint", newJBool(prettyPrint))
  add(path_589195, "apkVersionCode", newJInt(apkVersionCode))
  result = call_589194.call(path_589195, query_589196, nil, nil, nil)

var androidpublisherEditsApklistingsList* = Call_AndroidpublisherEditsApklistingsList_589180(
    name: "androidpublisherEditsApklistingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings",
    validator: validate_AndroidpublisherEditsApklistingsList_589181,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsList_589182, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsDeleteall_589197 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsApklistingsDeleteall_589199(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/listings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApklistingsDeleteall_589198(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes all the APK-specific localized listings for a specified APK.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   apkVersionCode: JInt (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589200 = path.getOrDefault("packageName")
  valid_589200 = validateParameter(valid_589200, JString, required = true,
                                 default = nil)
  if valid_589200 != nil:
    section.add "packageName", valid_589200
  var valid_589201 = path.getOrDefault("editId")
  valid_589201 = validateParameter(valid_589201, JString, required = true,
                                 default = nil)
  if valid_589201 != nil:
    section.add "editId", valid_589201
  var valid_589202 = path.getOrDefault("apkVersionCode")
  valid_589202 = validateParameter(valid_589202, JInt, required = true, default = nil)
  if valid_589202 != nil:
    section.add "apkVersionCode", valid_589202
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589203 = query.getOrDefault("fields")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "fields", valid_589203
  var valid_589204 = query.getOrDefault("quotaUser")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "quotaUser", valid_589204
  var valid_589205 = query.getOrDefault("alt")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = newJString("json"))
  if valid_589205 != nil:
    section.add "alt", valid_589205
  var valid_589206 = query.getOrDefault("oauth_token")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "oauth_token", valid_589206
  var valid_589207 = query.getOrDefault("userIp")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "userIp", valid_589207
  var valid_589208 = query.getOrDefault("key")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "key", valid_589208
  var valid_589209 = query.getOrDefault("prettyPrint")
  valid_589209 = validateParameter(valid_589209, JBool, required = false,
                                 default = newJBool(true))
  if valid_589209 != nil:
    section.add "prettyPrint", valid_589209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589210: Call_AndroidpublisherEditsApklistingsDeleteall_589197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all the APK-specific localized listings for a specified APK.
  ## 
  let valid = call_589210.validator(path, query, header, formData, body)
  let scheme = call_589210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589210.url(scheme.get, call_589210.host, call_589210.base,
                         call_589210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589210, url, valid)

proc call*(call_589211: Call_AndroidpublisherEditsApklistingsDeleteall_589197;
          packageName: string; editId: string; apkVersionCode: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsApklistingsDeleteall
  ## Deletes all the APK-specific localized listings for a specified APK.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   apkVersionCode: int (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  var path_589212 = newJObject()
  var query_589213 = newJObject()
  add(query_589213, "fields", newJString(fields))
  add(path_589212, "packageName", newJString(packageName))
  add(query_589213, "quotaUser", newJString(quotaUser))
  add(query_589213, "alt", newJString(alt))
  add(path_589212, "editId", newJString(editId))
  add(query_589213, "oauth_token", newJString(oauthToken))
  add(query_589213, "userIp", newJString(userIp))
  add(query_589213, "key", newJString(key))
  add(query_589213, "prettyPrint", newJBool(prettyPrint))
  add(path_589212, "apkVersionCode", newJInt(apkVersionCode))
  result = call_589211.call(path_589212, query_589213, nil, nil, nil)

var androidpublisherEditsApklistingsDeleteall* = Call_AndroidpublisherEditsApklistingsDeleteall_589197(
    name: "androidpublisherEditsApklistingsDeleteall",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings",
    validator: validate_AndroidpublisherEditsApklistingsDeleteall_589198,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsDeleteall_589199,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsUpdate_589232 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsApklistingsUpdate_589234(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApklistingsUpdate_589233(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates or creates the APK-specific localized listing for a specified APK and language code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the APK-specific localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   apkVersionCode: JInt (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589235 = path.getOrDefault("packageName")
  valid_589235 = validateParameter(valid_589235, JString, required = true,
                                 default = nil)
  if valid_589235 != nil:
    section.add "packageName", valid_589235
  var valid_589236 = path.getOrDefault("editId")
  valid_589236 = validateParameter(valid_589236, JString, required = true,
                                 default = nil)
  if valid_589236 != nil:
    section.add "editId", valid_589236
  var valid_589237 = path.getOrDefault("language")
  valid_589237 = validateParameter(valid_589237, JString, required = true,
                                 default = nil)
  if valid_589237 != nil:
    section.add "language", valid_589237
  var valid_589238 = path.getOrDefault("apkVersionCode")
  valid_589238 = validateParameter(valid_589238, JInt, required = true, default = nil)
  if valid_589238 != nil:
    section.add "apkVersionCode", valid_589238
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589239 = query.getOrDefault("fields")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "fields", valid_589239
  var valid_589240 = query.getOrDefault("quotaUser")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "quotaUser", valid_589240
  var valid_589241 = query.getOrDefault("alt")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = newJString("json"))
  if valid_589241 != nil:
    section.add "alt", valid_589241
  var valid_589242 = query.getOrDefault("oauth_token")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "oauth_token", valid_589242
  var valid_589243 = query.getOrDefault("userIp")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "userIp", valid_589243
  var valid_589244 = query.getOrDefault("key")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "key", valid_589244
  var valid_589245 = query.getOrDefault("prettyPrint")
  valid_589245 = validateParameter(valid_589245, JBool, required = false,
                                 default = newJBool(true))
  if valid_589245 != nil:
    section.add "prettyPrint", valid_589245
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

proc call*(call_589247: Call_AndroidpublisherEditsApklistingsUpdate_589232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates or creates the APK-specific localized listing for a specified APK and language code.
  ## 
  let valid = call_589247.validator(path, query, header, formData, body)
  let scheme = call_589247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589247.url(scheme.get, call_589247.host, call_589247.base,
                         call_589247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589247, url, valid)

proc call*(call_589248: Call_AndroidpublisherEditsApklistingsUpdate_589232;
          packageName: string; editId: string; language: string; apkVersionCode: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsApklistingsUpdate
  ## Updates or creates the APK-specific localized listing for a specified APK and language code.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the APK-specific localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   apkVersionCode: int (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  var path_589249 = newJObject()
  var query_589250 = newJObject()
  var body_589251 = newJObject()
  add(query_589250, "fields", newJString(fields))
  add(path_589249, "packageName", newJString(packageName))
  add(query_589250, "quotaUser", newJString(quotaUser))
  add(query_589250, "alt", newJString(alt))
  add(path_589249, "editId", newJString(editId))
  add(query_589250, "oauth_token", newJString(oauthToken))
  add(path_589249, "language", newJString(language))
  add(query_589250, "userIp", newJString(userIp))
  add(query_589250, "key", newJString(key))
  if body != nil:
    body_589251 = body
  add(query_589250, "prettyPrint", newJBool(prettyPrint))
  add(path_589249, "apkVersionCode", newJInt(apkVersionCode))
  result = call_589248.call(path_589249, query_589250, nil, nil, body_589251)

var androidpublisherEditsApklistingsUpdate* = Call_AndroidpublisherEditsApklistingsUpdate_589232(
    name: "androidpublisherEditsApklistingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings/{language}",
    validator: validate_AndroidpublisherEditsApklistingsUpdate_589233,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsUpdate_589234,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsGet_589214 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsApklistingsGet_589216(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApklistingsGet_589215(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the APK-specific localized listing for a specified APK and language code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the APK-specific localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   apkVersionCode: JInt (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589217 = path.getOrDefault("packageName")
  valid_589217 = validateParameter(valid_589217, JString, required = true,
                                 default = nil)
  if valid_589217 != nil:
    section.add "packageName", valid_589217
  var valid_589218 = path.getOrDefault("editId")
  valid_589218 = validateParameter(valid_589218, JString, required = true,
                                 default = nil)
  if valid_589218 != nil:
    section.add "editId", valid_589218
  var valid_589219 = path.getOrDefault("language")
  valid_589219 = validateParameter(valid_589219, JString, required = true,
                                 default = nil)
  if valid_589219 != nil:
    section.add "language", valid_589219
  var valid_589220 = path.getOrDefault("apkVersionCode")
  valid_589220 = validateParameter(valid_589220, JInt, required = true, default = nil)
  if valid_589220 != nil:
    section.add "apkVersionCode", valid_589220
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589221 = query.getOrDefault("fields")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "fields", valid_589221
  var valid_589222 = query.getOrDefault("quotaUser")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "quotaUser", valid_589222
  var valid_589223 = query.getOrDefault("alt")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = newJString("json"))
  if valid_589223 != nil:
    section.add "alt", valid_589223
  var valid_589224 = query.getOrDefault("oauth_token")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "oauth_token", valid_589224
  var valid_589225 = query.getOrDefault("userIp")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "userIp", valid_589225
  var valid_589226 = query.getOrDefault("key")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "key", valid_589226
  var valid_589227 = query.getOrDefault("prettyPrint")
  valid_589227 = validateParameter(valid_589227, JBool, required = false,
                                 default = newJBool(true))
  if valid_589227 != nil:
    section.add "prettyPrint", valid_589227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589228: Call_AndroidpublisherEditsApklistingsGet_589214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the APK-specific localized listing for a specified APK and language code.
  ## 
  let valid = call_589228.validator(path, query, header, formData, body)
  let scheme = call_589228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589228.url(scheme.get, call_589228.host, call_589228.base,
                         call_589228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589228, url, valid)

proc call*(call_589229: Call_AndroidpublisherEditsApklistingsGet_589214;
          packageName: string; editId: string; language: string; apkVersionCode: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsApklistingsGet
  ## Fetches the APK-specific localized listing for a specified APK and language code.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the APK-specific localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   apkVersionCode: int (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  var path_589230 = newJObject()
  var query_589231 = newJObject()
  add(query_589231, "fields", newJString(fields))
  add(path_589230, "packageName", newJString(packageName))
  add(query_589231, "quotaUser", newJString(quotaUser))
  add(query_589231, "alt", newJString(alt))
  add(path_589230, "editId", newJString(editId))
  add(query_589231, "oauth_token", newJString(oauthToken))
  add(path_589230, "language", newJString(language))
  add(query_589231, "userIp", newJString(userIp))
  add(query_589231, "key", newJString(key))
  add(query_589231, "prettyPrint", newJBool(prettyPrint))
  add(path_589230, "apkVersionCode", newJInt(apkVersionCode))
  result = call_589229.call(path_589230, query_589231, nil, nil, nil)

var androidpublisherEditsApklistingsGet* = Call_AndroidpublisherEditsApklistingsGet_589214(
    name: "androidpublisherEditsApklistingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings/{language}",
    validator: validate_AndroidpublisherEditsApklistingsGet_589215,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsGet_589216, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsPatch_589270 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsApklistingsPatch_589272(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApklistingsPatch_589271(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates or creates the APK-specific localized listing for a specified APK and language code. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the APK-specific localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   apkVersionCode: JInt (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589273 = path.getOrDefault("packageName")
  valid_589273 = validateParameter(valid_589273, JString, required = true,
                                 default = nil)
  if valid_589273 != nil:
    section.add "packageName", valid_589273
  var valid_589274 = path.getOrDefault("editId")
  valid_589274 = validateParameter(valid_589274, JString, required = true,
                                 default = nil)
  if valid_589274 != nil:
    section.add "editId", valid_589274
  var valid_589275 = path.getOrDefault("language")
  valid_589275 = validateParameter(valid_589275, JString, required = true,
                                 default = nil)
  if valid_589275 != nil:
    section.add "language", valid_589275
  var valid_589276 = path.getOrDefault("apkVersionCode")
  valid_589276 = validateParameter(valid_589276, JInt, required = true, default = nil)
  if valid_589276 != nil:
    section.add "apkVersionCode", valid_589276
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589277 = query.getOrDefault("fields")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "fields", valid_589277
  var valid_589278 = query.getOrDefault("quotaUser")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "quotaUser", valid_589278
  var valid_589279 = query.getOrDefault("alt")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = newJString("json"))
  if valid_589279 != nil:
    section.add "alt", valid_589279
  var valid_589280 = query.getOrDefault("oauth_token")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "oauth_token", valid_589280
  var valid_589281 = query.getOrDefault("userIp")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "userIp", valid_589281
  var valid_589282 = query.getOrDefault("key")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "key", valid_589282
  var valid_589283 = query.getOrDefault("prettyPrint")
  valid_589283 = validateParameter(valid_589283, JBool, required = false,
                                 default = newJBool(true))
  if valid_589283 != nil:
    section.add "prettyPrint", valid_589283
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

proc call*(call_589285: Call_AndroidpublisherEditsApklistingsPatch_589270;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates or creates the APK-specific localized listing for a specified APK and language code. This method supports patch semantics.
  ## 
  let valid = call_589285.validator(path, query, header, formData, body)
  let scheme = call_589285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589285.url(scheme.get, call_589285.host, call_589285.base,
                         call_589285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589285, url, valid)

proc call*(call_589286: Call_AndroidpublisherEditsApklistingsPatch_589270;
          packageName: string; editId: string; language: string; apkVersionCode: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsApklistingsPatch
  ## Updates or creates the APK-specific localized listing for a specified APK and language code. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the APK-specific localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   apkVersionCode: int (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  var path_589287 = newJObject()
  var query_589288 = newJObject()
  var body_589289 = newJObject()
  add(query_589288, "fields", newJString(fields))
  add(path_589287, "packageName", newJString(packageName))
  add(query_589288, "quotaUser", newJString(quotaUser))
  add(query_589288, "alt", newJString(alt))
  add(path_589287, "editId", newJString(editId))
  add(query_589288, "oauth_token", newJString(oauthToken))
  add(path_589287, "language", newJString(language))
  add(query_589288, "userIp", newJString(userIp))
  add(query_589288, "key", newJString(key))
  if body != nil:
    body_589289 = body
  add(query_589288, "prettyPrint", newJBool(prettyPrint))
  add(path_589287, "apkVersionCode", newJInt(apkVersionCode))
  result = call_589286.call(path_589287, query_589288, nil, nil, body_589289)

var androidpublisherEditsApklistingsPatch* = Call_AndroidpublisherEditsApklistingsPatch_589270(
    name: "androidpublisherEditsApklistingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings/{language}",
    validator: validate_AndroidpublisherEditsApklistingsPatch_589271,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsPatch_589272, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsDelete_589252 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsApklistingsDelete_589254(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApklistingsDelete_589253(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the APK-specific localized listing for a specified APK and language code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the APK-specific localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   apkVersionCode: JInt (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589255 = path.getOrDefault("packageName")
  valid_589255 = validateParameter(valid_589255, JString, required = true,
                                 default = nil)
  if valid_589255 != nil:
    section.add "packageName", valid_589255
  var valid_589256 = path.getOrDefault("editId")
  valid_589256 = validateParameter(valid_589256, JString, required = true,
                                 default = nil)
  if valid_589256 != nil:
    section.add "editId", valid_589256
  var valid_589257 = path.getOrDefault("language")
  valid_589257 = validateParameter(valid_589257, JString, required = true,
                                 default = nil)
  if valid_589257 != nil:
    section.add "language", valid_589257
  var valid_589258 = path.getOrDefault("apkVersionCode")
  valid_589258 = validateParameter(valid_589258, JInt, required = true, default = nil)
  if valid_589258 != nil:
    section.add "apkVersionCode", valid_589258
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589259 = query.getOrDefault("fields")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "fields", valid_589259
  var valid_589260 = query.getOrDefault("quotaUser")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "quotaUser", valid_589260
  var valid_589261 = query.getOrDefault("alt")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = newJString("json"))
  if valid_589261 != nil:
    section.add "alt", valid_589261
  var valid_589262 = query.getOrDefault("oauth_token")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "oauth_token", valid_589262
  var valid_589263 = query.getOrDefault("userIp")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "userIp", valid_589263
  var valid_589264 = query.getOrDefault("key")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "key", valid_589264
  var valid_589265 = query.getOrDefault("prettyPrint")
  valid_589265 = validateParameter(valid_589265, JBool, required = false,
                                 default = newJBool(true))
  if valid_589265 != nil:
    section.add "prettyPrint", valid_589265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589266: Call_AndroidpublisherEditsApklistingsDelete_589252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the APK-specific localized listing for a specified APK and language code.
  ## 
  let valid = call_589266.validator(path, query, header, formData, body)
  let scheme = call_589266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589266.url(scheme.get, call_589266.host, call_589266.base,
                         call_589266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589266, url, valid)

proc call*(call_589267: Call_AndroidpublisherEditsApklistingsDelete_589252;
          packageName: string; editId: string; language: string; apkVersionCode: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsApklistingsDelete
  ## Deletes the APK-specific localized listing for a specified APK and language code.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the APK-specific localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   apkVersionCode: int (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  var path_589268 = newJObject()
  var query_589269 = newJObject()
  add(query_589269, "fields", newJString(fields))
  add(path_589268, "packageName", newJString(packageName))
  add(query_589269, "quotaUser", newJString(quotaUser))
  add(query_589269, "alt", newJString(alt))
  add(path_589268, "editId", newJString(editId))
  add(query_589269, "oauth_token", newJString(oauthToken))
  add(path_589268, "language", newJString(language))
  add(query_589269, "userIp", newJString(userIp))
  add(query_589269, "key", newJString(key))
  add(query_589269, "prettyPrint", newJBool(prettyPrint))
  add(path_589268, "apkVersionCode", newJInt(apkVersionCode))
  result = call_589267.call(path_589268, query_589269, nil, nil, nil)

var androidpublisherEditsApklistingsDelete* = Call_AndroidpublisherEditsApklistingsDelete_589252(
    name: "androidpublisherEditsApklistingsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings/{language}",
    validator: validate_AndroidpublisherEditsApklistingsDelete_589253,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsDelete_589254,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsBundlesUpload_589306 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsBundlesUpload_589308(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/bundles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsBundlesUpload_589307(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a new Android App Bundle to this edit. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589309 = path.getOrDefault("packageName")
  valid_589309 = validateParameter(valid_589309, JString, required = true,
                                 default = nil)
  if valid_589309 != nil:
    section.add "packageName", valid_589309
  var valid_589310 = path.getOrDefault("editId")
  valid_589310 = validateParameter(valid_589310, JString, required = true,
                                 default = nil)
  if valid_589310 != nil:
    section.add "editId", valid_589310
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ackBundleInstallationWarning: JBool
  ##                               : Must be set to true if the bundle installation may trigger a warning on user devices (for example, if installation size may be over a threshold, typically 100 MB).
  section = newJObject()
  var valid_589311 = query.getOrDefault("fields")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "fields", valid_589311
  var valid_589312 = query.getOrDefault("quotaUser")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "quotaUser", valid_589312
  var valid_589313 = query.getOrDefault("alt")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = newJString("json"))
  if valid_589313 != nil:
    section.add "alt", valid_589313
  var valid_589314 = query.getOrDefault("oauth_token")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "oauth_token", valid_589314
  var valid_589315 = query.getOrDefault("userIp")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "userIp", valid_589315
  var valid_589316 = query.getOrDefault("key")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "key", valid_589316
  var valid_589317 = query.getOrDefault("prettyPrint")
  valid_589317 = validateParameter(valid_589317, JBool, required = false,
                                 default = newJBool(true))
  if valid_589317 != nil:
    section.add "prettyPrint", valid_589317
  var valid_589318 = query.getOrDefault("ackBundleInstallationWarning")
  valid_589318 = validateParameter(valid_589318, JBool, required = false, default = nil)
  if valid_589318 != nil:
    section.add "ackBundleInstallationWarning", valid_589318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589319: Call_AndroidpublisherEditsBundlesUpload_589306;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a new Android App Bundle to this edit. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  let valid = call_589319.validator(path, query, header, formData, body)
  let scheme = call_589319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589319.url(scheme.get, call_589319.host, call_589319.base,
                         call_589319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589319, url, valid)

proc call*(call_589320: Call_AndroidpublisherEditsBundlesUpload_589306;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true;
          ackBundleInstallationWarning: bool = false): Recallable =
  ## androidpublisherEditsBundlesUpload
  ## Uploads a new Android App Bundle to this edit. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ackBundleInstallationWarning: bool
  ##                               : Must be set to true if the bundle installation may trigger a warning on user devices (for example, if installation size may be over a threshold, typically 100 MB).
  var path_589321 = newJObject()
  var query_589322 = newJObject()
  add(query_589322, "fields", newJString(fields))
  add(path_589321, "packageName", newJString(packageName))
  add(query_589322, "quotaUser", newJString(quotaUser))
  add(query_589322, "alt", newJString(alt))
  add(path_589321, "editId", newJString(editId))
  add(query_589322, "oauth_token", newJString(oauthToken))
  add(query_589322, "userIp", newJString(userIp))
  add(query_589322, "key", newJString(key))
  add(query_589322, "prettyPrint", newJBool(prettyPrint))
  add(query_589322, "ackBundleInstallationWarning",
      newJBool(ackBundleInstallationWarning))
  result = call_589320.call(path_589321, query_589322, nil, nil, nil)

var androidpublisherEditsBundlesUpload* = Call_AndroidpublisherEditsBundlesUpload_589306(
    name: "androidpublisherEditsBundlesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/bundles",
    validator: validate_AndroidpublisherEditsBundlesUpload_589307,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsBundlesUpload_589308, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsBundlesList_589290 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsBundlesList_589292(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/bundles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsBundlesList_589291(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589293 = path.getOrDefault("packageName")
  valid_589293 = validateParameter(valid_589293, JString, required = true,
                                 default = nil)
  if valid_589293 != nil:
    section.add "packageName", valid_589293
  var valid_589294 = path.getOrDefault("editId")
  valid_589294 = validateParameter(valid_589294, JString, required = true,
                                 default = nil)
  if valid_589294 != nil:
    section.add "editId", valid_589294
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589295 = query.getOrDefault("fields")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "fields", valid_589295
  var valid_589296 = query.getOrDefault("quotaUser")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "quotaUser", valid_589296
  var valid_589297 = query.getOrDefault("alt")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = newJString("json"))
  if valid_589297 != nil:
    section.add "alt", valid_589297
  var valid_589298 = query.getOrDefault("oauth_token")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "oauth_token", valid_589298
  var valid_589299 = query.getOrDefault("userIp")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "userIp", valid_589299
  var valid_589300 = query.getOrDefault("key")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "key", valid_589300
  var valid_589301 = query.getOrDefault("prettyPrint")
  valid_589301 = validateParameter(valid_589301, JBool, required = false,
                                 default = newJBool(true))
  if valid_589301 != nil:
    section.add "prettyPrint", valid_589301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589302: Call_AndroidpublisherEditsBundlesList_589290;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_589302.validator(path, query, header, formData, body)
  let scheme = call_589302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589302.url(scheme.get, call_589302.host, call_589302.base,
                         call_589302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589302, url, valid)

proc call*(call_589303: Call_AndroidpublisherEditsBundlesList_589290;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsBundlesList
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589304 = newJObject()
  var query_589305 = newJObject()
  add(query_589305, "fields", newJString(fields))
  add(path_589304, "packageName", newJString(packageName))
  add(query_589305, "quotaUser", newJString(quotaUser))
  add(query_589305, "alt", newJString(alt))
  add(path_589304, "editId", newJString(editId))
  add(query_589305, "oauth_token", newJString(oauthToken))
  add(query_589305, "userIp", newJString(userIp))
  add(query_589305, "key", newJString(key))
  add(query_589305, "prettyPrint", newJBool(prettyPrint))
  result = call_589303.call(path_589304, query_589305, nil, nil, nil)

var androidpublisherEditsBundlesList* = Call_AndroidpublisherEditsBundlesList_589290(
    name: "androidpublisherEditsBundlesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/bundles",
    validator: validate_AndroidpublisherEditsBundlesList_589291,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsBundlesList_589292, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsUpdate_589339 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsDetailsUpdate_589341(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/details")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsDetailsUpdate_589340(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates app details for this edit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589342 = path.getOrDefault("packageName")
  valid_589342 = validateParameter(valid_589342, JString, required = true,
                                 default = nil)
  if valid_589342 != nil:
    section.add "packageName", valid_589342
  var valid_589343 = path.getOrDefault("editId")
  valid_589343 = validateParameter(valid_589343, JString, required = true,
                                 default = nil)
  if valid_589343 != nil:
    section.add "editId", valid_589343
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589344 = query.getOrDefault("fields")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "fields", valid_589344
  var valid_589345 = query.getOrDefault("quotaUser")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "quotaUser", valid_589345
  var valid_589346 = query.getOrDefault("alt")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = newJString("json"))
  if valid_589346 != nil:
    section.add "alt", valid_589346
  var valid_589347 = query.getOrDefault("oauth_token")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "oauth_token", valid_589347
  var valid_589348 = query.getOrDefault("userIp")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "userIp", valid_589348
  var valid_589349 = query.getOrDefault("key")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "key", valid_589349
  var valid_589350 = query.getOrDefault("prettyPrint")
  valid_589350 = validateParameter(valid_589350, JBool, required = false,
                                 default = newJBool(true))
  if valid_589350 != nil:
    section.add "prettyPrint", valid_589350
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

proc call*(call_589352: Call_AndroidpublisherEditsDetailsUpdate_589339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates app details for this edit.
  ## 
  let valid = call_589352.validator(path, query, header, formData, body)
  let scheme = call_589352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589352.url(scheme.get, call_589352.host, call_589352.base,
                         call_589352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589352, url, valid)

proc call*(call_589353: Call_AndroidpublisherEditsDetailsUpdate_589339;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsDetailsUpdate
  ## Updates app details for this edit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589354 = newJObject()
  var query_589355 = newJObject()
  var body_589356 = newJObject()
  add(query_589355, "fields", newJString(fields))
  add(path_589354, "packageName", newJString(packageName))
  add(query_589355, "quotaUser", newJString(quotaUser))
  add(query_589355, "alt", newJString(alt))
  add(path_589354, "editId", newJString(editId))
  add(query_589355, "oauth_token", newJString(oauthToken))
  add(query_589355, "userIp", newJString(userIp))
  add(query_589355, "key", newJString(key))
  if body != nil:
    body_589356 = body
  add(query_589355, "prettyPrint", newJBool(prettyPrint))
  result = call_589353.call(path_589354, query_589355, nil, nil, body_589356)

var androidpublisherEditsDetailsUpdate* = Call_AndroidpublisherEditsDetailsUpdate_589339(
    name: "androidpublisherEditsDetailsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsUpdate_589340,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDetailsUpdate_589341, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsGet_589323 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsDetailsGet_589325(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/details")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsDetailsGet_589324(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches app details for this edit. This includes the default language and developer support contact information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589326 = path.getOrDefault("packageName")
  valid_589326 = validateParameter(valid_589326, JString, required = true,
                                 default = nil)
  if valid_589326 != nil:
    section.add "packageName", valid_589326
  var valid_589327 = path.getOrDefault("editId")
  valid_589327 = validateParameter(valid_589327, JString, required = true,
                                 default = nil)
  if valid_589327 != nil:
    section.add "editId", valid_589327
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589328 = query.getOrDefault("fields")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "fields", valid_589328
  var valid_589329 = query.getOrDefault("quotaUser")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "quotaUser", valid_589329
  var valid_589330 = query.getOrDefault("alt")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = newJString("json"))
  if valid_589330 != nil:
    section.add "alt", valid_589330
  var valid_589331 = query.getOrDefault("oauth_token")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "oauth_token", valid_589331
  var valid_589332 = query.getOrDefault("userIp")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "userIp", valid_589332
  var valid_589333 = query.getOrDefault("key")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "key", valid_589333
  var valid_589334 = query.getOrDefault("prettyPrint")
  valid_589334 = validateParameter(valid_589334, JBool, required = false,
                                 default = newJBool(true))
  if valid_589334 != nil:
    section.add "prettyPrint", valid_589334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589335: Call_AndroidpublisherEditsDetailsGet_589323;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches app details for this edit. This includes the default language and developer support contact information.
  ## 
  let valid = call_589335.validator(path, query, header, formData, body)
  let scheme = call_589335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589335.url(scheme.get, call_589335.host, call_589335.base,
                         call_589335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589335, url, valid)

proc call*(call_589336: Call_AndroidpublisherEditsDetailsGet_589323;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsDetailsGet
  ## Fetches app details for this edit. This includes the default language and developer support contact information.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589337 = newJObject()
  var query_589338 = newJObject()
  add(query_589338, "fields", newJString(fields))
  add(path_589337, "packageName", newJString(packageName))
  add(query_589338, "quotaUser", newJString(quotaUser))
  add(query_589338, "alt", newJString(alt))
  add(path_589337, "editId", newJString(editId))
  add(query_589338, "oauth_token", newJString(oauthToken))
  add(query_589338, "userIp", newJString(userIp))
  add(query_589338, "key", newJString(key))
  add(query_589338, "prettyPrint", newJBool(prettyPrint))
  result = call_589336.call(path_589337, query_589338, nil, nil, nil)

var androidpublisherEditsDetailsGet* = Call_AndroidpublisherEditsDetailsGet_589323(
    name: "androidpublisherEditsDetailsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsGet_589324,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDetailsGet_589325, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsPatch_589357 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsDetailsPatch_589359(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/details")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsDetailsPatch_589358(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates app details for this edit. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589360 = path.getOrDefault("packageName")
  valid_589360 = validateParameter(valid_589360, JString, required = true,
                                 default = nil)
  if valid_589360 != nil:
    section.add "packageName", valid_589360
  var valid_589361 = path.getOrDefault("editId")
  valid_589361 = validateParameter(valid_589361, JString, required = true,
                                 default = nil)
  if valid_589361 != nil:
    section.add "editId", valid_589361
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589362 = query.getOrDefault("fields")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "fields", valid_589362
  var valid_589363 = query.getOrDefault("quotaUser")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "quotaUser", valid_589363
  var valid_589364 = query.getOrDefault("alt")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = newJString("json"))
  if valid_589364 != nil:
    section.add "alt", valid_589364
  var valid_589365 = query.getOrDefault("oauth_token")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "oauth_token", valid_589365
  var valid_589366 = query.getOrDefault("userIp")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "userIp", valid_589366
  var valid_589367 = query.getOrDefault("key")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "key", valid_589367
  var valid_589368 = query.getOrDefault("prettyPrint")
  valid_589368 = validateParameter(valid_589368, JBool, required = false,
                                 default = newJBool(true))
  if valid_589368 != nil:
    section.add "prettyPrint", valid_589368
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

proc call*(call_589370: Call_AndroidpublisherEditsDetailsPatch_589357;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates app details for this edit. This method supports patch semantics.
  ## 
  let valid = call_589370.validator(path, query, header, formData, body)
  let scheme = call_589370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589370.url(scheme.get, call_589370.host, call_589370.base,
                         call_589370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589370, url, valid)

proc call*(call_589371: Call_AndroidpublisherEditsDetailsPatch_589357;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsDetailsPatch
  ## Updates app details for this edit. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589372 = newJObject()
  var query_589373 = newJObject()
  var body_589374 = newJObject()
  add(query_589373, "fields", newJString(fields))
  add(path_589372, "packageName", newJString(packageName))
  add(query_589373, "quotaUser", newJString(quotaUser))
  add(query_589373, "alt", newJString(alt))
  add(path_589372, "editId", newJString(editId))
  add(query_589373, "oauth_token", newJString(oauthToken))
  add(query_589373, "userIp", newJString(userIp))
  add(query_589373, "key", newJString(key))
  if body != nil:
    body_589374 = body
  add(query_589373, "prettyPrint", newJBool(prettyPrint))
  result = call_589371.call(path_589372, query_589373, nil, nil, body_589374)

var androidpublisherEditsDetailsPatch* = Call_AndroidpublisherEditsDetailsPatch_589357(
    name: "androidpublisherEditsDetailsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsPatch_589358,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDetailsPatch_589359, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsList_589375 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsListingsList_589377(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsListingsList_589376(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all of the localized store listings attached to this edit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589378 = path.getOrDefault("packageName")
  valid_589378 = validateParameter(valid_589378, JString, required = true,
                                 default = nil)
  if valid_589378 != nil:
    section.add "packageName", valid_589378
  var valid_589379 = path.getOrDefault("editId")
  valid_589379 = validateParameter(valid_589379, JString, required = true,
                                 default = nil)
  if valid_589379 != nil:
    section.add "editId", valid_589379
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589380 = query.getOrDefault("fields")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "fields", valid_589380
  var valid_589381 = query.getOrDefault("quotaUser")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = nil)
  if valid_589381 != nil:
    section.add "quotaUser", valid_589381
  var valid_589382 = query.getOrDefault("alt")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = newJString("json"))
  if valid_589382 != nil:
    section.add "alt", valid_589382
  var valid_589383 = query.getOrDefault("oauth_token")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "oauth_token", valid_589383
  var valid_589384 = query.getOrDefault("userIp")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "userIp", valid_589384
  var valid_589385 = query.getOrDefault("key")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "key", valid_589385
  var valid_589386 = query.getOrDefault("prettyPrint")
  valid_589386 = validateParameter(valid_589386, JBool, required = false,
                                 default = newJBool(true))
  if valid_589386 != nil:
    section.add "prettyPrint", valid_589386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589387: Call_AndroidpublisherEditsListingsList_589375;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all of the localized store listings attached to this edit.
  ## 
  let valid = call_589387.validator(path, query, header, formData, body)
  let scheme = call_589387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589387.url(scheme.get, call_589387.host, call_589387.base,
                         call_589387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589387, url, valid)

proc call*(call_589388: Call_AndroidpublisherEditsListingsList_589375;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsListingsList
  ## Returns all of the localized store listings attached to this edit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589389 = newJObject()
  var query_589390 = newJObject()
  add(query_589390, "fields", newJString(fields))
  add(path_589389, "packageName", newJString(packageName))
  add(query_589390, "quotaUser", newJString(quotaUser))
  add(query_589390, "alt", newJString(alt))
  add(path_589389, "editId", newJString(editId))
  add(query_589390, "oauth_token", newJString(oauthToken))
  add(query_589390, "userIp", newJString(userIp))
  add(query_589390, "key", newJString(key))
  add(query_589390, "prettyPrint", newJBool(prettyPrint))
  result = call_589388.call(path_589389, query_589390, nil, nil, nil)

var androidpublisherEditsListingsList* = Call_AndroidpublisherEditsListingsList_589375(
    name: "androidpublisherEditsListingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings",
    validator: validate_AndroidpublisherEditsListingsList_589376,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsList_589377, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsDeleteall_589391 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsListingsDeleteall_589393(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsListingsDeleteall_589392(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes all localized listings from an edit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589394 = path.getOrDefault("packageName")
  valid_589394 = validateParameter(valid_589394, JString, required = true,
                                 default = nil)
  if valid_589394 != nil:
    section.add "packageName", valid_589394
  var valid_589395 = path.getOrDefault("editId")
  valid_589395 = validateParameter(valid_589395, JString, required = true,
                                 default = nil)
  if valid_589395 != nil:
    section.add "editId", valid_589395
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589396 = query.getOrDefault("fields")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "fields", valid_589396
  var valid_589397 = query.getOrDefault("quotaUser")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "quotaUser", valid_589397
  var valid_589398 = query.getOrDefault("alt")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = newJString("json"))
  if valid_589398 != nil:
    section.add "alt", valid_589398
  var valid_589399 = query.getOrDefault("oauth_token")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "oauth_token", valid_589399
  var valid_589400 = query.getOrDefault("userIp")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "userIp", valid_589400
  var valid_589401 = query.getOrDefault("key")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "key", valid_589401
  var valid_589402 = query.getOrDefault("prettyPrint")
  valid_589402 = validateParameter(valid_589402, JBool, required = false,
                                 default = newJBool(true))
  if valid_589402 != nil:
    section.add "prettyPrint", valid_589402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589403: Call_AndroidpublisherEditsListingsDeleteall_589391;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all localized listings from an edit.
  ## 
  let valid = call_589403.validator(path, query, header, formData, body)
  let scheme = call_589403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589403.url(scheme.get, call_589403.host, call_589403.base,
                         call_589403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589403, url, valid)

proc call*(call_589404: Call_AndroidpublisherEditsListingsDeleteall_589391;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsListingsDeleteall
  ## Deletes all localized listings from an edit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589405 = newJObject()
  var query_589406 = newJObject()
  add(query_589406, "fields", newJString(fields))
  add(path_589405, "packageName", newJString(packageName))
  add(query_589406, "quotaUser", newJString(quotaUser))
  add(query_589406, "alt", newJString(alt))
  add(path_589405, "editId", newJString(editId))
  add(query_589406, "oauth_token", newJString(oauthToken))
  add(query_589406, "userIp", newJString(userIp))
  add(query_589406, "key", newJString(key))
  add(query_589406, "prettyPrint", newJBool(prettyPrint))
  result = call_589404.call(path_589405, query_589406, nil, nil, nil)

var androidpublisherEditsListingsDeleteall* = Call_AndroidpublisherEditsListingsDeleteall_589391(
    name: "androidpublisherEditsListingsDeleteall", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings",
    validator: validate_AndroidpublisherEditsListingsDeleteall_589392,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsDeleteall_589393,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsUpdate_589424 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsListingsUpdate_589426(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsListingsUpdate_589425(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a localized store listing.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589427 = path.getOrDefault("packageName")
  valid_589427 = validateParameter(valid_589427, JString, required = true,
                                 default = nil)
  if valid_589427 != nil:
    section.add "packageName", valid_589427
  var valid_589428 = path.getOrDefault("editId")
  valid_589428 = validateParameter(valid_589428, JString, required = true,
                                 default = nil)
  if valid_589428 != nil:
    section.add "editId", valid_589428
  var valid_589429 = path.getOrDefault("language")
  valid_589429 = validateParameter(valid_589429, JString, required = true,
                                 default = nil)
  if valid_589429 != nil:
    section.add "language", valid_589429
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589430 = query.getOrDefault("fields")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "fields", valid_589430
  var valid_589431 = query.getOrDefault("quotaUser")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "quotaUser", valid_589431
  var valid_589432 = query.getOrDefault("alt")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = newJString("json"))
  if valid_589432 != nil:
    section.add "alt", valid_589432
  var valid_589433 = query.getOrDefault("oauth_token")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = nil)
  if valid_589433 != nil:
    section.add "oauth_token", valid_589433
  var valid_589434 = query.getOrDefault("userIp")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "userIp", valid_589434
  var valid_589435 = query.getOrDefault("key")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "key", valid_589435
  var valid_589436 = query.getOrDefault("prettyPrint")
  valid_589436 = validateParameter(valid_589436, JBool, required = false,
                                 default = newJBool(true))
  if valid_589436 != nil:
    section.add "prettyPrint", valid_589436
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

proc call*(call_589438: Call_AndroidpublisherEditsListingsUpdate_589424;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a localized store listing.
  ## 
  let valid = call_589438.validator(path, query, header, formData, body)
  let scheme = call_589438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589438.url(scheme.get, call_589438.host, call_589438.base,
                         call_589438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589438, url, valid)

proc call*(call_589439: Call_AndroidpublisherEditsListingsUpdate_589424;
          packageName: string; editId: string; language: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsListingsUpdate
  ## Creates or updates a localized store listing.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589440 = newJObject()
  var query_589441 = newJObject()
  var body_589442 = newJObject()
  add(query_589441, "fields", newJString(fields))
  add(path_589440, "packageName", newJString(packageName))
  add(query_589441, "quotaUser", newJString(quotaUser))
  add(query_589441, "alt", newJString(alt))
  add(path_589440, "editId", newJString(editId))
  add(query_589441, "oauth_token", newJString(oauthToken))
  add(path_589440, "language", newJString(language))
  add(query_589441, "userIp", newJString(userIp))
  add(query_589441, "key", newJString(key))
  if body != nil:
    body_589442 = body
  add(query_589441, "prettyPrint", newJBool(prettyPrint))
  result = call_589439.call(path_589440, query_589441, nil, nil, body_589442)

var androidpublisherEditsListingsUpdate* = Call_AndroidpublisherEditsListingsUpdate_589424(
    name: "androidpublisherEditsListingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsUpdate_589425,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsUpdate_589426, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsGet_589407 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsListingsGet_589409(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsListingsGet_589408(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches information about a localized store listing.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589410 = path.getOrDefault("packageName")
  valid_589410 = validateParameter(valid_589410, JString, required = true,
                                 default = nil)
  if valid_589410 != nil:
    section.add "packageName", valid_589410
  var valid_589411 = path.getOrDefault("editId")
  valid_589411 = validateParameter(valid_589411, JString, required = true,
                                 default = nil)
  if valid_589411 != nil:
    section.add "editId", valid_589411
  var valid_589412 = path.getOrDefault("language")
  valid_589412 = validateParameter(valid_589412, JString, required = true,
                                 default = nil)
  if valid_589412 != nil:
    section.add "language", valid_589412
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589413 = query.getOrDefault("fields")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "fields", valid_589413
  var valid_589414 = query.getOrDefault("quotaUser")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "quotaUser", valid_589414
  var valid_589415 = query.getOrDefault("alt")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = newJString("json"))
  if valid_589415 != nil:
    section.add "alt", valid_589415
  var valid_589416 = query.getOrDefault("oauth_token")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "oauth_token", valid_589416
  var valid_589417 = query.getOrDefault("userIp")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "userIp", valid_589417
  var valid_589418 = query.getOrDefault("key")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "key", valid_589418
  var valid_589419 = query.getOrDefault("prettyPrint")
  valid_589419 = validateParameter(valid_589419, JBool, required = false,
                                 default = newJBool(true))
  if valid_589419 != nil:
    section.add "prettyPrint", valid_589419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589420: Call_AndroidpublisherEditsListingsGet_589407;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches information about a localized store listing.
  ## 
  let valid = call_589420.validator(path, query, header, formData, body)
  let scheme = call_589420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589420.url(scheme.get, call_589420.host, call_589420.base,
                         call_589420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589420, url, valid)

proc call*(call_589421: Call_AndroidpublisherEditsListingsGet_589407;
          packageName: string; editId: string; language: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsListingsGet
  ## Fetches information about a localized store listing.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589422 = newJObject()
  var query_589423 = newJObject()
  add(query_589423, "fields", newJString(fields))
  add(path_589422, "packageName", newJString(packageName))
  add(query_589423, "quotaUser", newJString(quotaUser))
  add(query_589423, "alt", newJString(alt))
  add(path_589422, "editId", newJString(editId))
  add(query_589423, "oauth_token", newJString(oauthToken))
  add(path_589422, "language", newJString(language))
  add(query_589423, "userIp", newJString(userIp))
  add(query_589423, "key", newJString(key))
  add(query_589423, "prettyPrint", newJBool(prettyPrint))
  result = call_589421.call(path_589422, query_589423, nil, nil, nil)

var androidpublisherEditsListingsGet* = Call_AndroidpublisherEditsListingsGet_589407(
    name: "androidpublisherEditsListingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsGet_589408,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsGet_589409, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsPatch_589460 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsListingsPatch_589462(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsListingsPatch_589461(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a localized store listing. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589463 = path.getOrDefault("packageName")
  valid_589463 = validateParameter(valid_589463, JString, required = true,
                                 default = nil)
  if valid_589463 != nil:
    section.add "packageName", valid_589463
  var valid_589464 = path.getOrDefault("editId")
  valid_589464 = validateParameter(valid_589464, JString, required = true,
                                 default = nil)
  if valid_589464 != nil:
    section.add "editId", valid_589464
  var valid_589465 = path.getOrDefault("language")
  valid_589465 = validateParameter(valid_589465, JString, required = true,
                                 default = nil)
  if valid_589465 != nil:
    section.add "language", valid_589465
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589466 = query.getOrDefault("fields")
  valid_589466 = validateParameter(valid_589466, JString, required = false,
                                 default = nil)
  if valid_589466 != nil:
    section.add "fields", valid_589466
  var valid_589467 = query.getOrDefault("quotaUser")
  valid_589467 = validateParameter(valid_589467, JString, required = false,
                                 default = nil)
  if valid_589467 != nil:
    section.add "quotaUser", valid_589467
  var valid_589468 = query.getOrDefault("alt")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = newJString("json"))
  if valid_589468 != nil:
    section.add "alt", valid_589468
  var valid_589469 = query.getOrDefault("oauth_token")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = nil)
  if valid_589469 != nil:
    section.add "oauth_token", valid_589469
  var valid_589470 = query.getOrDefault("userIp")
  valid_589470 = validateParameter(valid_589470, JString, required = false,
                                 default = nil)
  if valid_589470 != nil:
    section.add "userIp", valid_589470
  var valid_589471 = query.getOrDefault("key")
  valid_589471 = validateParameter(valid_589471, JString, required = false,
                                 default = nil)
  if valid_589471 != nil:
    section.add "key", valid_589471
  var valid_589472 = query.getOrDefault("prettyPrint")
  valid_589472 = validateParameter(valid_589472, JBool, required = false,
                                 default = newJBool(true))
  if valid_589472 != nil:
    section.add "prettyPrint", valid_589472
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

proc call*(call_589474: Call_AndroidpublisherEditsListingsPatch_589460;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a localized store listing. This method supports patch semantics.
  ## 
  let valid = call_589474.validator(path, query, header, formData, body)
  let scheme = call_589474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589474.url(scheme.get, call_589474.host, call_589474.base,
                         call_589474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589474, url, valid)

proc call*(call_589475: Call_AndroidpublisherEditsListingsPatch_589460;
          packageName: string; editId: string; language: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsListingsPatch
  ## Creates or updates a localized store listing. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589476 = newJObject()
  var query_589477 = newJObject()
  var body_589478 = newJObject()
  add(query_589477, "fields", newJString(fields))
  add(path_589476, "packageName", newJString(packageName))
  add(query_589477, "quotaUser", newJString(quotaUser))
  add(query_589477, "alt", newJString(alt))
  add(path_589476, "editId", newJString(editId))
  add(query_589477, "oauth_token", newJString(oauthToken))
  add(path_589476, "language", newJString(language))
  add(query_589477, "userIp", newJString(userIp))
  add(query_589477, "key", newJString(key))
  if body != nil:
    body_589478 = body
  add(query_589477, "prettyPrint", newJBool(prettyPrint))
  result = call_589475.call(path_589476, query_589477, nil, nil, body_589478)

var androidpublisherEditsListingsPatch* = Call_AndroidpublisherEditsListingsPatch_589460(
    name: "androidpublisherEditsListingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsPatch_589461,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsPatch_589462, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsDelete_589443 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsListingsDelete_589445(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsListingsDelete_589444(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified localized store listing from an edit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589446 = path.getOrDefault("packageName")
  valid_589446 = validateParameter(valid_589446, JString, required = true,
                                 default = nil)
  if valid_589446 != nil:
    section.add "packageName", valid_589446
  var valid_589447 = path.getOrDefault("editId")
  valid_589447 = validateParameter(valid_589447, JString, required = true,
                                 default = nil)
  if valid_589447 != nil:
    section.add "editId", valid_589447
  var valid_589448 = path.getOrDefault("language")
  valid_589448 = validateParameter(valid_589448, JString, required = true,
                                 default = nil)
  if valid_589448 != nil:
    section.add "language", valid_589448
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589449 = query.getOrDefault("fields")
  valid_589449 = validateParameter(valid_589449, JString, required = false,
                                 default = nil)
  if valid_589449 != nil:
    section.add "fields", valid_589449
  var valid_589450 = query.getOrDefault("quotaUser")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "quotaUser", valid_589450
  var valid_589451 = query.getOrDefault("alt")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = newJString("json"))
  if valid_589451 != nil:
    section.add "alt", valid_589451
  var valid_589452 = query.getOrDefault("oauth_token")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = nil)
  if valid_589452 != nil:
    section.add "oauth_token", valid_589452
  var valid_589453 = query.getOrDefault("userIp")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = nil)
  if valid_589453 != nil:
    section.add "userIp", valid_589453
  var valid_589454 = query.getOrDefault("key")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "key", valid_589454
  var valid_589455 = query.getOrDefault("prettyPrint")
  valid_589455 = validateParameter(valid_589455, JBool, required = false,
                                 default = newJBool(true))
  if valid_589455 != nil:
    section.add "prettyPrint", valid_589455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589456: Call_AndroidpublisherEditsListingsDelete_589443;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified localized store listing from an edit.
  ## 
  let valid = call_589456.validator(path, query, header, formData, body)
  let scheme = call_589456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589456.url(scheme.get, call_589456.host, call_589456.base,
                         call_589456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589456, url, valid)

proc call*(call_589457: Call_AndroidpublisherEditsListingsDelete_589443;
          packageName: string; editId: string; language: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsListingsDelete
  ## Deletes the specified localized store listing from an edit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589458 = newJObject()
  var query_589459 = newJObject()
  add(query_589459, "fields", newJString(fields))
  add(path_589458, "packageName", newJString(packageName))
  add(query_589459, "quotaUser", newJString(quotaUser))
  add(query_589459, "alt", newJString(alt))
  add(path_589458, "editId", newJString(editId))
  add(query_589459, "oauth_token", newJString(oauthToken))
  add(path_589458, "language", newJString(language))
  add(query_589459, "userIp", newJString(userIp))
  add(query_589459, "key", newJString(key))
  add(query_589459, "prettyPrint", newJBool(prettyPrint))
  result = call_589457.call(path_589458, query_589459, nil, nil, nil)

var androidpublisherEditsListingsDelete* = Call_AndroidpublisherEditsListingsDelete_589443(
    name: "androidpublisherEditsListingsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsDelete_589444,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsDelete_589445, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesUpload_589497 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsImagesUpload_589499(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  assert "imageType" in path, "`imageType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "imageType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsImagesUpload_589498(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a new image and adds it to the list of images for the specified language and image type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   imageType: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589500 = path.getOrDefault("packageName")
  valid_589500 = validateParameter(valid_589500, JString, required = true,
                                 default = nil)
  if valid_589500 != nil:
    section.add "packageName", valid_589500
  var valid_589501 = path.getOrDefault("editId")
  valid_589501 = validateParameter(valid_589501, JString, required = true,
                                 default = nil)
  if valid_589501 != nil:
    section.add "editId", valid_589501
  var valid_589502 = path.getOrDefault("language")
  valid_589502 = validateParameter(valid_589502, JString, required = true,
                                 default = nil)
  if valid_589502 != nil:
    section.add "language", valid_589502
  var valid_589503 = path.getOrDefault("imageType")
  valid_589503 = validateParameter(valid_589503, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_589503 != nil:
    section.add "imageType", valid_589503
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589504 = query.getOrDefault("fields")
  valid_589504 = validateParameter(valid_589504, JString, required = false,
                                 default = nil)
  if valid_589504 != nil:
    section.add "fields", valid_589504
  var valid_589505 = query.getOrDefault("quotaUser")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = nil)
  if valid_589505 != nil:
    section.add "quotaUser", valid_589505
  var valid_589506 = query.getOrDefault("alt")
  valid_589506 = validateParameter(valid_589506, JString, required = false,
                                 default = newJString("json"))
  if valid_589506 != nil:
    section.add "alt", valid_589506
  var valid_589507 = query.getOrDefault("oauth_token")
  valid_589507 = validateParameter(valid_589507, JString, required = false,
                                 default = nil)
  if valid_589507 != nil:
    section.add "oauth_token", valid_589507
  var valid_589508 = query.getOrDefault("userIp")
  valid_589508 = validateParameter(valid_589508, JString, required = false,
                                 default = nil)
  if valid_589508 != nil:
    section.add "userIp", valid_589508
  var valid_589509 = query.getOrDefault("key")
  valid_589509 = validateParameter(valid_589509, JString, required = false,
                                 default = nil)
  if valid_589509 != nil:
    section.add "key", valid_589509
  var valid_589510 = query.getOrDefault("prettyPrint")
  valid_589510 = validateParameter(valid_589510, JBool, required = false,
                                 default = newJBool(true))
  if valid_589510 != nil:
    section.add "prettyPrint", valid_589510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589511: Call_AndroidpublisherEditsImagesUpload_589497;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a new image and adds it to the list of images for the specified language and image type.
  ## 
  let valid = call_589511.validator(path, query, header, formData, body)
  let scheme = call_589511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589511.url(scheme.get, call_589511.host, call_589511.base,
                         call_589511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589511, url, valid)

proc call*(call_589512: Call_AndroidpublisherEditsImagesUpload_589497;
          packageName: string; editId: string; language: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; imageType: string = "featureGraphic"; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsImagesUpload
  ## Uploads a new image and adds it to the list of images for the specified language and image type.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   imageType: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589513 = newJObject()
  var query_589514 = newJObject()
  add(query_589514, "fields", newJString(fields))
  add(path_589513, "packageName", newJString(packageName))
  add(query_589514, "quotaUser", newJString(quotaUser))
  add(query_589514, "alt", newJString(alt))
  add(path_589513, "editId", newJString(editId))
  add(query_589514, "oauth_token", newJString(oauthToken))
  add(path_589513, "language", newJString(language))
  add(query_589514, "userIp", newJString(userIp))
  add(path_589513, "imageType", newJString(imageType))
  add(query_589514, "key", newJString(key))
  add(query_589514, "prettyPrint", newJBool(prettyPrint))
  result = call_589512.call(path_589513, query_589514, nil, nil, nil)

var androidpublisherEditsImagesUpload* = Call_AndroidpublisherEditsImagesUpload_589497(
    name: "androidpublisherEditsImagesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesUpload_589498,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsImagesUpload_589499, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesList_589479 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsImagesList_589481(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  assert "imageType" in path, "`imageType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "imageType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsImagesList_589480(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all images for the specified language and image type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   imageType: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589482 = path.getOrDefault("packageName")
  valid_589482 = validateParameter(valid_589482, JString, required = true,
                                 default = nil)
  if valid_589482 != nil:
    section.add "packageName", valid_589482
  var valid_589483 = path.getOrDefault("editId")
  valid_589483 = validateParameter(valid_589483, JString, required = true,
                                 default = nil)
  if valid_589483 != nil:
    section.add "editId", valid_589483
  var valid_589484 = path.getOrDefault("language")
  valid_589484 = validateParameter(valid_589484, JString, required = true,
                                 default = nil)
  if valid_589484 != nil:
    section.add "language", valid_589484
  var valid_589485 = path.getOrDefault("imageType")
  valid_589485 = validateParameter(valid_589485, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_589485 != nil:
    section.add "imageType", valid_589485
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589486 = query.getOrDefault("fields")
  valid_589486 = validateParameter(valid_589486, JString, required = false,
                                 default = nil)
  if valid_589486 != nil:
    section.add "fields", valid_589486
  var valid_589487 = query.getOrDefault("quotaUser")
  valid_589487 = validateParameter(valid_589487, JString, required = false,
                                 default = nil)
  if valid_589487 != nil:
    section.add "quotaUser", valid_589487
  var valid_589488 = query.getOrDefault("alt")
  valid_589488 = validateParameter(valid_589488, JString, required = false,
                                 default = newJString("json"))
  if valid_589488 != nil:
    section.add "alt", valid_589488
  var valid_589489 = query.getOrDefault("oauth_token")
  valid_589489 = validateParameter(valid_589489, JString, required = false,
                                 default = nil)
  if valid_589489 != nil:
    section.add "oauth_token", valid_589489
  var valid_589490 = query.getOrDefault("userIp")
  valid_589490 = validateParameter(valid_589490, JString, required = false,
                                 default = nil)
  if valid_589490 != nil:
    section.add "userIp", valid_589490
  var valid_589491 = query.getOrDefault("key")
  valid_589491 = validateParameter(valid_589491, JString, required = false,
                                 default = nil)
  if valid_589491 != nil:
    section.add "key", valid_589491
  var valid_589492 = query.getOrDefault("prettyPrint")
  valid_589492 = validateParameter(valid_589492, JBool, required = false,
                                 default = newJBool(true))
  if valid_589492 != nil:
    section.add "prettyPrint", valid_589492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589493: Call_AndroidpublisherEditsImagesList_589479;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all images for the specified language and image type.
  ## 
  let valid = call_589493.validator(path, query, header, formData, body)
  let scheme = call_589493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589493.url(scheme.get, call_589493.host, call_589493.base,
                         call_589493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589493, url, valid)

proc call*(call_589494: Call_AndroidpublisherEditsImagesList_589479;
          packageName: string; editId: string; language: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; imageType: string = "featureGraphic"; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsImagesList
  ## Lists all images for the specified language and image type.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   imageType: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589495 = newJObject()
  var query_589496 = newJObject()
  add(query_589496, "fields", newJString(fields))
  add(path_589495, "packageName", newJString(packageName))
  add(query_589496, "quotaUser", newJString(quotaUser))
  add(query_589496, "alt", newJString(alt))
  add(path_589495, "editId", newJString(editId))
  add(query_589496, "oauth_token", newJString(oauthToken))
  add(path_589495, "language", newJString(language))
  add(query_589496, "userIp", newJString(userIp))
  add(path_589495, "imageType", newJString(imageType))
  add(query_589496, "key", newJString(key))
  add(query_589496, "prettyPrint", newJBool(prettyPrint))
  result = call_589494.call(path_589495, query_589496, nil, nil, nil)

var androidpublisherEditsImagesList* = Call_AndroidpublisherEditsImagesList_589479(
    name: "androidpublisherEditsImagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesList_589480,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsImagesList_589481, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesDeleteall_589515 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsImagesDeleteall_589517(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  assert "imageType" in path, "`imageType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "imageType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsImagesDeleteall_589516(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes all images for the specified language and image type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   imageType: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589518 = path.getOrDefault("packageName")
  valid_589518 = validateParameter(valid_589518, JString, required = true,
                                 default = nil)
  if valid_589518 != nil:
    section.add "packageName", valid_589518
  var valid_589519 = path.getOrDefault("editId")
  valid_589519 = validateParameter(valid_589519, JString, required = true,
                                 default = nil)
  if valid_589519 != nil:
    section.add "editId", valid_589519
  var valid_589520 = path.getOrDefault("language")
  valid_589520 = validateParameter(valid_589520, JString, required = true,
                                 default = nil)
  if valid_589520 != nil:
    section.add "language", valid_589520
  var valid_589521 = path.getOrDefault("imageType")
  valid_589521 = validateParameter(valid_589521, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_589521 != nil:
    section.add "imageType", valid_589521
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589522 = query.getOrDefault("fields")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = nil)
  if valid_589522 != nil:
    section.add "fields", valid_589522
  var valid_589523 = query.getOrDefault("quotaUser")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "quotaUser", valid_589523
  var valid_589524 = query.getOrDefault("alt")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = newJString("json"))
  if valid_589524 != nil:
    section.add "alt", valid_589524
  var valid_589525 = query.getOrDefault("oauth_token")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = nil)
  if valid_589525 != nil:
    section.add "oauth_token", valid_589525
  var valid_589526 = query.getOrDefault("userIp")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = nil)
  if valid_589526 != nil:
    section.add "userIp", valid_589526
  var valid_589527 = query.getOrDefault("key")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = nil)
  if valid_589527 != nil:
    section.add "key", valid_589527
  var valid_589528 = query.getOrDefault("prettyPrint")
  valid_589528 = validateParameter(valid_589528, JBool, required = false,
                                 default = newJBool(true))
  if valid_589528 != nil:
    section.add "prettyPrint", valid_589528
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589529: Call_AndroidpublisherEditsImagesDeleteall_589515;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all images for the specified language and image type.
  ## 
  let valid = call_589529.validator(path, query, header, formData, body)
  let scheme = call_589529.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589529.url(scheme.get, call_589529.host, call_589529.base,
                         call_589529.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589529, url, valid)

proc call*(call_589530: Call_AndroidpublisherEditsImagesDeleteall_589515;
          packageName: string; editId: string; language: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; imageType: string = "featureGraphic"; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsImagesDeleteall
  ## Deletes all images for the specified language and image type.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   imageType: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589531 = newJObject()
  var query_589532 = newJObject()
  add(query_589532, "fields", newJString(fields))
  add(path_589531, "packageName", newJString(packageName))
  add(query_589532, "quotaUser", newJString(quotaUser))
  add(query_589532, "alt", newJString(alt))
  add(path_589531, "editId", newJString(editId))
  add(query_589532, "oauth_token", newJString(oauthToken))
  add(path_589531, "language", newJString(language))
  add(query_589532, "userIp", newJString(userIp))
  add(path_589531, "imageType", newJString(imageType))
  add(query_589532, "key", newJString(key))
  add(query_589532, "prettyPrint", newJBool(prettyPrint))
  result = call_589530.call(path_589531, query_589532, nil, nil, nil)

var androidpublisherEditsImagesDeleteall* = Call_AndroidpublisherEditsImagesDeleteall_589515(
    name: "androidpublisherEditsImagesDeleteall", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesDeleteall_589516,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsImagesDeleteall_589517, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesDelete_589533 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsImagesDelete_589535(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  assert "imageType" in path, "`imageType` is a required path parameter"
  assert "imageId" in path, "`imageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "imageType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "imageId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsImagesDelete_589534(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the image (specified by id) from the edit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageId: JString (required)
  ##          : Unique identifier an image within the set of images attached to this edit.
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   imageType: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `imageId` field"
  var valid_589536 = path.getOrDefault("imageId")
  valid_589536 = validateParameter(valid_589536, JString, required = true,
                                 default = nil)
  if valid_589536 != nil:
    section.add "imageId", valid_589536
  var valid_589537 = path.getOrDefault("packageName")
  valid_589537 = validateParameter(valid_589537, JString, required = true,
                                 default = nil)
  if valid_589537 != nil:
    section.add "packageName", valid_589537
  var valid_589538 = path.getOrDefault("editId")
  valid_589538 = validateParameter(valid_589538, JString, required = true,
                                 default = nil)
  if valid_589538 != nil:
    section.add "editId", valid_589538
  var valid_589539 = path.getOrDefault("language")
  valid_589539 = validateParameter(valid_589539, JString, required = true,
                                 default = nil)
  if valid_589539 != nil:
    section.add "language", valid_589539
  var valid_589540 = path.getOrDefault("imageType")
  valid_589540 = validateParameter(valid_589540, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_589540 != nil:
    section.add "imageType", valid_589540
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589541 = query.getOrDefault("fields")
  valid_589541 = validateParameter(valid_589541, JString, required = false,
                                 default = nil)
  if valid_589541 != nil:
    section.add "fields", valid_589541
  var valid_589542 = query.getOrDefault("quotaUser")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = nil)
  if valid_589542 != nil:
    section.add "quotaUser", valid_589542
  var valid_589543 = query.getOrDefault("alt")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = newJString("json"))
  if valid_589543 != nil:
    section.add "alt", valid_589543
  var valid_589544 = query.getOrDefault("oauth_token")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = nil)
  if valid_589544 != nil:
    section.add "oauth_token", valid_589544
  var valid_589545 = query.getOrDefault("userIp")
  valid_589545 = validateParameter(valid_589545, JString, required = false,
                                 default = nil)
  if valid_589545 != nil:
    section.add "userIp", valid_589545
  var valid_589546 = query.getOrDefault("key")
  valid_589546 = validateParameter(valid_589546, JString, required = false,
                                 default = nil)
  if valid_589546 != nil:
    section.add "key", valid_589546
  var valid_589547 = query.getOrDefault("prettyPrint")
  valid_589547 = validateParameter(valid_589547, JBool, required = false,
                                 default = newJBool(true))
  if valid_589547 != nil:
    section.add "prettyPrint", valid_589547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589548: Call_AndroidpublisherEditsImagesDelete_589533;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the image (specified by id) from the edit.
  ## 
  let valid = call_589548.validator(path, query, header, formData, body)
  let scheme = call_589548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589548.url(scheme.get, call_589548.host, call_589548.base,
                         call_589548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589548, url, valid)

proc call*(call_589549: Call_AndroidpublisherEditsImagesDelete_589533;
          imageId: string; packageName: string; editId: string; language: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = "";
          imageType: string = "featureGraphic"; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsImagesDelete
  ## Deletes the image (specified by id) from the edit.
  ##   imageId: string (required)
  ##          : Unique identifier an image within the set of images attached to this edit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   imageType: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589550 = newJObject()
  var query_589551 = newJObject()
  add(path_589550, "imageId", newJString(imageId))
  add(query_589551, "fields", newJString(fields))
  add(path_589550, "packageName", newJString(packageName))
  add(query_589551, "quotaUser", newJString(quotaUser))
  add(query_589551, "alt", newJString(alt))
  add(path_589550, "editId", newJString(editId))
  add(query_589551, "oauth_token", newJString(oauthToken))
  add(path_589550, "language", newJString(language))
  add(query_589551, "userIp", newJString(userIp))
  add(path_589550, "imageType", newJString(imageType))
  add(query_589551, "key", newJString(key))
  add(query_589551, "prettyPrint", newJBool(prettyPrint))
  result = call_589549.call(path_589550, query_589551, nil, nil, nil)

var androidpublisherEditsImagesDelete* = Call_AndroidpublisherEditsImagesDelete_589533(
    name: "androidpublisherEditsImagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}/{imageId}",
    validator: validate_AndroidpublisherEditsImagesDelete_589534,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsImagesDelete_589535, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersUpdate_589569 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsTestersUpdate_589571(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "track" in path, "`track` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/testers/"),
               (kind: VariableSegment, value: "track")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsTestersUpdate_589570(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   track: JString (required)
  ##        : The track to read or modify.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589572 = path.getOrDefault("packageName")
  valid_589572 = validateParameter(valid_589572, JString, required = true,
                                 default = nil)
  if valid_589572 != nil:
    section.add "packageName", valid_589572
  var valid_589573 = path.getOrDefault("editId")
  valid_589573 = validateParameter(valid_589573, JString, required = true,
                                 default = nil)
  if valid_589573 != nil:
    section.add "editId", valid_589573
  var valid_589574 = path.getOrDefault("track")
  valid_589574 = validateParameter(valid_589574, JString, required = true,
                                 default = nil)
  if valid_589574 != nil:
    section.add "track", valid_589574
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589575 = query.getOrDefault("fields")
  valid_589575 = validateParameter(valid_589575, JString, required = false,
                                 default = nil)
  if valid_589575 != nil:
    section.add "fields", valid_589575
  var valid_589576 = query.getOrDefault("quotaUser")
  valid_589576 = validateParameter(valid_589576, JString, required = false,
                                 default = nil)
  if valid_589576 != nil:
    section.add "quotaUser", valid_589576
  var valid_589577 = query.getOrDefault("alt")
  valid_589577 = validateParameter(valid_589577, JString, required = false,
                                 default = newJString("json"))
  if valid_589577 != nil:
    section.add "alt", valid_589577
  var valid_589578 = query.getOrDefault("oauth_token")
  valid_589578 = validateParameter(valid_589578, JString, required = false,
                                 default = nil)
  if valid_589578 != nil:
    section.add "oauth_token", valid_589578
  var valid_589579 = query.getOrDefault("userIp")
  valid_589579 = validateParameter(valid_589579, JString, required = false,
                                 default = nil)
  if valid_589579 != nil:
    section.add "userIp", valid_589579
  var valid_589580 = query.getOrDefault("key")
  valid_589580 = validateParameter(valid_589580, JString, required = false,
                                 default = nil)
  if valid_589580 != nil:
    section.add "key", valid_589580
  var valid_589581 = query.getOrDefault("prettyPrint")
  valid_589581 = validateParameter(valid_589581, JBool, required = false,
                                 default = newJBool(true))
  if valid_589581 != nil:
    section.add "prettyPrint", valid_589581
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

proc call*(call_589583: Call_AndroidpublisherEditsTestersUpdate_589569;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_589583.validator(path, query, header, formData, body)
  let scheme = call_589583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589583.url(scheme.get, call_589583.host, call_589583.base,
                         call_589583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589583, url, valid)

proc call*(call_589584: Call_AndroidpublisherEditsTestersUpdate_589569;
          packageName: string; editId: string; track: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsTestersUpdate
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   track: string (required)
  ##        : The track to read or modify.
  var path_589585 = newJObject()
  var query_589586 = newJObject()
  var body_589587 = newJObject()
  add(query_589586, "fields", newJString(fields))
  add(path_589585, "packageName", newJString(packageName))
  add(query_589586, "quotaUser", newJString(quotaUser))
  add(query_589586, "alt", newJString(alt))
  add(path_589585, "editId", newJString(editId))
  add(query_589586, "oauth_token", newJString(oauthToken))
  add(query_589586, "userIp", newJString(userIp))
  add(query_589586, "key", newJString(key))
  if body != nil:
    body_589587 = body
  add(query_589586, "prettyPrint", newJBool(prettyPrint))
  add(path_589585, "track", newJString(track))
  result = call_589584.call(path_589585, query_589586, nil, nil, body_589587)

var androidpublisherEditsTestersUpdate* = Call_AndroidpublisherEditsTestersUpdate_589569(
    name: "androidpublisherEditsTestersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersUpdate_589570,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTestersUpdate_589571, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersGet_589552 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsTestersGet_589554(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "track" in path, "`track` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/testers/"),
               (kind: VariableSegment, value: "track")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsTestersGet_589553(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   track: JString (required)
  ##        : The track to read or modify.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589555 = path.getOrDefault("packageName")
  valid_589555 = validateParameter(valid_589555, JString, required = true,
                                 default = nil)
  if valid_589555 != nil:
    section.add "packageName", valid_589555
  var valid_589556 = path.getOrDefault("editId")
  valid_589556 = validateParameter(valid_589556, JString, required = true,
                                 default = nil)
  if valid_589556 != nil:
    section.add "editId", valid_589556
  var valid_589557 = path.getOrDefault("track")
  valid_589557 = validateParameter(valid_589557, JString, required = true,
                                 default = nil)
  if valid_589557 != nil:
    section.add "track", valid_589557
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589558 = query.getOrDefault("fields")
  valid_589558 = validateParameter(valid_589558, JString, required = false,
                                 default = nil)
  if valid_589558 != nil:
    section.add "fields", valid_589558
  var valid_589559 = query.getOrDefault("quotaUser")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "quotaUser", valid_589559
  var valid_589560 = query.getOrDefault("alt")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = newJString("json"))
  if valid_589560 != nil:
    section.add "alt", valid_589560
  var valid_589561 = query.getOrDefault("oauth_token")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = nil)
  if valid_589561 != nil:
    section.add "oauth_token", valid_589561
  var valid_589562 = query.getOrDefault("userIp")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = nil)
  if valid_589562 != nil:
    section.add "userIp", valid_589562
  var valid_589563 = query.getOrDefault("key")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = nil)
  if valid_589563 != nil:
    section.add "key", valid_589563
  var valid_589564 = query.getOrDefault("prettyPrint")
  valid_589564 = validateParameter(valid_589564, JBool, required = false,
                                 default = newJBool(true))
  if valid_589564 != nil:
    section.add "prettyPrint", valid_589564
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589565: Call_AndroidpublisherEditsTestersGet_589552;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_589565.validator(path, query, header, formData, body)
  let scheme = call_589565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589565.url(scheme.get, call_589565.host, call_589565.base,
                         call_589565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589565, url, valid)

proc call*(call_589566: Call_AndroidpublisherEditsTestersGet_589552;
          packageName: string; editId: string; track: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsTestersGet
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   track: string (required)
  ##        : The track to read or modify.
  var path_589567 = newJObject()
  var query_589568 = newJObject()
  add(query_589568, "fields", newJString(fields))
  add(path_589567, "packageName", newJString(packageName))
  add(query_589568, "quotaUser", newJString(quotaUser))
  add(query_589568, "alt", newJString(alt))
  add(path_589567, "editId", newJString(editId))
  add(query_589568, "oauth_token", newJString(oauthToken))
  add(query_589568, "userIp", newJString(userIp))
  add(query_589568, "key", newJString(key))
  add(query_589568, "prettyPrint", newJBool(prettyPrint))
  add(path_589567, "track", newJString(track))
  result = call_589566.call(path_589567, query_589568, nil, nil, nil)

var androidpublisherEditsTestersGet* = Call_AndroidpublisherEditsTestersGet_589552(
    name: "androidpublisherEditsTestersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersGet_589553,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTestersGet_589554, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersPatch_589588 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsTestersPatch_589590(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "track" in path, "`track` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/testers/"),
               (kind: VariableSegment, value: "track")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsTestersPatch_589589(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   track: JString (required)
  ##        : The track to read or modify.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589591 = path.getOrDefault("packageName")
  valid_589591 = validateParameter(valid_589591, JString, required = true,
                                 default = nil)
  if valid_589591 != nil:
    section.add "packageName", valid_589591
  var valid_589592 = path.getOrDefault("editId")
  valid_589592 = validateParameter(valid_589592, JString, required = true,
                                 default = nil)
  if valid_589592 != nil:
    section.add "editId", valid_589592
  var valid_589593 = path.getOrDefault("track")
  valid_589593 = validateParameter(valid_589593, JString, required = true,
                                 default = nil)
  if valid_589593 != nil:
    section.add "track", valid_589593
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589594 = query.getOrDefault("fields")
  valid_589594 = validateParameter(valid_589594, JString, required = false,
                                 default = nil)
  if valid_589594 != nil:
    section.add "fields", valid_589594
  var valid_589595 = query.getOrDefault("quotaUser")
  valid_589595 = validateParameter(valid_589595, JString, required = false,
                                 default = nil)
  if valid_589595 != nil:
    section.add "quotaUser", valid_589595
  var valid_589596 = query.getOrDefault("alt")
  valid_589596 = validateParameter(valid_589596, JString, required = false,
                                 default = newJString("json"))
  if valid_589596 != nil:
    section.add "alt", valid_589596
  var valid_589597 = query.getOrDefault("oauth_token")
  valid_589597 = validateParameter(valid_589597, JString, required = false,
                                 default = nil)
  if valid_589597 != nil:
    section.add "oauth_token", valid_589597
  var valid_589598 = query.getOrDefault("userIp")
  valid_589598 = validateParameter(valid_589598, JString, required = false,
                                 default = nil)
  if valid_589598 != nil:
    section.add "userIp", valid_589598
  var valid_589599 = query.getOrDefault("key")
  valid_589599 = validateParameter(valid_589599, JString, required = false,
                                 default = nil)
  if valid_589599 != nil:
    section.add "key", valid_589599
  var valid_589600 = query.getOrDefault("prettyPrint")
  valid_589600 = validateParameter(valid_589600, JBool, required = false,
                                 default = newJBool(true))
  if valid_589600 != nil:
    section.add "prettyPrint", valid_589600
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

proc call*(call_589602: Call_AndroidpublisherEditsTestersPatch_589588;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_589602.validator(path, query, header, formData, body)
  let scheme = call_589602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589602.url(scheme.get, call_589602.host, call_589602.base,
                         call_589602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589602, url, valid)

proc call*(call_589603: Call_AndroidpublisherEditsTestersPatch_589588;
          packageName: string; editId: string; track: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsTestersPatch
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   track: string (required)
  ##        : The track to read or modify.
  var path_589604 = newJObject()
  var query_589605 = newJObject()
  var body_589606 = newJObject()
  add(query_589605, "fields", newJString(fields))
  add(path_589604, "packageName", newJString(packageName))
  add(query_589605, "quotaUser", newJString(quotaUser))
  add(query_589605, "alt", newJString(alt))
  add(path_589604, "editId", newJString(editId))
  add(query_589605, "oauth_token", newJString(oauthToken))
  add(query_589605, "userIp", newJString(userIp))
  add(query_589605, "key", newJString(key))
  if body != nil:
    body_589606 = body
  add(query_589605, "prettyPrint", newJBool(prettyPrint))
  add(path_589604, "track", newJString(track))
  result = call_589603.call(path_589604, query_589605, nil, nil, body_589606)

var androidpublisherEditsTestersPatch* = Call_AndroidpublisherEditsTestersPatch_589588(
    name: "androidpublisherEditsTestersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersPatch_589589,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTestersPatch_589590, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksList_589607 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsTracksList_589609(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/tracks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsTracksList_589608(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the track configurations for this edit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589610 = path.getOrDefault("packageName")
  valid_589610 = validateParameter(valid_589610, JString, required = true,
                                 default = nil)
  if valid_589610 != nil:
    section.add "packageName", valid_589610
  var valid_589611 = path.getOrDefault("editId")
  valid_589611 = validateParameter(valid_589611, JString, required = true,
                                 default = nil)
  if valid_589611 != nil:
    section.add "editId", valid_589611
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589612 = query.getOrDefault("fields")
  valid_589612 = validateParameter(valid_589612, JString, required = false,
                                 default = nil)
  if valid_589612 != nil:
    section.add "fields", valid_589612
  var valid_589613 = query.getOrDefault("quotaUser")
  valid_589613 = validateParameter(valid_589613, JString, required = false,
                                 default = nil)
  if valid_589613 != nil:
    section.add "quotaUser", valid_589613
  var valid_589614 = query.getOrDefault("alt")
  valid_589614 = validateParameter(valid_589614, JString, required = false,
                                 default = newJString("json"))
  if valid_589614 != nil:
    section.add "alt", valid_589614
  var valid_589615 = query.getOrDefault("oauth_token")
  valid_589615 = validateParameter(valid_589615, JString, required = false,
                                 default = nil)
  if valid_589615 != nil:
    section.add "oauth_token", valid_589615
  var valid_589616 = query.getOrDefault("userIp")
  valid_589616 = validateParameter(valid_589616, JString, required = false,
                                 default = nil)
  if valid_589616 != nil:
    section.add "userIp", valid_589616
  var valid_589617 = query.getOrDefault("key")
  valid_589617 = validateParameter(valid_589617, JString, required = false,
                                 default = nil)
  if valid_589617 != nil:
    section.add "key", valid_589617
  var valid_589618 = query.getOrDefault("prettyPrint")
  valid_589618 = validateParameter(valid_589618, JBool, required = false,
                                 default = newJBool(true))
  if valid_589618 != nil:
    section.add "prettyPrint", valid_589618
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589619: Call_AndroidpublisherEditsTracksList_589607;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the track configurations for this edit.
  ## 
  let valid = call_589619.validator(path, query, header, formData, body)
  let scheme = call_589619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589619.url(scheme.get, call_589619.host, call_589619.base,
                         call_589619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589619, url, valid)

proc call*(call_589620: Call_AndroidpublisherEditsTracksList_589607;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsTracksList
  ## Lists all the track configurations for this edit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589621 = newJObject()
  var query_589622 = newJObject()
  add(query_589622, "fields", newJString(fields))
  add(path_589621, "packageName", newJString(packageName))
  add(query_589622, "quotaUser", newJString(quotaUser))
  add(query_589622, "alt", newJString(alt))
  add(path_589621, "editId", newJString(editId))
  add(query_589622, "oauth_token", newJString(oauthToken))
  add(query_589622, "userIp", newJString(userIp))
  add(query_589622, "key", newJString(key))
  add(query_589622, "prettyPrint", newJBool(prettyPrint))
  result = call_589620.call(path_589621, query_589622, nil, nil, nil)

var androidpublisherEditsTracksList* = Call_AndroidpublisherEditsTracksList_589607(
    name: "androidpublisherEditsTracksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/tracks",
    validator: validate_AndroidpublisherEditsTracksList_589608,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTracksList_589609, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksUpdate_589640 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsTracksUpdate_589642(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "track" in path, "`track` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/tracks/"),
               (kind: VariableSegment, value: "track")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsTracksUpdate_589641(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the track configuration for the specified track type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   track: JString (required)
  ##        : The track to read or modify.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589643 = path.getOrDefault("packageName")
  valid_589643 = validateParameter(valid_589643, JString, required = true,
                                 default = nil)
  if valid_589643 != nil:
    section.add "packageName", valid_589643
  var valid_589644 = path.getOrDefault("editId")
  valid_589644 = validateParameter(valid_589644, JString, required = true,
                                 default = nil)
  if valid_589644 != nil:
    section.add "editId", valid_589644
  var valid_589645 = path.getOrDefault("track")
  valid_589645 = validateParameter(valid_589645, JString, required = true,
                                 default = nil)
  if valid_589645 != nil:
    section.add "track", valid_589645
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589646 = query.getOrDefault("fields")
  valid_589646 = validateParameter(valid_589646, JString, required = false,
                                 default = nil)
  if valid_589646 != nil:
    section.add "fields", valid_589646
  var valid_589647 = query.getOrDefault("quotaUser")
  valid_589647 = validateParameter(valid_589647, JString, required = false,
                                 default = nil)
  if valid_589647 != nil:
    section.add "quotaUser", valid_589647
  var valid_589648 = query.getOrDefault("alt")
  valid_589648 = validateParameter(valid_589648, JString, required = false,
                                 default = newJString("json"))
  if valid_589648 != nil:
    section.add "alt", valid_589648
  var valid_589649 = query.getOrDefault("oauth_token")
  valid_589649 = validateParameter(valid_589649, JString, required = false,
                                 default = nil)
  if valid_589649 != nil:
    section.add "oauth_token", valid_589649
  var valid_589650 = query.getOrDefault("userIp")
  valid_589650 = validateParameter(valid_589650, JString, required = false,
                                 default = nil)
  if valid_589650 != nil:
    section.add "userIp", valid_589650
  var valid_589651 = query.getOrDefault("key")
  valid_589651 = validateParameter(valid_589651, JString, required = false,
                                 default = nil)
  if valid_589651 != nil:
    section.add "key", valid_589651
  var valid_589652 = query.getOrDefault("prettyPrint")
  valid_589652 = validateParameter(valid_589652, JBool, required = false,
                                 default = newJBool(true))
  if valid_589652 != nil:
    section.add "prettyPrint", valid_589652
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

proc call*(call_589654: Call_AndroidpublisherEditsTracksUpdate_589640;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the track configuration for the specified track type.
  ## 
  let valid = call_589654.validator(path, query, header, formData, body)
  let scheme = call_589654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589654.url(scheme.get, call_589654.host, call_589654.base,
                         call_589654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589654, url, valid)

proc call*(call_589655: Call_AndroidpublisherEditsTracksUpdate_589640;
          packageName: string; editId: string; track: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsTracksUpdate
  ## Updates the track configuration for the specified track type.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   track: string (required)
  ##        : The track to read or modify.
  var path_589656 = newJObject()
  var query_589657 = newJObject()
  var body_589658 = newJObject()
  add(query_589657, "fields", newJString(fields))
  add(path_589656, "packageName", newJString(packageName))
  add(query_589657, "quotaUser", newJString(quotaUser))
  add(query_589657, "alt", newJString(alt))
  add(path_589656, "editId", newJString(editId))
  add(query_589657, "oauth_token", newJString(oauthToken))
  add(query_589657, "userIp", newJString(userIp))
  add(query_589657, "key", newJString(key))
  if body != nil:
    body_589658 = body
  add(query_589657, "prettyPrint", newJBool(prettyPrint))
  add(path_589656, "track", newJString(track))
  result = call_589655.call(path_589656, query_589657, nil, nil, body_589658)

var androidpublisherEditsTracksUpdate* = Call_AndroidpublisherEditsTracksUpdate_589640(
    name: "androidpublisherEditsTracksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksUpdate_589641,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTracksUpdate_589642, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksGet_589623 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsTracksGet_589625(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "track" in path, "`track` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/tracks/"),
               (kind: VariableSegment, value: "track")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsTracksGet_589624(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the track configuration for the specified track type. Includes the APK version codes that are in this track.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   track: JString (required)
  ##        : The track to read or modify.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589626 = path.getOrDefault("packageName")
  valid_589626 = validateParameter(valid_589626, JString, required = true,
                                 default = nil)
  if valid_589626 != nil:
    section.add "packageName", valid_589626
  var valid_589627 = path.getOrDefault("editId")
  valid_589627 = validateParameter(valid_589627, JString, required = true,
                                 default = nil)
  if valid_589627 != nil:
    section.add "editId", valid_589627
  var valid_589628 = path.getOrDefault("track")
  valid_589628 = validateParameter(valid_589628, JString, required = true,
                                 default = nil)
  if valid_589628 != nil:
    section.add "track", valid_589628
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589629 = query.getOrDefault("fields")
  valid_589629 = validateParameter(valid_589629, JString, required = false,
                                 default = nil)
  if valid_589629 != nil:
    section.add "fields", valid_589629
  var valid_589630 = query.getOrDefault("quotaUser")
  valid_589630 = validateParameter(valid_589630, JString, required = false,
                                 default = nil)
  if valid_589630 != nil:
    section.add "quotaUser", valid_589630
  var valid_589631 = query.getOrDefault("alt")
  valid_589631 = validateParameter(valid_589631, JString, required = false,
                                 default = newJString("json"))
  if valid_589631 != nil:
    section.add "alt", valid_589631
  var valid_589632 = query.getOrDefault("oauth_token")
  valid_589632 = validateParameter(valid_589632, JString, required = false,
                                 default = nil)
  if valid_589632 != nil:
    section.add "oauth_token", valid_589632
  var valid_589633 = query.getOrDefault("userIp")
  valid_589633 = validateParameter(valid_589633, JString, required = false,
                                 default = nil)
  if valid_589633 != nil:
    section.add "userIp", valid_589633
  var valid_589634 = query.getOrDefault("key")
  valid_589634 = validateParameter(valid_589634, JString, required = false,
                                 default = nil)
  if valid_589634 != nil:
    section.add "key", valid_589634
  var valid_589635 = query.getOrDefault("prettyPrint")
  valid_589635 = validateParameter(valid_589635, JBool, required = false,
                                 default = newJBool(true))
  if valid_589635 != nil:
    section.add "prettyPrint", valid_589635
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589636: Call_AndroidpublisherEditsTracksGet_589623; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the track configuration for the specified track type. Includes the APK version codes that are in this track.
  ## 
  let valid = call_589636.validator(path, query, header, formData, body)
  let scheme = call_589636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589636.url(scheme.get, call_589636.host, call_589636.base,
                         call_589636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589636, url, valid)

proc call*(call_589637: Call_AndroidpublisherEditsTracksGet_589623;
          packageName: string; editId: string; track: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsTracksGet
  ## Fetches the track configuration for the specified track type. Includes the APK version codes that are in this track.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   track: string (required)
  ##        : The track to read or modify.
  var path_589638 = newJObject()
  var query_589639 = newJObject()
  add(query_589639, "fields", newJString(fields))
  add(path_589638, "packageName", newJString(packageName))
  add(query_589639, "quotaUser", newJString(quotaUser))
  add(query_589639, "alt", newJString(alt))
  add(path_589638, "editId", newJString(editId))
  add(query_589639, "oauth_token", newJString(oauthToken))
  add(query_589639, "userIp", newJString(userIp))
  add(query_589639, "key", newJString(key))
  add(query_589639, "prettyPrint", newJBool(prettyPrint))
  add(path_589638, "track", newJString(track))
  result = call_589637.call(path_589638, query_589639, nil, nil, nil)

var androidpublisherEditsTracksGet* = Call_AndroidpublisherEditsTracksGet_589623(
    name: "androidpublisherEditsTracksGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksGet_589624,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTracksGet_589625, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksPatch_589659 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsTracksPatch_589661(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "track" in path, "`track` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/tracks/"),
               (kind: VariableSegment, value: "track")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsTracksPatch_589660(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the track configuration for the specified track type. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   track: JString (required)
  ##        : The track to read or modify.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589662 = path.getOrDefault("packageName")
  valid_589662 = validateParameter(valid_589662, JString, required = true,
                                 default = nil)
  if valid_589662 != nil:
    section.add "packageName", valid_589662
  var valid_589663 = path.getOrDefault("editId")
  valid_589663 = validateParameter(valid_589663, JString, required = true,
                                 default = nil)
  if valid_589663 != nil:
    section.add "editId", valid_589663
  var valid_589664 = path.getOrDefault("track")
  valid_589664 = validateParameter(valid_589664, JString, required = true,
                                 default = nil)
  if valid_589664 != nil:
    section.add "track", valid_589664
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589665 = query.getOrDefault("fields")
  valid_589665 = validateParameter(valid_589665, JString, required = false,
                                 default = nil)
  if valid_589665 != nil:
    section.add "fields", valid_589665
  var valid_589666 = query.getOrDefault("quotaUser")
  valid_589666 = validateParameter(valid_589666, JString, required = false,
                                 default = nil)
  if valid_589666 != nil:
    section.add "quotaUser", valid_589666
  var valid_589667 = query.getOrDefault("alt")
  valid_589667 = validateParameter(valid_589667, JString, required = false,
                                 default = newJString("json"))
  if valid_589667 != nil:
    section.add "alt", valid_589667
  var valid_589668 = query.getOrDefault("oauth_token")
  valid_589668 = validateParameter(valid_589668, JString, required = false,
                                 default = nil)
  if valid_589668 != nil:
    section.add "oauth_token", valid_589668
  var valid_589669 = query.getOrDefault("userIp")
  valid_589669 = validateParameter(valid_589669, JString, required = false,
                                 default = nil)
  if valid_589669 != nil:
    section.add "userIp", valid_589669
  var valid_589670 = query.getOrDefault("key")
  valid_589670 = validateParameter(valid_589670, JString, required = false,
                                 default = nil)
  if valid_589670 != nil:
    section.add "key", valid_589670
  var valid_589671 = query.getOrDefault("prettyPrint")
  valid_589671 = validateParameter(valid_589671, JBool, required = false,
                                 default = newJBool(true))
  if valid_589671 != nil:
    section.add "prettyPrint", valid_589671
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

proc call*(call_589673: Call_AndroidpublisherEditsTracksPatch_589659;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the track configuration for the specified track type. This method supports patch semantics.
  ## 
  let valid = call_589673.validator(path, query, header, formData, body)
  let scheme = call_589673.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589673.url(scheme.get, call_589673.host, call_589673.base,
                         call_589673.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589673, url, valid)

proc call*(call_589674: Call_AndroidpublisherEditsTracksPatch_589659;
          packageName: string; editId: string; track: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsTracksPatch
  ## Updates the track configuration for the specified track type. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   track: string (required)
  ##        : The track to read or modify.
  var path_589675 = newJObject()
  var query_589676 = newJObject()
  var body_589677 = newJObject()
  add(query_589676, "fields", newJString(fields))
  add(path_589675, "packageName", newJString(packageName))
  add(query_589676, "quotaUser", newJString(quotaUser))
  add(query_589676, "alt", newJString(alt))
  add(path_589675, "editId", newJString(editId))
  add(query_589676, "oauth_token", newJString(oauthToken))
  add(query_589676, "userIp", newJString(userIp))
  add(query_589676, "key", newJString(key))
  if body != nil:
    body_589677 = body
  add(query_589676, "prettyPrint", newJBool(prettyPrint))
  add(path_589675, "track", newJString(track))
  result = call_589674.call(path_589675, query_589676, nil, nil, body_589677)

var androidpublisherEditsTracksPatch* = Call_AndroidpublisherEditsTracksPatch_589659(
    name: "androidpublisherEditsTracksPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksPatch_589660,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTracksPatch_589661, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsCommit_589678 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsCommit_589680(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: ":commit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsCommit_589679(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Commits/applies the changes made in this edit back to the app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589681 = path.getOrDefault("packageName")
  valid_589681 = validateParameter(valid_589681, JString, required = true,
                                 default = nil)
  if valid_589681 != nil:
    section.add "packageName", valid_589681
  var valid_589682 = path.getOrDefault("editId")
  valid_589682 = validateParameter(valid_589682, JString, required = true,
                                 default = nil)
  if valid_589682 != nil:
    section.add "editId", valid_589682
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589683 = query.getOrDefault("fields")
  valid_589683 = validateParameter(valid_589683, JString, required = false,
                                 default = nil)
  if valid_589683 != nil:
    section.add "fields", valid_589683
  var valid_589684 = query.getOrDefault("quotaUser")
  valid_589684 = validateParameter(valid_589684, JString, required = false,
                                 default = nil)
  if valid_589684 != nil:
    section.add "quotaUser", valid_589684
  var valid_589685 = query.getOrDefault("alt")
  valid_589685 = validateParameter(valid_589685, JString, required = false,
                                 default = newJString("json"))
  if valid_589685 != nil:
    section.add "alt", valid_589685
  var valid_589686 = query.getOrDefault("oauth_token")
  valid_589686 = validateParameter(valid_589686, JString, required = false,
                                 default = nil)
  if valid_589686 != nil:
    section.add "oauth_token", valid_589686
  var valid_589687 = query.getOrDefault("userIp")
  valid_589687 = validateParameter(valid_589687, JString, required = false,
                                 default = nil)
  if valid_589687 != nil:
    section.add "userIp", valid_589687
  var valid_589688 = query.getOrDefault("key")
  valid_589688 = validateParameter(valid_589688, JString, required = false,
                                 default = nil)
  if valid_589688 != nil:
    section.add "key", valid_589688
  var valid_589689 = query.getOrDefault("prettyPrint")
  valid_589689 = validateParameter(valid_589689, JBool, required = false,
                                 default = newJBool(true))
  if valid_589689 != nil:
    section.add "prettyPrint", valid_589689
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589690: Call_AndroidpublisherEditsCommit_589678; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Commits/applies the changes made in this edit back to the app.
  ## 
  let valid = call_589690.validator(path, query, header, formData, body)
  let scheme = call_589690.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589690.url(scheme.get, call_589690.host, call_589690.base,
                         call_589690.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589690, url, valid)

proc call*(call_589691: Call_AndroidpublisherEditsCommit_589678;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsCommit
  ## Commits/applies the changes made in this edit back to the app.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589692 = newJObject()
  var query_589693 = newJObject()
  add(query_589693, "fields", newJString(fields))
  add(path_589692, "packageName", newJString(packageName))
  add(query_589693, "quotaUser", newJString(quotaUser))
  add(query_589693, "alt", newJString(alt))
  add(path_589692, "editId", newJString(editId))
  add(query_589693, "oauth_token", newJString(oauthToken))
  add(query_589693, "userIp", newJString(userIp))
  add(query_589693, "key", newJString(key))
  add(query_589693, "prettyPrint", newJBool(prettyPrint))
  result = call_589691.call(path_589692, query_589693, nil, nil, nil)

var androidpublisherEditsCommit* = Call_AndroidpublisherEditsCommit_589678(
    name: "androidpublisherEditsCommit", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}:commit",
    validator: validate_AndroidpublisherEditsCommit_589679,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsCommit_589680, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsValidate_589694 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsValidate_589696(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: ":validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsValidate_589695(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that the edit can be successfully committed. The edit's changes are not applied to the live app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589697 = path.getOrDefault("packageName")
  valid_589697 = validateParameter(valid_589697, JString, required = true,
                                 default = nil)
  if valid_589697 != nil:
    section.add "packageName", valid_589697
  var valid_589698 = path.getOrDefault("editId")
  valid_589698 = validateParameter(valid_589698, JString, required = true,
                                 default = nil)
  if valid_589698 != nil:
    section.add "editId", valid_589698
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589699 = query.getOrDefault("fields")
  valid_589699 = validateParameter(valid_589699, JString, required = false,
                                 default = nil)
  if valid_589699 != nil:
    section.add "fields", valid_589699
  var valid_589700 = query.getOrDefault("quotaUser")
  valid_589700 = validateParameter(valid_589700, JString, required = false,
                                 default = nil)
  if valid_589700 != nil:
    section.add "quotaUser", valid_589700
  var valid_589701 = query.getOrDefault("alt")
  valid_589701 = validateParameter(valid_589701, JString, required = false,
                                 default = newJString("json"))
  if valid_589701 != nil:
    section.add "alt", valid_589701
  var valid_589702 = query.getOrDefault("oauth_token")
  valid_589702 = validateParameter(valid_589702, JString, required = false,
                                 default = nil)
  if valid_589702 != nil:
    section.add "oauth_token", valid_589702
  var valid_589703 = query.getOrDefault("userIp")
  valid_589703 = validateParameter(valid_589703, JString, required = false,
                                 default = nil)
  if valid_589703 != nil:
    section.add "userIp", valid_589703
  var valid_589704 = query.getOrDefault("key")
  valid_589704 = validateParameter(valid_589704, JString, required = false,
                                 default = nil)
  if valid_589704 != nil:
    section.add "key", valid_589704
  var valid_589705 = query.getOrDefault("prettyPrint")
  valid_589705 = validateParameter(valid_589705, JBool, required = false,
                                 default = newJBool(true))
  if valid_589705 != nil:
    section.add "prettyPrint", valid_589705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589706: Call_AndroidpublisherEditsValidate_589694; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that the edit can be successfully committed. The edit's changes are not applied to the live app.
  ## 
  let valid = call_589706.validator(path, query, header, formData, body)
  let scheme = call_589706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589706.url(scheme.get, call_589706.host, call_589706.base,
                         call_589706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589706, url, valid)

proc call*(call_589707: Call_AndroidpublisherEditsValidate_589694;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsValidate
  ## Checks that the edit can be successfully committed. The edit's changes are not applied to the live app.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589708 = newJObject()
  var query_589709 = newJObject()
  add(query_589709, "fields", newJString(fields))
  add(path_589708, "packageName", newJString(packageName))
  add(query_589709, "quotaUser", newJString(quotaUser))
  add(query_589709, "alt", newJString(alt))
  add(path_589708, "editId", newJString(editId))
  add(query_589709, "oauth_token", newJString(oauthToken))
  add(query_589709, "userIp", newJString(userIp))
  add(query_589709, "key", newJString(key))
  add(query_589709, "prettyPrint", newJBool(prettyPrint))
  result = call_589707.call(path_589708, query_589709, nil, nil, nil)

var androidpublisherEditsValidate* = Call_AndroidpublisherEditsValidate_589694(
    name: "androidpublisherEditsValidate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}:validate",
    validator: validate_AndroidpublisherEditsValidate_589695,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsValidate_589696, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsInsert_589728 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherInappproductsInsert_589730(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/inappproducts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherInappproductsInsert_589729(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new in-app product for an app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app; for example, "com.spiffygame".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589731 = path.getOrDefault("packageName")
  valid_589731 = validateParameter(valid_589731, JString, required = true,
                                 default = nil)
  if valid_589731 != nil:
    section.add "packageName", valid_589731
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   autoConvertMissingPrices: JBool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589732 = query.getOrDefault("fields")
  valid_589732 = validateParameter(valid_589732, JString, required = false,
                                 default = nil)
  if valid_589732 != nil:
    section.add "fields", valid_589732
  var valid_589733 = query.getOrDefault("quotaUser")
  valid_589733 = validateParameter(valid_589733, JString, required = false,
                                 default = nil)
  if valid_589733 != nil:
    section.add "quotaUser", valid_589733
  var valid_589734 = query.getOrDefault("alt")
  valid_589734 = validateParameter(valid_589734, JString, required = false,
                                 default = newJString("json"))
  if valid_589734 != nil:
    section.add "alt", valid_589734
  var valid_589735 = query.getOrDefault("oauth_token")
  valid_589735 = validateParameter(valid_589735, JString, required = false,
                                 default = nil)
  if valid_589735 != nil:
    section.add "oauth_token", valid_589735
  var valid_589736 = query.getOrDefault("userIp")
  valid_589736 = validateParameter(valid_589736, JString, required = false,
                                 default = nil)
  if valid_589736 != nil:
    section.add "userIp", valid_589736
  var valid_589737 = query.getOrDefault("key")
  valid_589737 = validateParameter(valid_589737, JString, required = false,
                                 default = nil)
  if valid_589737 != nil:
    section.add "key", valid_589737
  var valid_589738 = query.getOrDefault("autoConvertMissingPrices")
  valid_589738 = validateParameter(valid_589738, JBool, required = false, default = nil)
  if valid_589738 != nil:
    section.add "autoConvertMissingPrices", valid_589738
  var valid_589739 = query.getOrDefault("prettyPrint")
  valid_589739 = validateParameter(valid_589739, JBool, required = false,
                                 default = newJBool(true))
  if valid_589739 != nil:
    section.add "prettyPrint", valid_589739
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

proc call*(call_589741: Call_AndroidpublisherInappproductsInsert_589728;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new in-app product for an app.
  ## 
  let valid = call_589741.validator(path, query, header, formData, body)
  let scheme = call_589741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589741.url(scheme.get, call_589741.host, call_589741.base,
                         call_589741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589741, url, valid)

proc call*(call_589742: Call_AndroidpublisherInappproductsInsert_589728;
          packageName: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; autoConvertMissingPrices: bool = false;
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidpublisherInappproductsInsert
  ## Creates a new in-app product for an app.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   autoConvertMissingPrices: bool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589743 = newJObject()
  var query_589744 = newJObject()
  var body_589745 = newJObject()
  add(query_589744, "fields", newJString(fields))
  add(path_589743, "packageName", newJString(packageName))
  add(query_589744, "quotaUser", newJString(quotaUser))
  add(query_589744, "alt", newJString(alt))
  add(query_589744, "oauth_token", newJString(oauthToken))
  add(query_589744, "userIp", newJString(userIp))
  add(query_589744, "key", newJString(key))
  add(query_589744, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_589745 = body
  add(query_589744, "prettyPrint", newJBool(prettyPrint))
  result = call_589742.call(path_589743, query_589744, nil, nil, body_589745)

var androidpublisherInappproductsInsert* = Call_AndroidpublisherInappproductsInsert_589728(
    name: "androidpublisherInappproductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts",
    validator: validate_AndroidpublisherInappproductsInsert_589729,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsInsert_589730, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsList_589710 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherInappproductsList_589712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/inappproducts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherInappproductsList_589711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the in-app products for an Android app, both subscriptions and managed in-app products..
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app with in-app products; for example, "com.spiffygame".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589713 = path.getOrDefault("packageName")
  valid_589713 = validateParameter(valid_589713, JString, required = true,
                                 default = nil)
  if valid_589713 != nil:
    section.add "packageName", valid_589713
  result.add "path", section
  ## parameters in `query` object:
  ##   token: JString
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  section = newJObject()
  var valid_589714 = query.getOrDefault("token")
  valid_589714 = validateParameter(valid_589714, JString, required = false,
                                 default = nil)
  if valid_589714 != nil:
    section.add "token", valid_589714
  var valid_589715 = query.getOrDefault("fields")
  valid_589715 = validateParameter(valid_589715, JString, required = false,
                                 default = nil)
  if valid_589715 != nil:
    section.add "fields", valid_589715
  var valid_589716 = query.getOrDefault("quotaUser")
  valid_589716 = validateParameter(valid_589716, JString, required = false,
                                 default = nil)
  if valid_589716 != nil:
    section.add "quotaUser", valid_589716
  var valid_589717 = query.getOrDefault("alt")
  valid_589717 = validateParameter(valid_589717, JString, required = false,
                                 default = newJString("json"))
  if valid_589717 != nil:
    section.add "alt", valid_589717
  var valid_589718 = query.getOrDefault("oauth_token")
  valid_589718 = validateParameter(valid_589718, JString, required = false,
                                 default = nil)
  if valid_589718 != nil:
    section.add "oauth_token", valid_589718
  var valid_589719 = query.getOrDefault("userIp")
  valid_589719 = validateParameter(valid_589719, JString, required = false,
                                 default = nil)
  if valid_589719 != nil:
    section.add "userIp", valid_589719
  var valid_589720 = query.getOrDefault("maxResults")
  valid_589720 = validateParameter(valid_589720, JInt, required = false, default = nil)
  if valid_589720 != nil:
    section.add "maxResults", valid_589720
  var valid_589721 = query.getOrDefault("key")
  valid_589721 = validateParameter(valid_589721, JString, required = false,
                                 default = nil)
  if valid_589721 != nil:
    section.add "key", valid_589721
  var valid_589722 = query.getOrDefault("prettyPrint")
  valid_589722 = validateParameter(valid_589722, JBool, required = false,
                                 default = newJBool(true))
  if valid_589722 != nil:
    section.add "prettyPrint", valid_589722
  var valid_589723 = query.getOrDefault("startIndex")
  valid_589723 = validateParameter(valid_589723, JInt, required = false, default = nil)
  if valid_589723 != nil:
    section.add "startIndex", valid_589723
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589724: Call_AndroidpublisherInappproductsList_589710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the in-app products for an Android app, both subscriptions and managed in-app products..
  ## 
  let valid = call_589724.validator(path, query, header, formData, body)
  let scheme = call_589724.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589724.url(scheme.get, call_589724.host, call_589724.base,
                         call_589724.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589724, url, valid)

proc call*(call_589725: Call_AndroidpublisherInappproductsList_589710;
          packageName: string; token: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## androidpublisherInappproductsList
  ## List all the in-app products for an Android app, both subscriptions and managed in-app products..
  ##   token: string
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app with in-app products; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  var path_589726 = newJObject()
  var query_589727 = newJObject()
  add(query_589727, "token", newJString(token))
  add(query_589727, "fields", newJString(fields))
  add(path_589726, "packageName", newJString(packageName))
  add(query_589727, "quotaUser", newJString(quotaUser))
  add(query_589727, "alt", newJString(alt))
  add(query_589727, "oauth_token", newJString(oauthToken))
  add(query_589727, "userIp", newJString(userIp))
  add(query_589727, "maxResults", newJInt(maxResults))
  add(query_589727, "key", newJString(key))
  add(query_589727, "prettyPrint", newJBool(prettyPrint))
  add(query_589727, "startIndex", newJInt(startIndex))
  result = call_589725.call(path_589726, query_589727, nil, nil, nil)

var androidpublisherInappproductsList* = Call_AndroidpublisherInappproductsList_589710(
    name: "androidpublisherInappproductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts",
    validator: validate_AndroidpublisherInappproductsList_589711,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsList_589712, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsUpdate_589762 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherInappproductsUpdate_589764(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "sku" in path, "`sku` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/inappproducts/"),
               (kind: VariableSegment, value: "sku")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherInappproductsUpdate_589763(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of an in-app product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app with the in-app product; for example, "com.spiffygame".
  ##   sku: JString (required)
  ##      : Unique identifier for the in-app product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589765 = path.getOrDefault("packageName")
  valid_589765 = validateParameter(valid_589765, JString, required = true,
                                 default = nil)
  if valid_589765 != nil:
    section.add "packageName", valid_589765
  var valid_589766 = path.getOrDefault("sku")
  valid_589766 = validateParameter(valid_589766, JString, required = true,
                                 default = nil)
  if valid_589766 != nil:
    section.add "sku", valid_589766
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   autoConvertMissingPrices: JBool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589767 = query.getOrDefault("fields")
  valid_589767 = validateParameter(valid_589767, JString, required = false,
                                 default = nil)
  if valid_589767 != nil:
    section.add "fields", valid_589767
  var valid_589768 = query.getOrDefault("quotaUser")
  valid_589768 = validateParameter(valid_589768, JString, required = false,
                                 default = nil)
  if valid_589768 != nil:
    section.add "quotaUser", valid_589768
  var valid_589769 = query.getOrDefault("alt")
  valid_589769 = validateParameter(valid_589769, JString, required = false,
                                 default = newJString("json"))
  if valid_589769 != nil:
    section.add "alt", valid_589769
  var valid_589770 = query.getOrDefault("oauth_token")
  valid_589770 = validateParameter(valid_589770, JString, required = false,
                                 default = nil)
  if valid_589770 != nil:
    section.add "oauth_token", valid_589770
  var valid_589771 = query.getOrDefault("userIp")
  valid_589771 = validateParameter(valid_589771, JString, required = false,
                                 default = nil)
  if valid_589771 != nil:
    section.add "userIp", valid_589771
  var valid_589772 = query.getOrDefault("key")
  valid_589772 = validateParameter(valid_589772, JString, required = false,
                                 default = nil)
  if valid_589772 != nil:
    section.add "key", valid_589772
  var valid_589773 = query.getOrDefault("autoConvertMissingPrices")
  valid_589773 = validateParameter(valid_589773, JBool, required = false, default = nil)
  if valid_589773 != nil:
    section.add "autoConvertMissingPrices", valid_589773
  var valid_589774 = query.getOrDefault("prettyPrint")
  valid_589774 = validateParameter(valid_589774, JBool, required = false,
                                 default = newJBool(true))
  if valid_589774 != nil:
    section.add "prettyPrint", valid_589774
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

proc call*(call_589776: Call_AndroidpublisherInappproductsUpdate_589762;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the details of an in-app product.
  ## 
  let valid = call_589776.validator(path, query, header, formData, body)
  let scheme = call_589776.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589776.url(scheme.get, call_589776.host, call_589776.base,
                         call_589776.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589776, url, valid)

proc call*(call_589777: Call_AndroidpublisherInappproductsUpdate_589762;
          packageName: string; sku: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; autoConvertMissingPrices: bool = false;
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidpublisherInappproductsUpdate
  ## Updates the details of an in-app product.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app with the in-app product; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sku: string (required)
  ##      : Unique identifier for the in-app product.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   autoConvertMissingPrices: bool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589778 = newJObject()
  var query_589779 = newJObject()
  var body_589780 = newJObject()
  add(query_589779, "fields", newJString(fields))
  add(path_589778, "packageName", newJString(packageName))
  add(query_589779, "quotaUser", newJString(quotaUser))
  add(query_589779, "alt", newJString(alt))
  add(query_589779, "oauth_token", newJString(oauthToken))
  add(query_589779, "userIp", newJString(userIp))
  add(path_589778, "sku", newJString(sku))
  add(query_589779, "key", newJString(key))
  add(query_589779, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_589780 = body
  add(query_589779, "prettyPrint", newJBool(prettyPrint))
  result = call_589777.call(path_589778, query_589779, nil, nil, body_589780)

var androidpublisherInappproductsUpdate* = Call_AndroidpublisherInappproductsUpdate_589762(
    name: "androidpublisherInappproductsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsUpdate_589763,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsUpdate_589764, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsGet_589746 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherInappproductsGet_589748(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "sku" in path, "`sku` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/inappproducts/"),
               (kind: VariableSegment, value: "sku")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherInappproductsGet_589747(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns information about the in-app product specified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##   sku: JString (required)
  ##      : Unique identifier for the in-app product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589749 = path.getOrDefault("packageName")
  valid_589749 = validateParameter(valid_589749, JString, required = true,
                                 default = nil)
  if valid_589749 != nil:
    section.add "packageName", valid_589749
  var valid_589750 = path.getOrDefault("sku")
  valid_589750 = validateParameter(valid_589750, JString, required = true,
                                 default = nil)
  if valid_589750 != nil:
    section.add "sku", valid_589750
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589751 = query.getOrDefault("fields")
  valid_589751 = validateParameter(valid_589751, JString, required = false,
                                 default = nil)
  if valid_589751 != nil:
    section.add "fields", valid_589751
  var valid_589752 = query.getOrDefault("quotaUser")
  valid_589752 = validateParameter(valid_589752, JString, required = false,
                                 default = nil)
  if valid_589752 != nil:
    section.add "quotaUser", valid_589752
  var valid_589753 = query.getOrDefault("alt")
  valid_589753 = validateParameter(valid_589753, JString, required = false,
                                 default = newJString("json"))
  if valid_589753 != nil:
    section.add "alt", valid_589753
  var valid_589754 = query.getOrDefault("oauth_token")
  valid_589754 = validateParameter(valid_589754, JString, required = false,
                                 default = nil)
  if valid_589754 != nil:
    section.add "oauth_token", valid_589754
  var valid_589755 = query.getOrDefault("userIp")
  valid_589755 = validateParameter(valid_589755, JString, required = false,
                                 default = nil)
  if valid_589755 != nil:
    section.add "userIp", valid_589755
  var valid_589756 = query.getOrDefault("key")
  valid_589756 = validateParameter(valid_589756, JString, required = false,
                                 default = nil)
  if valid_589756 != nil:
    section.add "key", valid_589756
  var valid_589757 = query.getOrDefault("prettyPrint")
  valid_589757 = validateParameter(valid_589757, JBool, required = false,
                                 default = newJBool(true))
  if valid_589757 != nil:
    section.add "prettyPrint", valid_589757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589758: Call_AndroidpublisherInappproductsGet_589746;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the in-app product specified.
  ## 
  let valid = call_589758.validator(path, query, header, formData, body)
  let scheme = call_589758.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589758.url(scheme.get, call_589758.host, call_589758.base,
                         call_589758.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589758, url, valid)

proc call*(call_589759: Call_AndroidpublisherInappproductsGet_589746;
          packageName: string; sku: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherInappproductsGet
  ## Returns information about the in-app product specified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sku: string (required)
  ##      : Unique identifier for the in-app product.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589760 = newJObject()
  var query_589761 = newJObject()
  add(query_589761, "fields", newJString(fields))
  add(path_589760, "packageName", newJString(packageName))
  add(query_589761, "quotaUser", newJString(quotaUser))
  add(query_589761, "alt", newJString(alt))
  add(query_589761, "oauth_token", newJString(oauthToken))
  add(query_589761, "userIp", newJString(userIp))
  add(path_589760, "sku", newJString(sku))
  add(query_589761, "key", newJString(key))
  add(query_589761, "prettyPrint", newJBool(prettyPrint))
  result = call_589759.call(path_589760, query_589761, nil, nil, nil)

var androidpublisherInappproductsGet* = Call_AndroidpublisherInappproductsGet_589746(
    name: "androidpublisherInappproductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsGet_589747,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsGet_589748, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsPatch_589797 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherInappproductsPatch_589799(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "sku" in path, "`sku` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/inappproducts/"),
               (kind: VariableSegment, value: "sku")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherInappproductsPatch_589798(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of an in-app product. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app with the in-app product; for example, "com.spiffygame".
  ##   sku: JString (required)
  ##      : Unique identifier for the in-app product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589800 = path.getOrDefault("packageName")
  valid_589800 = validateParameter(valid_589800, JString, required = true,
                                 default = nil)
  if valid_589800 != nil:
    section.add "packageName", valid_589800
  var valid_589801 = path.getOrDefault("sku")
  valid_589801 = validateParameter(valid_589801, JString, required = true,
                                 default = nil)
  if valid_589801 != nil:
    section.add "sku", valid_589801
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   autoConvertMissingPrices: JBool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589802 = query.getOrDefault("fields")
  valid_589802 = validateParameter(valid_589802, JString, required = false,
                                 default = nil)
  if valid_589802 != nil:
    section.add "fields", valid_589802
  var valid_589803 = query.getOrDefault("quotaUser")
  valid_589803 = validateParameter(valid_589803, JString, required = false,
                                 default = nil)
  if valid_589803 != nil:
    section.add "quotaUser", valid_589803
  var valid_589804 = query.getOrDefault("alt")
  valid_589804 = validateParameter(valid_589804, JString, required = false,
                                 default = newJString("json"))
  if valid_589804 != nil:
    section.add "alt", valid_589804
  var valid_589805 = query.getOrDefault("oauth_token")
  valid_589805 = validateParameter(valid_589805, JString, required = false,
                                 default = nil)
  if valid_589805 != nil:
    section.add "oauth_token", valid_589805
  var valid_589806 = query.getOrDefault("userIp")
  valid_589806 = validateParameter(valid_589806, JString, required = false,
                                 default = nil)
  if valid_589806 != nil:
    section.add "userIp", valid_589806
  var valid_589807 = query.getOrDefault("key")
  valid_589807 = validateParameter(valid_589807, JString, required = false,
                                 default = nil)
  if valid_589807 != nil:
    section.add "key", valid_589807
  var valid_589808 = query.getOrDefault("autoConvertMissingPrices")
  valid_589808 = validateParameter(valid_589808, JBool, required = false, default = nil)
  if valid_589808 != nil:
    section.add "autoConvertMissingPrices", valid_589808
  var valid_589809 = query.getOrDefault("prettyPrint")
  valid_589809 = validateParameter(valid_589809, JBool, required = false,
                                 default = newJBool(true))
  if valid_589809 != nil:
    section.add "prettyPrint", valid_589809
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

proc call*(call_589811: Call_AndroidpublisherInappproductsPatch_589797;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the details of an in-app product. This method supports patch semantics.
  ## 
  let valid = call_589811.validator(path, query, header, formData, body)
  let scheme = call_589811.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589811.url(scheme.get, call_589811.host, call_589811.base,
                         call_589811.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589811, url, valid)

proc call*(call_589812: Call_AndroidpublisherInappproductsPatch_589797;
          packageName: string; sku: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; autoConvertMissingPrices: bool = false;
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidpublisherInappproductsPatch
  ## Updates the details of an in-app product. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app with the in-app product; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sku: string (required)
  ##      : Unique identifier for the in-app product.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   autoConvertMissingPrices: bool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589813 = newJObject()
  var query_589814 = newJObject()
  var body_589815 = newJObject()
  add(query_589814, "fields", newJString(fields))
  add(path_589813, "packageName", newJString(packageName))
  add(query_589814, "quotaUser", newJString(quotaUser))
  add(query_589814, "alt", newJString(alt))
  add(query_589814, "oauth_token", newJString(oauthToken))
  add(query_589814, "userIp", newJString(userIp))
  add(path_589813, "sku", newJString(sku))
  add(query_589814, "key", newJString(key))
  add(query_589814, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_589815 = body
  add(query_589814, "prettyPrint", newJBool(prettyPrint))
  result = call_589812.call(path_589813, query_589814, nil, nil, body_589815)

var androidpublisherInappproductsPatch* = Call_AndroidpublisherInappproductsPatch_589797(
    name: "androidpublisherInappproductsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsPatch_589798,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsPatch_589799, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsDelete_589781 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherInappproductsDelete_589783(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "sku" in path, "`sku` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/inappproducts/"),
               (kind: VariableSegment, value: "sku")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherInappproductsDelete_589782(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an in-app product for an app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app with the in-app product; for example, "com.spiffygame".
  ##   sku: JString (required)
  ##      : Unique identifier for the in-app product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589784 = path.getOrDefault("packageName")
  valid_589784 = validateParameter(valid_589784, JString, required = true,
                                 default = nil)
  if valid_589784 != nil:
    section.add "packageName", valid_589784
  var valid_589785 = path.getOrDefault("sku")
  valid_589785 = validateParameter(valid_589785, JString, required = true,
                                 default = nil)
  if valid_589785 != nil:
    section.add "sku", valid_589785
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589786 = query.getOrDefault("fields")
  valid_589786 = validateParameter(valid_589786, JString, required = false,
                                 default = nil)
  if valid_589786 != nil:
    section.add "fields", valid_589786
  var valid_589787 = query.getOrDefault("quotaUser")
  valid_589787 = validateParameter(valid_589787, JString, required = false,
                                 default = nil)
  if valid_589787 != nil:
    section.add "quotaUser", valid_589787
  var valid_589788 = query.getOrDefault("alt")
  valid_589788 = validateParameter(valid_589788, JString, required = false,
                                 default = newJString("json"))
  if valid_589788 != nil:
    section.add "alt", valid_589788
  var valid_589789 = query.getOrDefault("oauth_token")
  valid_589789 = validateParameter(valid_589789, JString, required = false,
                                 default = nil)
  if valid_589789 != nil:
    section.add "oauth_token", valid_589789
  var valid_589790 = query.getOrDefault("userIp")
  valid_589790 = validateParameter(valid_589790, JString, required = false,
                                 default = nil)
  if valid_589790 != nil:
    section.add "userIp", valid_589790
  var valid_589791 = query.getOrDefault("key")
  valid_589791 = validateParameter(valid_589791, JString, required = false,
                                 default = nil)
  if valid_589791 != nil:
    section.add "key", valid_589791
  var valid_589792 = query.getOrDefault("prettyPrint")
  valid_589792 = validateParameter(valid_589792, JBool, required = false,
                                 default = newJBool(true))
  if valid_589792 != nil:
    section.add "prettyPrint", valid_589792
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589793: Call_AndroidpublisherInappproductsDelete_589781;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an in-app product for an app.
  ## 
  let valid = call_589793.validator(path, query, header, formData, body)
  let scheme = call_589793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589793.url(scheme.get, call_589793.host, call_589793.base,
                         call_589793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589793, url, valid)

proc call*(call_589794: Call_AndroidpublisherInappproductsDelete_589781;
          packageName: string; sku: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherInappproductsDelete
  ## Delete an in-app product for an app.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app with the in-app product; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sku: string (required)
  ##      : Unique identifier for the in-app product.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589795 = newJObject()
  var query_589796 = newJObject()
  add(query_589796, "fields", newJString(fields))
  add(path_589795, "packageName", newJString(packageName))
  add(query_589796, "quotaUser", newJString(quotaUser))
  add(query_589796, "alt", newJString(alt))
  add(query_589796, "oauth_token", newJString(oauthToken))
  add(query_589796, "userIp", newJString(userIp))
  add(path_589795, "sku", newJString(sku))
  add(query_589796, "key", newJString(key))
  add(query_589796, "prettyPrint", newJBool(prettyPrint))
  result = call_589794.call(path_589795, query_589796, nil, nil, nil)

var androidpublisherInappproductsDelete* = Call_AndroidpublisherInappproductsDelete_589781(
    name: "androidpublisherInappproductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsDelete_589782,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsDelete_589783, schemes: {Scheme.Https})
type
  Call_AndroidpublisherOrdersRefund_589816 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherOrdersRefund_589818(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: ":refund")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherOrdersRefund_589817(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Refund a user's subscription or in-app purchase order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which this subscription or in-app item was purchased (for example, 'com.some.thing').
  ##   orderId: JString (required)
  ##          : The order ID provided to the user when the subscription or in-app order was purchased.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589819 = path.getOrDefault("packageName")
  valid_589819 = validateParameter(valid_589819, JString, required = true,
                                 default = nil)
  if valid_589819 != nil:
    section.add "packageName", valid_589819
  var valid_589820 = path.getOrDefault("orderId")
  valid_589820 = validateParameter(valid_589820, JString, required = true,
                                 default = nil)
  if valid_589820 != nil:
    section.add "orderId", valid_589820
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   revoke: JBool
  ##         : Whether to revoke the purchased item. If set to true, access to the subscription or in-app item will be terminated immediately. If the item is a recurring subscription, all future payments will also be terminated. Consumed in-app items need to be handled by developer's app. (optional)
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589821 = query.getOrDefault("fields")
  valid_589821 = validateParameter(valid_589821, JString, required = false,
                                 default = nil)
  if valid_589821 != nil:
    section.add "fields", valid_589821
  var valid_589822 = query.getOrDefault("quotaUser")
  valid_589822 = validateParameter(valid_589822, JString, required = false,
                                 default = nil)
  if valid_589822 != nil:
    section.add "quotaUser", valid_589822
  var valid_589823 = query.getOrDefault("alt")
  valid_589823 = validateParameter(valid_589823, JString, required = false,
                                 default = newJString("json"))
  if valid_589823 != nil:
    section.add "alt", valid_589823
  var valid_589824 = query.getOrDefault("oauth_token")
  valid_589824 = validateParameter(valid_589824, JString, required = false,
                                 default = nil)
  if valid_589824 != nil:
    section.add "oauth_token", valid_589824
  var valid_589825 = query.getOrDefault("userIp")
  valid_589825 = validateParameter(valid_589825, JString, required = false,
                                 default = nil)
  if valid_589825 != nil:
    section.add "userIp", valid_589825
  var valid_589826 = query.getOrDefault("key")
  valid_589826 = validateParameter(valid_589826, JString, required = false,
                                 default = nil)
  if valid_589826 != nil:
    section.add "key", valid_589826
  var valid_589827 = query.getOrDefault("revoke")
  valid_589827 = validateParameter(valid_589827, JBool, required = false, default = nil)
  if valid_589827 != nil:
    section.add "revoke", valid_589827
  var valid_589828 = query.getOrDefault("prettyPrint")
  valid_589828 = validateParameter(valid_589828, JBool, required = false,
                                 default = newJBool(true))
  if valid_589828 != nil:
    section.add "prettyPrint", valid_589828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589829: Call_AndroidpublisherOrdersRefund_589816; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Refund a user's subscription or in-app purchase order.
  ## 
  let valid = call_589829.validator(path, query, header, formData, body)
  let scheme = call_589829.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589829.url(scheme.get, call_589829.host, call_589829.base,
                         call_589829.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589829, url, valid)

proc call*(call_589830: Call_AndroidpublisherOrdersRefund_589816;
          packageName: string; orderId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; revoke: bool = false;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherOrdersRefund
  ## Refund a user's subscription or in-app purchase order.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription or in-app item was purchased (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   orderId: string (required)
  ##          : The order ID provided to the user when the subscription or in-app order was purchased.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   revoke: bool
  ##         : Whether to revoke the purchased item. If set to true, access to the subscription or in-app item will be terminated immediately. If the item is a recurring subscription, all future payments will also be terminated. Consumed in-app items need to be handled by developer's app. (optional)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589831 = newJObject()
  var query_589832 = newJObject()
  add(query_589832, "fields", newJString(fields))
  add(path_589831, "packageName", newJString(packageName))
  add(query_589832, "quotaUser", newJString(quotaUser))
  add(query_589832, "alt", newJString(alt))
  add(query_589832, "oauth_token", newJString(oauthToken))
  add(query_589832, "userIp", newJString(userIp))
  add(path_589831, "orderId", newJString(orderId))
  add(query_589832, "key", newJString(key))
  add(query_589832, "revoke", newJBool(revoke))
  add(query_589832, "prettyPrint", newJBool(prettyPrint))
  result = call_589830.call(path_589831, query_589832, nil, nil, nil)

var androidpublisherOrdersRefund* = Call_AndroidpublisherOrdersRefund_589816(
    name: "androidpublisherOrdersRefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/orders/{orderId}:refund",
    validator: validate_AndroidpublisherOrdersRefund_589817,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherOrdersRefund_589818, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesProductsGet_589833 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherPurchasesProductsGet_589835(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/purchases/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/tokens/"),
               (kind: VariableSegment, value: "token")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesProductsGet_589834(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks the purchase and consumption status of an inapp item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application the inapp product was sold in (for example, 'com.some.thing').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the inapp product was purchased.
  ##   productId: JString (required)
  ##            : The inapp product SKU (for example, 'com.some.thing.inapp1').
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589836 = path.getOrDefault("packageName")
  valid_589836 = validateParameter(valid_589836, JString, required = true,
                                 default = nil)
  if valid_589836 != nil:
    section.add "packageName", valid_589836
  var valid_589837 = path.getOrDefault("token")
  valid_589837 = validateParameter(valid_589837, JString, required = true,
                                 default = nil)
  if valid_589837 != nil:
    section.add "token", valid_589837
  var valid_589838 = path.getOrDefault("productId")
  valid_589838 = validateParameter(valid_589838, JString, required = true,
                                 default = nil)
  if valid_589838 != nil:
    section.add "productId", valid_589838
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589839 = query.getOrDefault("fields")
  valid_589839 = validateParameter(valid_589839, JString, required = false,
                                 default = nil)
  if valid_589839 != nil:
    section.add "fields", valid_589839
  var valid_589840 = query.getOrDefault("quotaUser")
  valid_589840 = validateParameter(valid_589840, JString, required = false,
                                 default = nil)
  if valid_589840 != nil:
    section.add "quotaUser", valid_589840
  var valid_589841 = query.getOrDefault("alt")
  valid_589841 = validateParameter(valid_589841, JString, required = false,
                                 default = newJString("json"))
  if valid_589841 != nil:
    section.add "alt", valid_589841
  var valid_589842 = query.getOrDefault("oauth_token")
  valid_589842 = validateParameter(valid_589842, JString, required = false,
                                 default = nil)
  if valid_589842 != nil:
    section.add "oauth_token", valid_589842
  var valid_589843 = query.getOrDefault("userIp")
  valid_589843 = validateParameter(valid_589843, JString, required = false,
                                 default = nil)
  if valid_589843 != nil:
    section.add "userIp", valid_589843
  var valid_589844 = query.getOrDefault("key")
  valid_589844 = validateParameter(valid_589844, JString, required = false,
                                 default = nil)
  if valid_589844 != nil:
    section.add "key", valid_589844
  var valid_589845 = query.getOrDefault("prettyPrint")
  valid_589845 = validateParameter(valid_589845, JBool, required = false,
                                 default = newJBool(true))
  if valid_589845 != nil:
    section.add "prettyPrint", valid_589845
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589846: Call_AndroidpublisherPurchasesProductsGet_589833;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks the purchase and consumption status of an inapp item.
  ## 
  let valid = call_589846.validator(path, query, header, formData, body)
  let scheme = call_589846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589846.url(scheme.get, call_589846.host, call_589846.base,
                         call_589846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589846, url, valid)

proc call*(call_589847: Call_AndroidpublisherPurchasesProductsGet_589833;
          packageName: string; token: string; productId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherPurchasesProductsGet
  ## Checks the purchase and consumption status of an inapp item.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application the inapp product was sold in (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   token: string (required)
  ##        : The token provided to the user's device when the inapp product was purchased.
  ##   productId: string (required)
  ##            : The inapp product SKU (for example, 'com.some.thing.inapp1').
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589848 = newJObject()
  var query_589849 = newJObject()
  add(query_589849, "fields", newJString(fields))
  add(path_589848, "packageName", newJString(packageName))
  add(query_589849, "quotaUser", newJString(quotaUser))
  add(query_589849, "alt", newJString(alt))
  add(query_589849, "oauth_token", newJString(oauthToken))
  add(query_589849, "userIp", newJString(userIp))
  add(query_589849, "key", newJString(key))
  add(path_589848, "token", newJString(token))
  add(path_589848, "productId", newJString(productId))
  add(query_589849, "prettyPrint", newJBool(prettyPrint))
  result = call_589847.call(path_589848, query_589849, nil, nil, nil)

var androidpublisherPurchasesProductsGet* = Call_AndroidpublisherPurchasesProductsGet_589833(
    name: "androidpublisherPurchasesProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/purchases/products/{productId}/tokens/{token}",
    validator: validate_AndroidpublisherPurchasesProductsGet_589834,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesProductsGet_589835, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsGet_589850 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherPurchasesSubscriptionsGet_589852(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/purchases/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tokens/"),
               (kind: VariableSegment, value: "token")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesSubscriptionsGet_589851(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   subscriptionId: JString (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589853 = path.getOrDefault("packageName")
  valid_589853 = validateParameter(valid_589853, JString, required = true,
                                 default = nil)
  if valid_589853 != nil:
    section.add "packageName", valid_589853
  var valid_589854 = path.getOrDefault("subscriptionId")
  valid_589854 = validateParameter(valid_589854, JString, required = true,
                                 default = nil)
  if valid_589854 != nil:
    section.add "subscriptionId", valid_589854
  var valid_589855 = path.getOrDefault("token")
  valid_589855 = validateParameter(valid_589855, JString, required = true,
                                 default = nil)
  if valid_589855 != nil:
    section.add "token", valid_589855
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589856 = query.getOrDefault("fields")
  valid_589856 = validateParameter(valid_589856, JString, required = false,
                                 default = nil)
  if valid_589856 != nil:
    section.add "fields", valid_589856
  var valid_589857 = query.getOrDefault("quotaUser")
  valid_589857 = validateParameter(valid_589857, JString, required = false,
                                 default = nil)
  if valid_589857 != nil:
    section.add "quotaUser", valid_589857
  var valid_589858 = query.getOrDefault("alt")
  valid_589858 = validateParameter(valid_589858, JString, required = false,
                                 default = newJString("json"))
  if valid_589858 != nil:
    section.add "alt", valid_589858
  var valid_589859 = query.getOrDefault("oauth_token")
  valid_589859 = validateParameter(valid_589859, JString, required = false,
                                 default = nil)
  if valid_589859 != nil:
    section.add "oauth_token", valid_589859
  var valid_589860 = query.getOrDefault("userIp")
  valid_589860 = validateParameter(valid_589860, JString, required = false,
                                 default = nil)
  if valid_589860 != nil:
    section.add "userIp", valid_589860
  var valid_589861 = query.getOrDefault("key")
  valid_589861 = validateParameter(valid_589861, JString, required = false,
                                 default = nil)
  if valid_589861 != nil:
    section.add "key", valid_589861
  var valid_589862 = query.getOrDefault("prettyPrint")
  valid_589862 = validateParameter(valid_589862, JBool, required = false,
                                 default = newJBool(true))
  if valid_589862 != nil:
    section.add "prettyPrint", valid_589862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589863: Call_AndroidpublisherPurchasesSubscriptionsGet_589850;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ## 
  let valid = call_589863.validator(path, query, header, formData, body)
  let scheme = call_589863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589863.url(scheme.get, call_589863.host, call_589863.base,
                         call_589863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589863, url, valid)

proc call*(call_589864: Call_AndroidpublisherPurchasesSubscriptionsGet_589850;
          packageName: string; subscriptionId: string; token: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherPurchasesSubscriptionsGet
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589865 = newJObject()
  var query_589866 = newJObject()
  add(query_589866, "fields", newJString(fields))
  add(path_589865, "packageName", newJString(packageName))
  add(query_589866, "quotaUser", newJString(quotaUser))
  add(query_589866, "alt", newJString(alt))
  add(path_589865, "subscriptionId", newJString(subscriptionId))
  add(query_589866, "oauth_token", newJString(oauthToken))
  add(query_589866, "userIp", newJString(userIp))
  add(query_589866, "key", newJString(key))
  add(path_589865, "token", newJString(token))
  add(query_589866, "prettyPrint", newJBool(prettyPrint))
  result = call_589864.call(path_589865, query_589866, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsGet* = Call_AndroidpublisherPurchasesSubscriptionsGet_589850(
    name: "androidpublisherPurchasesSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}",
    validator: validate_AndroidpublisherPurchasesSubscriptionsGet_589851,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsGet_589852,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsCancel_589867 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherPurchasesSubscriptionsCancel_589869(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/purchases/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tokens/"),
               (kind: VariableSegment, value: "token"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesSubscriptionsCancel_589868(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   subscriptionId: JString (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589870 = path.getOrDefault("packageName")
  valid_589870 = validateParameter(valid_589870, JString, required = true,
                                 default = nil)
  if valid_589870 != nil:
    section.add "packageName", valid_589870
  var valid_589871 = path.getOrDefault("subscriptionId")
  valid_589871 = validateParameter(valid_589871, JString, required = true,
                                 default = nil)
  if valid_589871 != nil:
    section.add "subscriptionId", valid_589871
  var valid_589872 = path.getOrDefault("token")
  valid_589872 = validateParameter(valid_589872, JString, required = true,
                                 default = nil)
  if valid_589872 != nil:
    section.add "token", valid_589872
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589873 = query.getOrDefault("fields")
  valid_589873 = validateParameter(valid_589873, JString, required = false,
                                 default = nil)
  if valid_589873 != nil:
    section.add "fields", valid_589873
  var valid_589874 = query.getOrDefault("quotaUser")
  valid_589874 = validateParameter(valid_589874, JString, required = false,
                                 default = nil)
  if valid_589874 != nil:
    section.add "quotaUser", valid_589874
  var valid_589875 = query.getOrDefault("alt")
  valid_589875 = validateParameter(valid_589875, JString, required = false,
                                 default = newJString("json"))
  if valid_589875 != nil:
    section.add "alt", valid_589875
  var valid_589876 = query.getOrDefault("oauth_token")
  valid_589876 = validateParameter(valid_589876, JString, required = false,
                                 default = nil)
  if valid_589876 != nil:
    section.add "oauth_token", valid_589876
  var valid_589877 = query.getOrDefault("userIp")
  valid_589877 = validateParameter(valid_589877, JString, required = false,
                                 default = nil)
  if valid_589877 != nil:
    section.add "userIp", valid_589877
  var valid_589878 = query.getOrDefault("key")
  valid_589878 = validateParameter(valid_589878, JString, required = false,
                                 default = nil)
  if valid_589878 != nil:
    section.add "key", valid_589878
  var valid_589879 = query.getOrDefault("prettyPrint")
  valid_589879 = validateParameter(valid_589879, JBool, required = false,
                                 default = newJBool(true))
  if valid_589879 != nil:
    section.add "prettyPrint", valid_589879
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589880: Call_AndroidpublisherPurchasesSubscriptionsCancel_589867;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ## 
  let valid = call_589880.validator(path, query, header, formData, body)
  let scheme = call_589880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589880.url(scheme.get, call_589880.host, call_589880.base,
                         call_589880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589880, url, valid)

proc call*(call_589881: Call_AndroidpublisherPurchasesSubscriptionsCancel_589867;
          packageName: string; subscriptionId: string; token: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherPurchasesSubscriptionsCancel
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589882 = newJObject()
  var query_589883 = newJObject()
  add(query_589883, "fields", newJString(fields))
  add(path_589882, "packageName", newJString(packageName))
  add(query_589883, "quotaUser", newJString(quotaUser))
  add(query_589883, "alt", newJString(alt))
  add(path_589882, "subscriptionId", newJString(subscriptionId))
  add(query_589883, "oauth_token", newJString(oauthToken))
  add(query_589883, "userIp", newJString(userIp))
  add(query_589883, "key", newJString(key))
  add(path_589882, "token", newJString(token))
  add(query_589883, "prettyPrint", newJBool(prettyPrint))
  result = call_589881.call(path_589882, query_589883, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsCancel* = Call_AndroidpublisherPurchasesSubscriptionsCancel_589867(
    name: "androidpublisherPurchasesSubscriptionsCancel",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:cancel",
    validator: validate_AndroidpublisherPurchasesSubscriptionsCancel_589868,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsCancel_589869,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsDefer_589884 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherPurchasesSubscriptionsDefer_589886(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/purchases/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tokens/"),
               (kind: VariableSegment, value: "token"),
               (kind: ConstantSegment, value: ":defer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesSubscriptionsDefer_589885(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Defers a user's subscription purchase until a specified future expiration time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   subscriptionId: JString (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589887 = path.getOrDefault("packageName")
  valid_589887 = validateParameter(valid_589887, JString, required = true,
                                 default = nil)
  if valid_589887 != nil:
    section.add "packageName", valid_589887
  var valid_589888 = path.getOrDefault("subscriptionId")
  valid_589888 = validateParameter(valid_589888, JString, required = true,
                                 default = nil)
  if valid_589888 != nil:
    section.add "subscriptionId", valid_589888
  var valid_589889 = path.getOrDefault("token")
  valid_589889 = validateParameter(valid_589889, JString, required = true,
                                 default = nil)
  if valid_589889 != nil:
    section.add "token", valid_589889
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589890 = query.getOrDefault("fields")
  valid_589890 = validateParameter(valid_589890, JString, required = false,
                                 default = nil)
  if valid_589890 != nil:
    section.add "fields", valid_589890
  var valid_589891 = query.getOrDefault("quotaUser")
  valid_589891 = validateParameter(valid_589891, JString, required = false,
                                 default = nil)
  if valid_589891 != nil:
    section.add "quotaUser", valid_589891
  var valid_589892 = query.getOrDefault("alt")
  valid_589892 = validateParameter(valid_589892, JString, required = false,
                                 default = newJString("json"))
  if valid_589892 != nil:
    section.add "alt", valid_589892
  var valid_589893 = query.getOrDefault("oauth_token")
  valid_589893 = validateParameter(valid_589893, JString, required = false,
                                 default = nil)
  if valid_589893 != nil:
    section.add "oauth_token", valid_589893
  var valid_589894 = query.getOrDefault("userIp")
  valid_589894 = validateParameter(valid_589894, JString, required = false,
                                 default = nil)
  if valid_589894 != nil:
    section.add "userIp", valid_589894
  var valid_589895 = query.getOrDefault("key")
  valid_589895 = validateParameter(valid_589895, JString, required = false,
                                 default = nil)
  if valid_589895 != nil:
    section.add "key", valid_589895
  var valid_589896 = query.getOrDefault("prettyPrint")
  valid_589896 = validateParameter(valid_589896, JBool, required = false,
                                 default = newJBool(true))
  if valid_589896 != nil:
    section.add "prettyPrint", valid_589896
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

proc call*(call_589898: Call_AndroidpublisherPurchasesSubscriptionsDefer_589884;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Defers a user's subscription purchase until a specified future expiration time.
  ## 
  let valid = call_589898.validator(path, query, header, formData, body)
  let scheme = call_589898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589898.url(scheme.get, call_589898.host, call_589898.base,
                         call_589898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589898, url, valid)

proc call*(call_589899: Call_AndroidpublisherPurchasesSubscriptionsDefer_589884;
          packageName: string; subscriptionId: string; token: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidpublisherPurchasesSubscriptionsDefer
  ## Defers a user's subscription purchase until a specified future expiration time.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589900 = newJObject()
  var query_589901 = newJObject()
  var body_589902 = newJObject()
  add(query_589901, "fields", newJString(fields))
  add(path_589900, "packageName", newJString(packageName))
  add(query_589901, "quotaUser", newJString(quotaUser))
  add(query_589901, "alt", newJString(alt))
  add(path_589900, "subscriptionId", newJString(subscriptionId))
  add(query_589901, "oauth_token", newJString(oauthToken))
  add(query_589901, "userIp", newJString(userIp))
  add(query_589901, "key", newJString(key))
  add(path_589900, "token", newJString(token))
  if body != nil:
    body_589902 = body
  add(query_589901, "prettyPrint", newJBool(prettyPrint))
  result = call_589899.call(path_589900, query_589901, nil, nil, body_589902)

var androidpublisherPurchasesSubscriptionsDefer* = Call_AndroidpublisherPurchasesSubscriptionsDefer_589884(
    name: "androidpublisherPurchasesSubscriptionsDefer",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:defer",
    validator: validate_AndroidpublisherPurchasesSubscriptionsDefer_589885,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsDefer_589886,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsRefund_589903 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherPurchasesSubscriptionsRefund_589905(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/purchases/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tokens/"),
               (kind: VariableSegment, value: "token"),
               (kind: ConstantSegment, value: ":refund")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesSubscriptionsRefund_589904(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Refunds a user's subscription purchase, but the subscription remains valid until its expiration time and it will continue to recur.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   subscriptionId: JString (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589906 = path.getOrDefault("packageName")
  valid_589906 = validateParameter(valid_589906, JString, required = true,
                                 default = nil)
  if valid_589906 != nil:
    section.add "packageName", valid_589906
  var valid_589907 = path.getOrDefault("subscriptionId")
  valid_589907 = validateParameter(valid_589907, JString, required = true,
                                 default = nil)
  if valid_589907 != nil:
    section.add "subscriptionId", valid_589907
  var valid_589908 = path.getOrDefault("token")
  valid_589908 = validateParameter(valid_589908, JString, required = true,
                                 default = nil)
  if valid_589908 != nil:
    section.add "token", valid_589908
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589909 = query.getOrDefault("fields")
  valid_589909 = validateParameter(valid_589909, JString, required = false,
                                 default = nil)
  if valid_589909 != nil:
    section.add "fields", valid_589909
  var valid_589910 = query.getOrDefault("quotaUser")
  valid_589910 = validateParameter(valid_589910, JString, required = false,
                                 default = nil)
  if valid_589910 != nil:
    section.add "quotaUser", valid_589910
  var valid_589911 = query.getOrDefault("alt")
  valid_589911 = validateParameter(valid_589911, JString, required = false,
                                 default = newJString("json"))
  if valid_589911 != nil:
    section.add "alt", valid_589911
  var valid_589912 = query.getOrDefault("oauth_token")
  valid_589912 = validateParameter(valid_589912, JString, required = false,
                                 default = nil)
  if valid_589912 != nil:
    section.add "oauth_token", valid_589912
  var valid_589913 = query.getOrDefault("userIp")
  valid_589913 = validateParameter(valid_589913, JString, required = false,
                                 default = nil)
  if valid_589913 != nil:
    section.add "userIp", valid_589913
  var valid_589914 = query.getOrDefault("key")
  valid_589914 = validateParameter(valid_589914, JString, required = false,
                                 default = nil)
  if valid_589914 != nil:
    section.add "key", valid_589914
  var valid_589915 = query.getOrDefault("prettyPrint")
  valid_589915 = validateParameter(valid_589915, JBool, required = false,
                                 default = newJBool(true))
  if valid_589915 != nil:
    section.add "prettyPrint", valid_589915
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589916: Call_AndroidpublisherPurchasesSubscriptionsRefund_589903;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refunds a user's subscription purchase, but the subscription remains valid until its expiration time and it will continue to recur.
  ## 
  let valid = call_589916.validator(path, query, header, formData, body)
  let scheme = call_589916.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589916.url(scheme.get, call_589916.host, call_589916.base,
                         call_589916.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589916, url, valid)

proc call*(call_589917: Call_AndroidpublisherPurchasesSubscriptionsRefund_589903;
          packageName: string; subscriptionId: string; token: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherPurchasesSubscriptionsRefund
  ## Refunds a user's subscription purchase, but the subscription remains valid until its expiration time and it will continue to recur.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589918 = newJObject()
  var query_589919 = newJObject()
  add(query_589919, "fields", newJString(fields))
  add(path_589918, "packageName", newJString(packageName))
  add(query_589919, "quotaUser", newJString(quotaUser))
  add(query_589919, "alt", newJString(alt))
  add(path_589918, "subscriptionId", newJString(subscriptionId))
  add(query_589919, "oauth_token", newJString(oauthToken))
  add(query_589919, "userIp", newJString(userIp))
  add(query_589919, "key", newJString(key))
  add(path_589918, "token", newJString(token))
  add(query_589919, "prettyPrint", newJBool(prettyPrint))
  result = call_589917.call(path_589918, query_589919, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsRefund* = Call_AndroidpublisherPurchasesSubscriptionsRefund_589903(
    name: "androidpublisherPurchasesSubscriptionsRefund",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:refund",
    validator: validate_AndroidpublisherPurchasesSubscriptionsRefund_589904,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsRefund_589905,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsRevoke_589920 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherPurchasesSubscriptionsRevoke_589922(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/purchases/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tokens/"),
               (kind: VariableSegment, value: "token"),
               (kind: ConstantSegment, value: ":revoke")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesSubscriptionsRevoke_589921(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Refunds and immediately revokes a user's subscription purchase. Access to the subscription will be terminated immediately and it will stop recurring.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   subscriptionId: JString (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589923 = path.getOrDefault("packageName")
  valid_589923 = validateParameter(valid_589923, JString, required = true,
                                 default = nil)
  if valid_589923 != nil:
    section.add "packageName", valid_589923
  var valid_589924 = path.getOrDefault("subscriptionId")
  valid_589924 = validateParameter(valid_589924, JString, required = true,
                                 default = nil)
  if valid_589924 != nil:
    section.add "subscriptionId", valid_589924
  var valid_589925 = path.getOrDefault("token")
  valid_589925 = validateParameter(valid_589925, JString, required = true,
                                 default = nil)
  if valid_589925 != nil:
    section.add "token", valid_589925
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589926 = query.getOrDefault("fields")
  valid_589926 = validateParameter(valid_589926, JString, required = false,
                                 default = nil)
  if valid_589926 != nil:
    section.add "fields", valid_589926
  var valid_589927 = query.getOrDefault("quotaUser")
  valid_589927 = validateParameter(valid_589927, JString, required = false,
                                 default = nil)
  if valid_589927 != nil:
    section.add "quotaUser", valid_589927
  var valid_589928 = query.getOrDefault("alt")
  valid_589928 = validateParameter(valid_589928, JString, required = false,
                                 default = newJString("json"))
  if valid_589928 != nil:
    section.add "alt", valid_589928
  var valid_589929 = query.getOrDefault("oauth_token")
  valid_589929 = validateParameter(valid_589929, JString, required = false,
                                 default = nil)
  if valid_589929 != nil:
    section.add "oauth_token", valid_589929
  var valid_589930 = query.getOrDefault("userIp")
  valid_589930 = validateParameter(valid_589930, JString, required = false,
                                 default = nil)
  if valid_589930 != nil:
    section.add "userIp", valid_589930
  var valid_589931 = query.getOrDefault("key")
  valid_589931 = validateParameter(valid_589931, JString, required = false,
                                 default = nil)
  if valid_589931 != nil:
    section.add "key", valid_589931
  var valid_589932 = query.getOrDefault("prettyPrint")
  valid_589932 = validateParameter(valid_589932, JBool, required = false,
                                 default = newJBool(true))
  if valid_589932 != nil:
    section.add "prettyPrint", valid_589932
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589933: Call_AndroidpublisherPurchasesSubscriptionsRevoke_589920;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refunds and immediately revokes a user's subscription purchase. Access to the subscription will be terminated immediately and it will stop recurring.
  ## 
  let valid = call_589933.validator(path, query, header, formData, body)
  let scheme = call_589933.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589933.url(scheme.get, call_589933.host, call_589933.base,
                         call_589933.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589933, url, valid)

proc call*(call_589934: Call_AndroidpublisherPurchasesSubscriptionsRevoke_589920;
          packageName: string; subscriptionId: string; token: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherPurchasesSubscriptionsRevoke
  ## Refunds and immediately revokes a user's subscription purchase. Access to the subscription will be terminated immediately and it will stop recurring.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589935 = newJObject()
  var query_589936 = newJObject()
  add(query_589936, "fields", newJString(fields))
  add(path_589935, "packageName", newJString(packageName))
  add(query_589936, "quotaUser", newJString(quotaUser))
  add(query_589936, "alt", newJString(alt))
  add(path_589935, "subscriptionId", newJString(subscriptionId))
  add(query_589936, "oauth_token", newJString(oauthToken))
  add(query_589936, "userIp", newJString(userIp))
  add(query_589936, "key", newJString(key))
  add(path_589935, "token", newJString(token))
  add(query_589936, "prettyPrint", newJBool(prettyPrint))
  result = call_589934.call(path_589935, query_589936, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsRevoke* = Call_AndroidpublisherPurchasesSubscriptionsRevoke_589920(
    name: "androidpublisherPurchasesSubscriptionsRevoke",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:revoke",
    validator: validate_AndroidpublisherPurchasesSubscriptionsRevoke_589921,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsRevoke_589922,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesVoidedpurchasesList_589937 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherPurchasesVoidedpurchasesList_589939(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/purchases/voidedpurchases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesVoidedpurchasesList_589938(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the purchases that were canceled, refunded or charged-back.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which voided purchases need to be returned (for example, 'com.some.thing').
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589940 = path.getOrDefault("packageName")
  valid_589940 = validateParameter(valid_589940, JString, required = true,
                                 default = nil)
  if valid_589940 != nil:
    section.add "packageName", valid_589940
  result.add "path", section
  ## parameters in `query` object:
  ##   token: JString
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   endTime: JString
  ##          : The time, in milliseconds since the Epoch, of the newest voided purchase that you want to see in the response. The value of this parameter cannot be greater than the current time and is ignored if a pagination token is set. Default value is current time. Note: This filter is applied on the time at which the record is seen as voided by our systems and not the actual voided time returned in the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: JString
  ##            : The time, in milliseconds since the Epoch, of the oldest voided purchase that you want to see in the response. The value of this parameter cannot be older than 30 days and is ignored if a pagination token is set. Default value is current time minus 30 days. Note: This filter is applied on the time at which the record is seen as voided by our systems and not the actual voided time returned in the response.
  ##   startIndex: JInt
  section = newJObject()
  var valid_589941 = query.getOrDefault("token")
  valid_589941 = validateParameter(valid_589941, JString, required = false,
                                 default = nil)
  if valid_589941 != nil:
    section.add "token", valid_589941
  var valid_589942 = query.getOrDefault("fields")
  valid_589942 = validateParameter(valid_589942, JString, required = false,
                                 default = nil)
  if valid_589942 != nil:
    section.add "fields", valid_589942
  var valid_589943 = query.getOrDefault("quotaUser")
  valid_589943 = validateParameter(valid_589943, JString, required = false,
                                 default = nil)
  if valid_589943 != nil:
    section.add "quotaUser", valid_589943
  var valid_589944 = query.getOrDefault("alt")
  valid_589944 = validateParameter(valid_589944, JString, required = false,
                                 default = newJString("json"))
  if valid_589944 != nil:
    section.add "alt", valid_589944
  var valid_589945 = query.getOrDefault("oauth_token")
  valid_589945 = validateParameter(valid_589945, JString, required = false,
                                 default = nil)
  if valid_589945 != nil:
    section.add "oauth_token", valid_589945
  var valid_589946 = query.getOrDefault("endTime")
  valid_589946 = validateParameter(valid_589946, JString, required = false,
                                 default = nil)
  if valid_589946 != nil:
    section.add "endTime", valid_589946
  var valid_589947 = query.getOrDefault("userIp")
  valid_589947 = validateParameter(valid_589947, JString, required = false,
                                 default = nil)
  if valid_589947 != nil:
    section.add "userIp", valid_589947
  var valid_589948 = query.getOrDefault("maxResults")
  valid_589948 = validateParameter(valid_589948, JInt, required = false, default = nil)
  if valid_589948 != nil:
    section.add "maxResults", valid_589948
  var valid_589949 = query.getOrDefault("key")
  valid_589949 = validateParameter(valid_589949, JString, required = false,
                                 default = nil)
  if valid_589949 != nil:
    section.add "key", valid_589949
  var valid_589950 = query.getOrDefault("prettyPrint")
  valid_589950 = validateParameter(valid_589950, JBool, required = false,
                                 default = newJBool(true))
  if valid_589950 != nil:
    section.add "prettyPrint", valid_589950
  var valid_589951 = query.getOrDefault("startTime")
  valid_589951 = validateParameter(valid_589951, JString, required = false,
                                 default = nil)
  if valid_589951 != nil:
    section.add "startTime", valid_589951
  var valid_589952 = query.getOrDefault("startIndex")
  valid_589952 = validateParameter(valid_589952, JInt, required = false, default = nil)
  if valid_589952 != nil:
    section.add "startIndex", valid_589952
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589953: Call_AndroidpublisherPurchasesVoidedpurchasesList_589937;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the purchases that were canceled, refunded or charged-back.
  ## 
  let valid = call_589953.validator(path, query, header, formData, body)
  let scheme = call_589953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589953.url(scheme.get, call_589953.host, call_589953.base,
                         call_589953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589953, url, valid)

proc call*(call_589954: Call_AndroidpublisherPurchasesVoidedpurchasesList_589937;
          packageName: string; token: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          endTime: string = ""; userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true; startTime: string = ""; startIndex: int = 0): Recallable =
  ## androidpublisherPurchasesVoidedpurchasesList
  ## Lists the purchases that were canceled, refunded or charged-back.
  ##   token: string
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application for which voided purchases need to be returned (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   endTime: string
  ##          : The time, in milliseconds since the Epoch, of the newest voided purchase that you want to see in the response. The value of this parameter cannot be greater than the current time and is ignored if a pagination token is set. Default value is current time. Note: This filter is applied on the time at which the record is seen as voided by our systems and not the actual voided time returned in the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: string
  ##            : The time, in milliseconds since the Epoch, of the oldest voided purchase that you want to see in the response. The value of this parameter cannot be older than 30 days and is ignored if a pagination token is set. Default value is current time minus 30 days. Note: This filter is applied on the time at which the record is seen as voided by our systems and not the actual voided time returned in the response.
  ##   startIndex: int
  var path_589955 = newJObject()
  var query_589956 = newJObject()
  add(query_589956, "token", newJString(token))
  add(query_589956, "fields", newJString(fields))
  add(path_589955, "packageName", newJString(packageName))
  add(query_589956, "quotaUser", newJString(quotaUser))
  add(query_589956, "alt", newJString(alt))
  add(query_589956, "oauth_token", newJString(oauthToken))
  add(query_589956, "endTime", newJString(endTime))
  add(query_589956, "userIp", newJString(userIp))
  add(query_589956, "maxResults", newJInt(maxResults))
  add(query_589956, "key", newJString(key))
  add(query_589956, "prettyPrint", newJBool(prettyPrint))
  add(query_589956, "startTime", newJString(startTime))
  add(query_589956, "startIndex", newJInt(startIndex))
  result = call_589954.call(path_589955, query_589956, nil, nil, nil)

var androidpublisherPurchasesVoidedpurchasesList* = Call_AndroidpublisherPurchasesVoidedpurchasesList_589937(
    name: "androidpublisherPurchasesVoidedpurchasesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{packageName}/purchases/voidedpurchases",
    validator: validate_AndroidpublisherPurchasesVoidedpurchasesList_589938,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesVoidedpurchasesList_589939,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsList_589957 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherReviewsList_589959(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/reviews")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherReviewsList_589958(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of reviews. Only reviews from last week will be returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app for which we want reviews; for example, "com.spiffygame".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589960 = path.getOrDefault("packageName")
  valid_589960 = validateParameter(valid_589960, JString, required = true,
                                 default = nil)
  if valid_589960 != nil:
    section.add "packageName", valid_589960
  result.add "path", section
  ## parameters in `query` object:
  ##   translationLanguage: JString
  ##   token: JString
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  section = newJObject()
  var valid_589961 = query.getOrDefault("translationLanguage")
  valid_589961 = validateParameter(valid_589961, JString, required = false,
                                 default = nil)
  if valid_589961 != nil:
    section.add "translationLanguage", valid_589961
  var valid_589962 = query.getOrDefault("token")
  valid_589962 = validateParameter(valid_589962, JString, required = false,
                                 default = nil)
  if valid_589962 != nil:
    section.add "token", valid_589962
  var valid_589963 = query.getOrDefault("fields")
  valid_589963 = validateParameter(valid_589963, JString, required = false,
                                 default = nil)
  if valid_589963 != nil:
    section.add "fields", valid_589963
  var valid_589964 = query.getOrDefault("quotaUser")
  valid_589964 = validateParameter(valid_589964, JString, required = false,
                                 default = nil)
  if valid_589964 != nil:
    section.add "quotaUser", valid_589964
  var valid_589965 = query.getOrDefault("alt")
  valid_589965 = validateParameter(valid_589965, JString, required = false,
                                 default = newJString("json"))
  if valid_589965 != nil:
    section.add "alt", valid_589965
  var valid_589966 = query.getOrDefault("oauth_token")
  valid_589966 = validateParameter(valid_589966, JString, required = false,
                                 default = nil)
  if valid_589966 != nil:
    section.add "oauth_token", valid_589966
  var valid_589967 = query.getOrDefault("userIp")
  valid_589967 = validateParameter(valid_589967, JString, required = false,
                                 default = nil)
  if valid_589967 != nil:
    section.add "userIp", valid_589967
  var valid_589968 = query.getOrDefault("maxResults")
  valid_589968 = validateParameter(valid_589968, JInt, required = false, default = nil)
  if valid_589968 != nil:
    section.add "maxResults", valid_589968
  var valid_589969 = query.getOrDefault("key")
  valid_589969 = validateParameter(valid_589969, JString, required = false,
                                 default = nil)
  if valid_589969 != nil:
    section.add "key", valid_589969
  var valid_589970 = query.getOrDefault("prettyPrint")
  valid_589970 = validateParameter(valid_589970, JBool, required = false,
                                 default = newJBool(true))
  if valid_589970 != nil:
    section.add "prettyPrint", valid_589970
  var valid_589971 = query.getOrDefault("startIndex")
  valid_589971 = validateParameter(valid_589971, JInt, required = false, default = nil)
  if valid_589971 != nil:
    section.add "startIndex", valid_589971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589972: Call_AndroidpublisherReviewsList_589957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of reviews. Only reviews from last week will be returned.
  ## 
  let valid = call_589972.validator(path, query, header, formData, body)
  let scheme = call_589972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589972.url(scheme.get, call_589972.host, call_589972.base,
                         call_589972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589972, url, valid)

proc call*(call_589973: Call_AndroidpublisherReviewsList_589957;
          packageName: string; translationLanguage: string = ""; token: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## androidpublisherReviewsList
  ## Returns a list of reviews. Only reviews from last week will be returned.
  ##   translationLanguage: string
  ##   token: string
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app for which we want reviews; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  var path_589974 = newJObject()
  var query_589975 = newJObject()
  add(query_589975, "translationLanguage", newJString(translationLanguage))
  add(query_589975, "token", newJString(token))
  add(query_589975, "fields", newJString(fields))
  add(path_589974, "packageName", newJString(packageName))
  add(query_589975, "quotaUser", newJString(quotaUser))
  add(query_589975, "alt", newJString(alt))
  add(query_589975, "oauth_token", newJString(oauthToken))
  add(query_589975, "userIp", newJString(userIp))
  add(query_589975, "maxResults", newJInt(maxResults))
  add(query_589975, "key", newJString(key))
  add(query_589975, "prettyPrint", newJBool(prettyPrint))
  add(query_589975, "startIndex", newJInt(startIndex))
  result = call_589973.call(path_589974, query_589975, nil, nil, nil)

var androidpublisherReviewsList* = Call_AndroidpublisherReviewsList_589957(
    name: "androidpublisherReviewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/reviews",
    validator: validate_AndroidpublisherReviewsList_589958,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherReviewsList_589959, schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsGet_589976 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherReviewsGet_589978(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "reviewId" in path, "`reviewId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/reviews/"),
               (kind: VariableSegment, value: "reviewId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherReviewsGet_589977(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a single review.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app for which we want reviews; for example, "com.spiffygame".
  ##   reviewId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589979 = path.getOrDefault("packageName")
  valid_589979 = validateParameter(valid_589979, JString, required = true,
                                 default = nil)
  if valid_589979 != nil:
    section.add "packageName", valid_589979
  var valid_589980 = path.getOrDefault("reviewId")
  valid_589980 = validateParameter(valid_589980, JString, required = true,
                                 default = nil)
  if valid_589980 != nil:
    section.add "reviewId", valid_589980
  result.add "path", section
  ## parameters in `query` object:
  ##   translationLanguage: JString
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589981 = query.getOrDefault("translationLanguage")
  valid_589981 = validateParameter(valid_589981, JString, required = false,
                                 default = nil)
  if valid_589981 != nil:
    section.add "translationLanguage", valid_589981
  var valid_589982 = query.getOrDefault("fields")
  valid_589982 = validateParameter(valid_589982, JString, required = false,
                                 default = nil)
  if valid_589982 != nil:
    section.add "fields", valid_589982
  var valid_589983 = query.getOrDefault("quotaUser")
  valid_589983 = validateParameter(valid_589983, JString, required = false,
                                 default = nil)
  if valid_589983 != nil:
    section.add "quotaUser", valid_589983
  var valid_589984 = query.getOrDefault("alt")
  valid_589984 = validateParameter(valid_589984, JString, required = false,
                                 default = newJString("json"))
  if valid_589984 != nil:
    section.add "alt", valid_589984
  var valid_589985 = query.getOrDefault("oauth_token")
  valid_589985 = validateParameter(valid_589985, JString, required = false,
                                 default = nil)
  if valid_589985 != nil:
    section.add "oauth_token", valid_589985
  var valid_589986 = query.getOrDefault("userIp")
  valid_589986 = validateParameter(valid_589986, JString, required = false,
                                 default = nil)
  if valid_589986 != nil:
    section.add "userIp", valid_589986
  var valid_589987 = query.getOrDefault("key")
  valid_589987 = validateParameter(valid_589987, JString, required = false,
                                 default = nil)
  if valid_589987 != nil:
    section.add "key", valid_589987
  var valid_589988 = query.getOrDefault("prettyPrint")
  valid_589988 = validateParameter(valid_589988, JBool, required = false,
                                 default = newJBool(true))
  if valid_589988 != nil:
    section.add "prettyPrint", valid_589988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589989: Call_AndroidpublisherReviewsGet_589976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a single review.
  ## 
  let valid = call_589989.validator(path, query, header, formData, body)
  let scheme = call_589989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589989.url(scheme.get, call_589989.host, call_589989.base,
                         call_589989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589989, url, valid)

proc call*(call_589990: Call_AndroidpublisherReviewsGet_589976;
          packageName: string; reviewId: string; translationLanguage: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherReviewsGet
  ## Returns a single review.
  ##   translationLanguage: string
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app for which we want reviews; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   reviewId: string (required)
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589991 = newJObject()
  var query_589992 = newJObject()
  add(query_589992, "translationLanguage", newJString(translationLanguage))
  add(query_589992, "fields", newJString(fields))
  add(path_589991, "packageName", newJString(packageName))
  add(query_589992, "quotaUser", newJString(quotaUser))
  add(query_589992, "alt", newJString(alt))
  add(query_589992, "oauth_token", newJString(oauthToken))
  add(path_589991, "reviewId", newJString(reviewId))
  add(query_589992, "userIp", newJString(userIp))
  add(query_589992, "key", newJString(key))
  add(query_589992, "prettyPrint", newJBool(prettyPrint))
  result = call_589990.call(path_589991, query_589992, nil, nil, nil)

var androidpublisherReviewsGet* = Call_AndroidpublisherReviewsGet_589976(
    name: "androidpublisherReviewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/reviews/{reviewId}",
    validator: validate_AndroidpublisherReviewsGet_589977,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherReviewsGet_589978, schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsReply_589993 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherReviewsReply_589995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "reviewId" in path, "`reviewId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/reviews/"),
               (kind: VariableSegment, value: "reviewId"),
               (kind: ConstantSegment, value: ":reply")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherReviewsReply_589994(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reply to a single review, or update an existing reply.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app for which we want reviews; for example, "com.spiffygame".
  ##   reviewId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_589996 = path.getOrDefault("packageName")
  valid_589996 = validateParameter(valid_589996, JString, required = true,
                                 default = nil)
  if valid_589996 != nil:
    section.add "packageName", valid_589996
  var valid_589997 = path.getOrDefault("reviewId")
  valid_589997 = validateParameter(valid_589997, JString, required = true,
                                 default = nil)
  if valid_589997 != nil:
    section.add "reviewId", valid_589997
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589998 = query.getOrDefault("fields")
  valid_589998 = validateParameter(valid_589998, JString, required = false,
                                 default = nil)
  if valid_589998 != nil:
    section.add "fields", valid_589998
  var valid_589999 = query.getOrDefault("quotaUser")
  valid_589999 = validateParameter(valid_589999, JString, required = false,
                                 default = nil)
  if valid_589999 != nil:
    section.add "quotaUser", valid_589999
  var valid_590000 = query.getOrDefault("alt")
  valid_590000 = validateParameter(valid_590000, JString, required = false,
                                 default = newJString("json"))
  if valid_590000 != nil:
    section.add "alt", valid_590000
  var valid_590001 = query.getOrDefault("oauth_token")
  valid_590001 = validateParameter(valid_590001, JString, required = false,
                                 default = nil)
  if valid_590001 != nil:
    section.add "oauth_token", valid_590001
  var valid_590002 = query.getOrDefault("userIp")
  valid_590002 = validateParameter(valid_590002, JString, required = false,
                                 default = nil)
  if valid_590002 != nil:
    section.add "userIp", valid_590002
  var valid_590003 = query.getOrDefault("key")
  valid_590003 = validateParameter(valid_590003, JString, required = false,
                                 default = nil)
  if valid_590003 != nil:
    section.add "key", valid_590003
  var valid_590004 = query.getOrDefault("prettyPrint")
  valid_590004 = validateParameter(valid_590004, JBool, required = false,
                                 default = newJBool(true))
  if valid_590004 != nil:
    section.add "prettyPrint", valid_590004
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

proc call*(call_590006: Call_AndroidpublisherReviewsReply_589993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reply to a single review, or update an existing reply.
  ## 
  let valid = call_590006.validator(path, query, header, formData, body)
  let scheme = call_590006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590006.url(scheme.get, call_590006.host, call_590006.base,
                         call_590006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590006, url, valid)

proc call*(call_590007: Call_AndroidpublisherReviewsReply_589993;
          packageName: string; reviewId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherReviewsReply
  ## Reply to a single review, or update an existing reply.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app for which we want reviews; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   reviewId: string (required)
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590008 = newJObject()
  var query_590009 = newJObject()
  var body_590010 = newJObject()
  add(query_590009, "fields", newJString(fields))
  add(path_590008, "packageName", newJString(packageName))
  add(query_590009, "quotaUser", newJString(quotaUser))
  add(query_590009, "alt", newJString(alt))
  add(query_590009, "oauth_token", newJString(oauthToken))
  add(path_590008, "reviewId", newJString(reviewId))
  add(query_590009, "userIp", newJString(userIp))
  add(query_590009, "key", newJString(key))
  if body != nil:
    body_590010 = body
  add(query_590009, "prettyPrint", newJBool(prettyPrint))
  result = call_590007.call(path_590008, query_590009, nil, nil, body_590010)

var androidpublisherReviewsReply* = Call_AndroidpublisherReviewsReply_589993(
    name: "androidpublisherReviewsReply", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/reviews/{reviewId}:reply",
    validator: validate_AndroidpublisherReviewsReply_589994,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherReviewsReply_589995, schemes: {Scheme.Https})
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
