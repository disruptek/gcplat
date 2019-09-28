
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
  gcpServiceName = "androidpublisher"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidpublisherEditsInsert_579689 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsInsert_579691(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsInsert_579690(path: JsonNode; query: JsonNode;
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
  var valid_579817 = path.getOrDefault("packageName")
  valid_579817 = validateParameter(valid_579817, JString, required = true,
                                 default = nil)
  if valid_579817 != nil:
    section.add "packageName", valid_579817
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
  var valid_579818 = query.getOrDefault("fields")
  valid_579818 = validateParameter(valid_579818, JString, required = false,
                                 default = nil)
  if valid_579818 != nil:
    section.add "fields", valid_579818
  var valid_579819 = query.getOrDefault("quotaUser")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "quotaUser", valid_579819
  var valid_579833 = query.getOrDefault("alt")
  valid_579833 = validateParameter(valid_579833, JString, required = false,
                                 default = newJString("json"))
  if valid_579833 != nil:
    section.add "alt", valid_579833
  var valid_579834 = query.getOrDefault("oauth_token")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = nil)
  if valid_579834 != nil:
    section.add "oauth_token", valid_579834
  var valid_579835 = query.getOrDefault("userIp")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = nil)
  if valid_579835 != nil:
    section.add "userIp", valid_579835
  var valid_579836 = query.getOrDefault("key")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "key", valid_579836
  var valid_579837 = query.getOrDefault("prettyPrint")
  valid_579837 = validateParameter(valid_579837, JBool, required = false,
                                 default = newJBool(true))
  if valid_579837 != nil:
    section.add "prettyPrint", valid_579837
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

proc call*(call_579861: Call_AndroidpublisherEditsInsert_579689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new edit for an app, populated with the app's current state.
  ## 
  let valid = call_579861.validator(path, query, header, formData, body)
  let scheme = call_579861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579861.url(scheme.get, call_579861.host, call_579861.base,
                         call_579861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579861, url, valid)

proc call*(call_579932: Call_AndroidpublisherEditsInsert_579689;
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
  var path_579933 = newJObject()
  var query_579935 = newJObject()
  var body_579936 = newJObject()
  add(query_579935, "fields", newJString(fields))
  add(path_579933, "packageName", newJString(packageName))
  add(query_579935, "quotaUser", newJString(quotaUser))
  add(query_579935, "alt", newJString(alt))
  add(query_579935, "oauth_token", newJString(oauthToken))
  add(query_579935, "userIp", newJString(userIp))
  add(query_579935, "key", newJString(key))
  if body != nil:
    body_579936 = body
  add(query_579935, "prettyPrint", newJBool(prettyPrint))
  result = call_579932.call(path_579933, query_579935, nil, nil, body_579936)

var androidpublisherEditsInsert* = Call_AndroidpublisherEditsInsert_579689(
    name: "androidpublisherEditsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits",
    validator: validate_AndroidpublisherEditsInsert_579690,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsInsert_579691, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsGet_579975 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsGet_579977(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsGet_579976(path: JsonNode; query: JsonNode;
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
  var valid_579978 = path.getOrDefault("packageName")
  valid_579978 = validateParameter(valid_579978, JString, required = true,
                                 default = nil)
  if valid_579978 != nil:
    section.add "packageName", valid_579978
  var valid_579979 = path.getOrDefault("editId")
  valid_579979 = validateParameter(valid_579979, JString, required = true,
                                 default = nil)
  if valid_579979 != nil:
    section.add "editId", valid_579979
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
  var valid_579980 = query.getOrDefault("fields")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "fields", valid_579980
  var valid_579981 = query.getOrDefault("quotaUser")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "quotaUser", valid_579981
  var valid_579982 = query.getOrDefault("alt")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = newJString("json"))
  if valid_579982 != nil:
    section.add "alt", valid_579982
  var valid_579983 = query.getOrDefault("oauth_token")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "oauth_token", valid_579983
  var valid_579984 = query.getOrDefault("userIp")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "userIp", valid_579984
  var valid_579985 = query.getOrDefault("key")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "key", valid_579985
  var valid_579986 = query.getOrDefault("prettyPrint")
  valid_579986 = validateParameter(valid_579986, JBool, required = false,
                                 default = newJBool(true))
  if valid_579986 != nil:
    section.add "prettyPrint", valid_579986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579987: Call_AndroidpublisherEditsGet_579975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the edit specified. Calls will fail if the edit is no long active (e.g. has been deleted, superseded or expired).
  ## 
  let valid = call_579987.validator(path, query, header, formData, body)
  let scheme = call_579987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579987.url(scheme.get, call_579987.host, call_579987.base,
                         call_579987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579987, url, valid)

proc call*(call_579988: Call_AndroidpublisherEditsGet_579975; packageName: string;
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
  var path_579989 = newJObject()
  var query_579990 = newJObject()
  add(query_579990, "fields", newJString(fields))
  add(path_579989, "packageName", newJString(packageName))
  add(query_579990, "quotaUser", newJString(quotaUser))
  add(query_579990, "alt", newJString(alt))
  add(path_579989, "editId", newJString(editId))
  add(query_579990, "oauth_token", newJString(oauthToken))
  add(query_579990, "userIp", newJString(userIp))
  add(query_579990, "key", newJString(key))
  add(query_579990, "prettyPrint", newJBool(prettyPrint))
  result = call_579988.call(path_579989, query_579990, nil, nil, nil)

var androidpublisherEditsGet* = Call_AndroidpublisherEditsGet_579975(
    name: "androidpublisherEditsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}",
    validator: validate_AndroidpublisherEditsGet_579976,
    base: "/androidpublisher/v2/applications", url: url_AndroidpublisherEditsGet_579977,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDelete_579991 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsDelete_579993(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsDelete_579992(path: JsonNode; query: JsonNode;
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
  var valid_579994 = path.getOrDefault("packageName")
  valid_579994 = validateParameter(valid_579994, JString, required = true,
                                 default = nil)
  if valid_579994 != nil:
    section.add "packageName", valid_579994
  var valid_579995 = path.getOrDefault("editId")
  valid_579995 = validateParameter(valid_579995, JString, required = true,
                                 default = nil)
  if valid_579995 != nil:
    section.add "editId", valid_579995
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
  var valid_579996 = query.getOrDefault("fields")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "fields", valid_579996
  var valid_579997 = query.getOrDefault("quotaUser")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "quotaUser", valid_579997
  var valid_579998 = query.getOrDefault("alt")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = newJString("json"))
  if valid_579998 != nil:
    section.add "alt", valid_579998
  var valid_579999 = query.getOrDefault("oauth_token")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "oauth_token", valid_579999
  var valid_580000 = query.getOrDefault("userIp")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "userIp", valid_580000
  var valid_580001 = query.getOrDefault("key")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "key", valid_580001
  var valid_580002 = query.getOrDefault("prettyPrint")
  valid_580002 = validateParameter(valid_580002, JBool, required = false,
                                 default = newJBool(true))
  if valid_580002 != nil:
    section.add "prettyPrint", valid_580002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580003: Call_AndroidpublisherEditsDelete_579991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an edit for an app. Creating a new edit will automatically delete any of your previous edits so this method need only be called if you want to preemptively abandon an edit.
  ## 
  let valid = call_580003.validator(path, query, header, formData, body)
  let scheme = call_580003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580003.url(scheme.get, call_580003.host, call_580003.base,
                         call_580003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580003, url, valid)

proc call*(call_580004: Call_AndroidpublisherEditsDelete_579991;
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
  var path_580005 = newJObject()
  var query_580006 = newJObject()
  add(query_580006, "fields", newJString(fields))
  add(path_580005, "packageName", newJString(packageName))
  add(query_580006, "quotaUser", newJString(quotaUser))
  add(query_580006, "alt", newJString(alt))
  add(path_580005, "editId", newJString(editId))
  add(query_580006, "oauth_token", newJString(oauthToken))
  add(query_580006, "userIp", newJString(userIp))
  add(query_580006, "key", newJString(key))
  add(query_580006, "prettyPrint", newJBool(prettyPrint))
  result = call_580004.call(path_580005, query_580006, nil, nil, nil)

var androidpublisherEditsDelete* = Call_AndroidpublisherEditsDelete_579991(
    name: "androidpublisherEditsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}",
    validator: validate_AndroidpublisherEditsDelete_579992,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDelete_579993, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksUpload_580023 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsApksUpload_580025(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsApksUpload_580024(path: JsonNode;
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
  var valid_580026 = path.getOrDefault("packageName")
  valid_580026 = validateParameter(valid_580026, JString, required = true,
                                 default = nil)
  if valid_580026 != nil:
    section.add "packageName", valid_580026
  var valid_580027 = path.getOrDefault("editId")
  valid_580027 = validateParameter(valid_580027, JString, required = true,
                                 default = nil)
  if valid_580027 != nil:
    section.add "editId", valid_580027
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
  var valid_580028 = query.getOrDefault("fields")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "fields", valid_580028
  var valid_580029 = query.getOrDefault("quotaUser")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "quotaUser", valid_580029
  var valid_580030 = query.getOrDefault("alt")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = newJString("json"))
  if valid_580030 != nil:
    section.add "alt", valid_580030
  var valid_580031 = query.getOrDefault("oauth_token")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "oauth_token", valid_580031
  var valid_580032 = query.getOrDefault("userIp")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "userIp", valid_580032
  var valid_580033 = query.getOrDefault("key")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "key", valid_580033
  var valid_580034 = query.getOrDefault("prettyPrint")
  valid_580034 = validateParameter(valid_580034, JBool, required = false,
                                 default = newJBool(true))
  if valid_580034 != nil:
    section.add "prettyPrint", valid_580034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580035: Call_AndroidpublisherEditsApksUpload_580023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_580035.validator(path, query, header, formData, body)
  let scheme = call_580035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580035.url(scheme.get, call_580035.host, call_580035.base,
                         call_580035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580035, url, valid)

proc call*(call_580036: Call_AndroidpublisherEditsApksUpload_580023;
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
  var path_580037 = newJObject()
  var query_580038 = newJObject()
  add(query_580038, "fields", newJString(fields))
  add(path_580037, "packageName", newJString(packageName))
  add(query_580038, "quotaUser", newJString(quotaUser))
  add(query_580038, "alt", newJString(alt))
  add(path_580037, "editId", newJString(editId))
  add(query_580038, "oauth_token", newJString(oauthToken))
  add(query_580038, "userIp", newJString(userIp))
  add(query_580038, "key", newJString(key))
  add(query_580038, "prettyPrint", newJBool(prettyPrint))
  result = call_580036.call(path_580037, query_580038, nil, nil, nil)

var androidpublisherEditsApksUpload* = Call_AndroidpublisherEditsApksUpload_580023(
    name: "androidpublisherEditsApksUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks",
    validator: validate_AndroidpublisherEditsApksUpload_580024,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApksUpload_580025, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksList_580007 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsApksList_580009(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsApksList_580008(path: JsonNode; query: JsonNode;
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
  var valid_580010 = path.getOrDefault("packageName")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "packageName", valid_580010
  var valid_580011 = path.getOrDefault("editId")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "editId", valid_580011
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
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("oauth_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "oauth_token", valid_580015
  var valid_580016 = query.getOrDefault("userIp")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "userIp", valid_580016
  var valid_580017 = query.getOrDefault("key")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "key", valid_580017
  var valid_580018 = query.getOrDefault("prettyPrint")
  valid_580018 = validateParameter(valid_580018, JBool, required = false,
                                 default = newJBool(true))
  if valid_580018 != nil:
    section.add "prettyPrint", valid_580018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580019: Call_AndroidpublisherEditsApksList_580007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_580019.validator(path, query, header, formData, body)
  let scheme = call_580019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580019.url(scheme.get, call_580019.host, call_580019.base,
                         call_580019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580019, url, valid)

proc call*(call_580020: Call_AndroidpublisherEditsApksList_580007;
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
  var path_580021 = newJObject()
  var query_580022 = newJObject()
  add(query_580022, "fields", newJString(fields))
  add(path_580021, "packageName", newJString(packageName))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(query_580022, "alt", newJString(alt))
  add(path_580021, "editId", newJString(editId))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "userIp", newJString(userIp))
  add(query_580022, "key", newJString(key))
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  result = call_580020.call(path_580021, query_580022, nil, nil, nil)

var androidpublisherEditsApksList* = Call_AndroidpublisherEditsApksList_580007(
    name: "androidpublisherEditsApksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks",
    validator: validate_AndroidpublisherEditsApksList_580008,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApksList_580009, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksAddexternallyhosted_580039 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsApksAddexternallyhosted_580041(protocol: Scheme;
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

proc validate_AndroidpublisherEditsApksAddexternallyhosted_580040(path: JsonNode;
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
  var valid_580042 = path.getOrDefault("packageName")
  valid_580042 = validateParameter(valid_580042, JString, required = true,
                                 default = nil)
  if valid_580042 != nil:
    section.add "packageName", valid_580042
  var valid_580043 = path.getOrDefault("editId")
  valid_580043 = validateParameter(valid_580043, JString, required = true,
                                 default = nil)
  if valid_580043 != nil:
    section.add "editId", valid_580043
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
  var valid_580044 = query.getOrDefault("fields")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "fields", valid_580044
  var valid_580045 = query.getOrDefault("quotaUser")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "quotaUser", valid_580045
  var valid_580046 = query.getOrDefault("alt")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = newJString("json"))
  if valid_580046 != nil:
    section.add "alt", valid_580046
  var valid_580047 = query.getOrDefault("oauth_token")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "oauth_token", valid_580047
  var valid_580048 = query.getOrDefault("userIp")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "userIp", valid_580048
  var valid_580049 = query.getOrDefault("key")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "key", valid_580049
  var valid_580050 = query.getOrDefault("prettyPrint")
  valid_580050 = validateParameter(valid_580050, JBool, required = false,
                                 default = newJBool(true))
  if valid_580050 != nil:
    section.add "prettyPrint", valid_580050
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

proc call*(call_580052: Call_AndroidpublisherEditsApksAddexternallyhosted_580039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new APK without uploading the APK itself to Google Play, instead hosting the APK at a specified URL. This function is only available to enterprises using Google Play for Work whose application is configured to restrict distribution to the enterprise domain.
  ## 
  let valid = call_580052.validator(path, query, header, formData, body)
  let scheme = call_580052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580052.url(scheme.get, call_580052.host, call_580052.base,
                         call_580052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580052, url, valid)

proc call*(call_580053: Call_AndroidpublisherEditsApksAddexternallyhosted_580039;
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
  var path_580054 = newJObject()
  var query_580055 = newJObject()
  var body_580056 = newJObject()
  add(query_580055, "fields", newJString(fields))
  add(path_580054, "packageName", newJString(packageName))
  add(query_580055, "quotaUser", newJString(quotaUser))
  add(query_580055, "alt", newJString(alt))
  add(path_580054, "editId", newJString(editId))
  add(query_580055, "oauth_token", newJString(oauthToken))
  add(query_580055, "userIp", newJString(userIp))
  add(query_580055, "key", newJString(key))
  if body != nil:
    body_580056 = body
  add(query_580055, "prettyPrint", newJBool(prettyPrint))
  result = call_580053.call(path_580054, query_580055, nil, nil, body_580056)

var androidpublisherEditsApksAddexternallyhosted* = Call_AndroidpublisherEditsApksAddexternallyhosted_580039(
    name: "androidpublisherEditsApksAddexternallyhosted",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/apks/externallyHosted",
    validator: validate_AndroidpublisherEditsApksAddexternallyhosted_580040,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApksAddexternallyhosted_580041,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDeobfuscationfilesUpload_580057 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsDeobfuscationfilesUpload_580059(protocol: Scheme;
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

proc validate_AndroidpublisherEditsDeobfuscationfilesUpload_580058(
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
  var valid_580060 = path.getOrDefault("packageName")
  valid_580060 = validateParameter(valid_580060, JString, required = true,
                                 default = nil)
  if valid_580060 != nil:
    section.add "packageName", valid_580060
  var valid_580061 = path.getOrDefault("deobfuscationFileType")
  valid_580061 = validateParameter(valid_580061, JString, required = true,
                                 default = newJString("proguard"))
  if valid_580061 != nil:
    section.add "deobfuscationFileType", valid_580061
  var valid_580062 = path.getOrDefault("editId")
  valid_580062 = validateParameter(valid_580062, JString, required = true,
                                 default = nil)
  if valid_580062 != nil:
    section.add "editId", valid_580062
  var valid_580063 = path.getOrDefault("apkVersionCode")
  valid_580063 = validateParameter(valid_580063, JInt, required = true, default = nil)
  if valid_580063 != nil:
    section.add "apkVersionCode", valid_580063
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
  var valid_580064 = query.getOrDefault("fields")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "fields", valid_580064
  var valid_580065 = query.getOrDefault("quotaUser")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "quotaUser", valid_580065
  var valid_580066 = query.getOrDefault("alt")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = newJString("json"))
  if valid_580066 != nil:
    section.add "alt", valid_580066
  var valid_580067 = query.getOrDefault("oauth_token")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "oauth_token", valid_580067
  var valid_580068 = query.getOrDefault("userIp")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "userIp", valid_580068
  var valid_580069 = query.getOrDefault("key")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "key", valid_580069
  var valid_580070 = query.getOrDefault("prettyPrint")
  valid_580070 = validateParameter(valid_580070, JBool, required = false,
                                 default = newJBool(true))
  if valid_580070 != nil:
    section.add "prettyPrint", valid_580070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580071: Call_AndroidpublisherEditsDeobfuscationfilesUpload_580057;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads the deobfuscation file of the specified APK. If a deobfuscation file already exists, it will be replaced.
  ## 
  let valid = call_580071.validator(path, query, header, formData, body)
  let scheme = call_580071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580071.url(scheme.get, call_580071.host, call_580071.base,
                         call_580071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580071, url, valid)

proc call*(call_580072: Call_AndroidpublisherEditsDeobfuscationfilesUpload_580057;
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
  var path_580073 = newJObject()
  var query_580074 = newJObject()
  add(query_580074, "fields", newJString(fields))
  add(path_580073, "packageName", newJString(packageName))
  add(query_580074, "quotaUser", newJString(quotaUser))
  add(path_580073, "deobfuscationFileType", newJString(deobfuscationFileType))
  add(query_580074, "alt", newJString(alt))
  add(path_580073, "editId", newJString(editId))
  add(query_580074, "oauth_token", newJString(oauthToken))
  add(query_580074, "userIp", newJString(userIp))
  add(query_580074, "key", newJString(key))
  add(query_580074, "prettyPrint", newJBool(prettyPrint))
  add(path_580073, "apkVersionCode", newJInt(apkVersionCode))
  result = call_580072.call(path_580073, query_580074, nil, nil, nil)

var androidpublisherEditsDeobfuscationfilesUpload* = Call_AndroidpublisherEditsDeobfuscationfilesUpload_580057(
    name: "androidpublisherEditsDeobfuscationfilesUpload",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/deobfuscationFiles/{deobfuscationFileType}",
    validator: validate_AndroidpublisherEditsDeobfuscationfilesUpload_580058,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDeobfuscationfilesUpload_580059,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesUpdate_580093 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsExpansionfilesUpdate_580095(protocol: Scheme;
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

proc validate_AndroidpublisherEditsExpansionfilesUpdate_580094(path: JsonNode;
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
  var valid_580096 = path.getOrDefault("packageName")
  valid_580096 = validateParameter(valid_580096, JString, required = true,
                                 default = nil)
  if valid_580096 != nil:
    section.add "packageName", valid_580096
  var valid_580097 = path.getOrDefault("editId")
  valid_580097 = validateParameter(valid_580097, JString, required = true,
                                 default = nil)
  if valid_580097 != nil:
    section.add "editId", valid_580097
  var valid_580098 = path.getOrDefault("expansionFileType")
  valid_580098 = validateParameter(valid_580098, JString, required = true,
                                 default = newJString("main"))
  if valid_580098 != nil:
    section.add "expansionFileType", valid_580098
  var valid_580099 = path.getOrDefault("apkVersionCode")
  valid_580099 = validateParameter(valid_580099, JInt, required = true, default = nil)
  if valid_580099 != nil:
    section.add "apkVersionCode", valid_580099
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
  var valid_580104 = query.getOrDefault("userIp")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "userIp", valid_580104
  var valid_580105 = query.getOrDefault("key")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "key", valid_580105
  var valid_580106 = query.getOrDefault("prettyPrint")
  valid_580106 = validateParameter(valid_580106, JBool, required = false,
                                 default = newJBool(true))
  if valid_580106 != nil:
    section.add "prettyPrint", valid_580106
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

proc call*(call_580108: Call_AndroidpublisherEditsExpansionfilesUpdate_580093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method.
  ## 
  let valid = call_580108.validator(path, query, header, formData, body)
  let scheme = call_580108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580108.url(scheme.get, call_580108.host, call_580108.base,
                         call_580108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580108, url, valid)

proc call*(call_580109: Call_AndroidpublisherEditsExpansionfilesUpdate_580093;
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
  var path_580110 = newJObject()
  var query_580111 = newJObject()
  var body_580112 = newJObject()
  add(query_580111, "fields", newJString(fields))
  add(path_580110, "packageName", newJString(packageName))
  add(query_580111, "quotaUser", newJString(quotaUser))
  add(query_580111, "alt", newJString(alt))
  add(path_580110, "editId", newJString(editId))
  add(query_580111, "oauth_token", newJString(oauthToken))
  add(query_580111, "userIp", newJString(userIp))
  add(query_580111, "key", newJString(key))
  add(path_580110, "expansionFileType", newJString(expansionFileType))
  if body != nil:
    body_580112 = body
  add(query_580111, "prettyPrint", newJBool(prettyPrint))
  add(path_580110, "apkVersionCode", newJInt(apkVersionCode))
  result = call_580109.call(path_580110, query_580111, nil, nil, body_580112)

var androidpublisherEditsExpansionfilesUpdate* = Call_AndroidpublisherEditsExpansionfilesUpdate_580093(
    name: "androidpublisherEditsExpansionfilesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesUpdate_580094,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsExpansionfilesUpdate_580095,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesUpload_580113 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsExpansionfilesUpload_580115(protocol: Scheme;
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

proc validate_AndroidpublisherEditsExpansionfilesUpload_580114(path: JsonNode;
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
  var valid_580116 = path.getOrDefault("packageName")
  valid_580116 = validateParameter(valid_580116, JString, required = true,
                                 default = nil)
  if valid_580116 != nil:
    section.add "packageName", valid_580116
  var valid_580117 = path.getOrDefault("editId")
  valid_580117 = validateParameter(valid_580117, JString, required = true,
                                 default = nil)
  if valid_580117 != nil:
    section.add "editId", valid_580117
  var valid_580118 = path.getOrDefault("expansionFileType")
  valid_580118 = validateParameter(valid_580118, JString, required = true,
                                 default = newJString("main"))
  if valid_580118 != nil:
    section.add "expansionFileType", valid_580118
  var valid_580119 = path.getOrDefault("apkVersionCode")
  valid_580119 = validateParameter(valid_580119, JInt, required = true, default = nil)
  if valid_580119 != nil:
    section.add "apkVersionCode", valid_580119
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
  var valid_580120 = query.getOrDefault("fields")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "fields", valid_580120
  var valid_580121 = query.getOrDefault("quotaUser")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "quotaUser", valid_580121
  var valid_580122 = query.getOrDefault("alt")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = newJString("json"))
  if valid_580122 != nil:
    section.add "alt", valid_580122
  var valid_580123 = query.getOrDefault("oauth_token")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "oauth_token", valid_580123
  var valid_580124 = query.getOrDefault("userIp")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "userIp", valid_580124
  var valid_580125 = query.getOrDefault("key")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "key", valid_580125
  var valid_580126 = query.getOrDefault("prettyPrint")
  valid_580126 = validateParameter(valid_580126, JBool, required = false,
                                 default = newJBool(true))
  if valid_580126 != nil:
    section.add "prettyPrint", valid_580126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580127: Call_AndroidpublisherEditsExpansionfilesUpload_580113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads and attaches a new Expansion File to the APK specified.
  ## 
  let valid = call_580127.validator(path, query, header, formData, body)
  let scheme = call_580127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580127.url(scheme.get, call_580127.host, call_580127.base,
                         call_580127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580127, url, valid)

proc call*(call_580128: Call_AndroidpublisherEditsExpansionfilesUpload_580113;
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
  var path_580129 = newJObject()
  var query_580130 = newJObject()
  add(query_580130, "fields", newJString(fields))
  add(path_580129, "packageName", newJString(packageName))
  add(query_580130, "quotaUser", newJString(quotaUser))
  add(query_580130, "alt", newJString(alt))
  add(path_580129, "editId", newJString(editId))
  add(query_580130, "oauth_token", newJString(oauthToken))
  add(query_580130, "userIp", newJString(userIp))
  add(query_580130, "key", newJString(key))
  add(path_580129, "expansionFileType", newJString(expansionFileType))
  add(query_580130, "prettyPrint", newJBool(prettyPrint))
  add(path_580129, "apkVersionCode", newJInt(apkVersionCode))
  result = call_580128.call(path_580129, query_580130, nil, nil, nil)

var androidpublisherEditsExpansionfilesUpload* = Call_AndroidpublisherEditsExpansionfilesUpload_580113(
    name: "androidpublisherEditsExpansionfilesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesUpload_580114,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsExpansionfilesUpload_580115,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesGet_580075 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsExpansionfilesGet_580077(protocol: Scheme;
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

proc validate_AndroidpublisherEditsExpansionfilesGet_580076(path: JsonNode;
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
  var valid_580078 = path.getOrDefault("packageName")
  valid_580078 = validateParameter(valid_580078, JString, required = true,
                                 default = nil)
  if valid_580078 != nil:
    section.add "packageName", valid_580078
  var valid_580079 = path.getOrDefault("editId")
  valid_580079 = validateParameter(valid_580079, JString, required = true,
                                 default = nil)
  if valid_580079 != nil:
    section.add "editId", valid_580079
  var valid_580080 = path.getOrDefault("expansionFileType")
  valid_580080 = validateParameter(valid_580080, JString, required = true,
                                 default = newJString("main"))
  if valid_580080 != nil:
    section.add "expansionFileType", valid_580080
  var valid_580081 = path.getOrDefault("apkVersionCode")
  valid_580081 = validateParameter(valid_580081, JInt, required = true, default = nil)
  if valid_580081 != nil:
    section.add "apkVersionCode", valid_580081
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
  var valid_580082 = query.getOrDefault("fields")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "fields", valid_580082
  var valid_580083 = query.getOrDefault("quotaUser")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "quotaUser", valid_580083
  var valid_580084 = query.getOrDefault("alt")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = newJString("json"))
  if valid_580084 != nil:
    section.add "alt", valid_580084
  var valid_580085 = query.getOrDefault("oauth_token")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "oauth_token", valid_580085
  var valid_580086 = query.getOrDefault("userIp")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "userIp", valid_580086
  var valid_580087 = query.getOrDefault("key")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "key", valid_580087
  var valid_580088 = query.getOrDefault("prettyPrint")
  valid_580088 = validateParameter(valid_580088, JBool, required = false,
                                 default = newJBool(true))
  if valid_580088 != nil:
    section.add "prettyPrint", valid_580088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580089: Call_AndroidpublisherEditsExpansionfilesGet_580075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the Expansion File configuration for the APK specified.
  ## 
  let valid = call_580089.validator(path, query, header, formData, body)
  let scheme = call_580089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580089.url(scheme.get, call_580089.host, call_580089.base,
                         call_580089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580089, url, valid)

proc call*(call_580090: Call_AndroidpublisherEditsExpansionfilesGet_580075;
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
  var path_580091 = newJObject()
  var query_580092 = newJObject()
  add(query_580092, "fields", newJString(fields))
  add(path_580091, "packageName", newJString(packageName))
  add(query_580092, "quotaUser", newJString(quotaUser))
  add(query_580092, "alt", newJString(alt))
  add(path_580091, "editId", newJString(editId))
  add(query_580092, "oauth_token", newJString(oauthToken))
  add(query_580092, "userIp", newJString(userIp))
  add(query_580092, "key", newJString(key))
  add(path_580091, "expansionFileType", newJString(expansionFileType))
  add(query_580092, "prettyPrint", newJBool(prettyPrint))
  add(path_580091, "apkVersionCode", newJInt(apkVersionCode))
  result = call_580090.call(path_580091, query_580092, nil, nil, nil)

var androidpublisherEditsExpansionfilesGet* = Call_AndroidpublisherEditsExpansionfilesGet_580075(
    name: "androidpublisherEditsExpansionfilesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesGet_580076,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsExpansionfilesGet_580077,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesPatch_580131 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsExpansionfilesPatch_580133(protocol: Scheme;
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

proc validate_AndroidpublisherEditsExpansionfilesPatch_580132(path: JsonNode;
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
  var valid_580134 = path.getOrDefault("packageName")
  valid_580134 = validateParameter(valid_580134, JString, required = true,
                                 default = nil)
  if valid_580134 != nil:
    section.add "packageName", valid_580134
  var valid_580135 = path.getOrDefault("editId")
  valid_580135 = validateParameter(valid_580135, JString, required = true,
                                 default = nil)
  if valid_580135 != nil:
    section.add "editId", valid_580135
  var valid_580136 = path.getOrDefault("expansionFileType")
  valid_580136 = validateParameter(valid_580136, JString, required = true,
                                 default = newJString("main"))
  if valid_580136 != nil:
    section.add "expansionFileType", valid_580136
  var valid_580137 = path.getOrDefault("apkVersionCode")
  valid_580137 = validateParameter(valid_580137, JInt, required = true, default = nil)
  if valid_580137 != nil:
    section.add "apkVersionCode", valid_580137
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
  var valid_580138 = query.getOrDefault("fields")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "fields", valid_580138
  var valid_580139 = query.getOrDefault("quotaUser")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "quotaUser", valid_580139
  var valid_580140 = query.getOrDefault("alt")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("json"))
  if valid_580140 != nil:
    section.add "alt", valid_580140
  var valid_580141 = query.getOrDefault("oauth_token")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "oauth_token", valid_580141
  var valid_580142 = query.getOrDefault("userIp")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "userIp", valid_580142
  var valid_580143 = query.getOrDefault("key")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "key", valid_580143
  var valid_580144 = query.getOrDefault("prettyPrint")
  valid_580144 = validateParameter(valid_580144, JBool, required = false,
                                 default = newJBool(true))
  if valid_580144 != nil:
    section.add "prettyPrint", valid_580144
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

proc call*(call_580146: Call_AndroidpublisherEditsExpansionfilesPatch_580131;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method. This method supports patch semantics.
  ## 
  let valid = call_580146.validator(path, query, header, formData, body)
  let scheme = call_580146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580146.url(scheme.get, call_580146.host, call_580146.base,
                         call_580146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580146, url, valid)

proc call*(call_580147: Call_AndroidpublisherEditsExpansionfilesPatch_580131;
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
  var path_580148 = newJObject()
  var query_580149 = newJObject()
  var body_580150 = newJObject()
  add(query_580149, "fields", newJString(fields))
  add(path_580148, "packageName", newJString(packageName))
  add(query_580149, "quotaUser", newJString(quotaUser))
  add(query_580149, "alt", newJString(alt))
  add(path_580148, "editId", newJString(editId))
  add(query_580149, "oauth_token", newJString(oauthToken))
  add(query_580149, "userIp", newJString(userIp))
  add(query_580149, "key", newJString(key))
  add(path_580148, "expansionFileType", newJString(expansionFileType))
  if body != nil:
    body_580150 = body
  add(query_580149, "prettyPrint", newJBool(prettyPrint))
  add(path_580148, "apkVersionCode", newJInt(apkVersionCode))
  result = call_580147.call(path_580148, query_580149, nil, nil, body_580150)

var androidpublisherEditsExpansionfilesPatch* = Call_AndroidpublisherEditsExpansionfilesPatch_580131(
    name: "androidpublisherEditsExpansionfilesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesPatch_580132,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsExpansionfilesPatch_580133,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsList_580151 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsApklistingsList_580153(protocol: Scheme;
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

proc validate_AndroidpublisherEditsApklistingsList_580152(path: JsonNode;
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
  var valid_580154 = path.getOrDefault("packageName")
  valid_580154 = validateParameter(valid_580154, JString, required = true,
                                 default = nil)
  if valid_580154 != nil:
    section.add "packageName", valid_580154
  var valid_580155 = path.getOrDefault("editId")
  valid_580155 = validateParameter(valid_580155, JString, required = true,
                                 default = nil)
  if valid_580155 != nil:
    section.add "editId", valid_580155
  var valid_580156 = path.getOrDefault("apkVersionCode")
  valid_580156 = validateParameter(valid_580156, JInt, required = true, default = nil)
  if valid_580156 != nil:
    section.add "apkVersionCode", valid_580156
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
  var valid_580157 = query.getOrDefault("fields")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "fields", valid_580157
  var valid_580158 = query.getOrDefault("quotaUser")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "quotaUser", valid_580158
  var valid_580159 = query.getOrDefault("alt")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = newJString("json"))
  if valid_580159 != nil:
    section.add "alt", valid_580159
  var valid_580160 = query.getOrDefault("oauth_token")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "oauth_token", valid_580160
  var valid_580161 = query.getOrDefault("userIp")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "userIp", valid_580161
  var valid_580162 = query.getOrDefault("key")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "key", valid_580162
  var valid_580163 = query.getOrDefault("prettyPrint")
  valid_580163 = validateParameter(valid_580163, JBool, required = false,
                                 default = newJBool(true))
  if valid_580163 != nil:
    section.add "prettyPrint", valid_580163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580164: Call_AndroidpublisherEditsApklistingsList_580151;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the APK-specific localized listings for a specified APK.
  ## 
  let valid = call_580164.validator(path, query, header, formData, body)
  let scheme = call_580164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580164.url(scheme.get, call_580164.host, call_580164.base,
                         call_580164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580164, url, valid)

proc call*(call_580165: Call_AndroidpublisherEditsApklistingsList_580151;
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
  var path_580166 = newJObject()
  var query_580167 = newJObject()
  add(query_580167, "fields", newJString(fields))
  add(path_580166, "packageName", newJString(packageName))
  add(query_580167, "quotaUser", newJString(quotaUser))
  add(query_580167, "alt", newJString(alt))
  add(path_580166, "editId", newJString(editId))
  add(query_580167, "oauth_token", newJString(oauthToken))
  add(query_580167, "userIp", newJString(userIp))
  add(query_580167, "key", newJString(key))
  add(query_580167, "prettyPrint", newJBool(prettyPrint))
  add(path_580166, "apkVersionCode", newJInt(apkVersionCode))
  result = call_580165.call(path_580166, query_580167, nil, nil, nil)

var androidpublisherEditsApklistingsList* = Call_AndroidpublisherEditsApklistingsList_580151(
    name: "androidpublisherEditsApklistingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings",
    validator: validate_AndroidpublisherEditsApklistingsList_580152,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsList_580153, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsDeleteall_580168 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsApklistingsDeleteall_580170(protocol: Scheme;
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

proc validate_AndroidpublisherEditsApklistingsDeleteall_580169(path: JsonNode;
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
  var valid_580171 = path.getOrDefault("packageName")
  valid_580171 = validateParameter(valid_580171, JString, required = true,
                                 default = nil)
  if valid_580171 != nil:
    section.add "packageName", valid_580171
  var valid_580172 = path.getOrDefault("editId")
  valid_580172 = validateParameter(valid_580172, JString, required = true,
                                 default = nil)
  if valid_580172 != nil:
    section.add "editId", valid_580172
  var valid_580173 = path.getOrDefault("apkVersionCode")
  valid_580173 = validateParameter(valid_580173, JInt, required = true, default = nil)
  if valid_580173 != nil:
    section.add "apkVersionCode", valid_580173
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
  var valid_580174 = query.getOrDefault("fields")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "fields", valid_580174
  var valid_580175 = query.getOrDefault("quotaUser")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "quotaUser", valid_580175
  var valid_580176 = query.getOrDefault("alt")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = newJString("json"))
  if valid_580176 != nil:
    section.add "alt", valid_580176
  var valid_580177 = query.getOrDefault("oauth_token")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "oauth_token", valid_580177
  var valid_580178 = query.getOrDefault("userIp")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "userIp", valid_580178
  var valid_580179 = query.getOrDefault("key")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "key", valid_580179
  var valid_580180 = query.getOrDefault("prettyPrint")
  valid_580180 = validateParameter(valid_580180, JBool, required = false,
                                 default = newJBool(true))
  if valid_580180 != nil:
    section.add "prettyPrint", valid_580180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580181: Call_AndroidpublisherEditsApklistingsDeleteall_580168;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all the APK-specific localized listings for a specified APK.
  ## 
  let valid = call_580181.validator(path, query, header, formData, body)
  let scheme = call_580181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580181.url(scheme.get, call_580181.host, call_580181.base,
                         call_580181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580181, url, valid)

proc call*(call_580182: Call_AndroidpublisherEditsApklistingsDeleteall_580168;
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
  var path_580183 = newJObject()
  var query_580184 = newJObject()
  add(query_580184, "fields", newJString(fields))
  add(path_580183, "packageName", newJString(packageName))
  add(query_580184, "quotaUser", newJString(quotaUser))
  add(query_580184, "alt", newJString(alt))
  add(path_580183, "editId", newJString(editId))
  add(query_580184, "oauth_token", newJString(oauthToken))
  add(query_580184, "userIp", newJString(userIp))
  add(query_580184, "key", newJString(key))
  add(query_580184, "prettyPrint", newJBool(prettyPrint))
  add(path_580183, "apkVersionCode", newJInt(apkVersionCode))
  result = call_580182.call(path_580183, query_580184, nil, nil, nil)

var androidpublisherEditsApklistingsDeleteall* = Call_AndroidpublisherEditsApklistingsDeleteall_580168(
    name: "androidpublisherEditsApklistingsDeleteall",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings",
    validator: validate_AndroidpublisherEditsApklistingsDeleteall_580169,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsDeleteall_580170,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsUpdate_580203 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsApklistingsUpdate_580205(protocol: Scheme;
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

proc validate_AndroidpublisherEditsApklistingsUpdate_580204(path: JsonNode;
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
  var valid_580206 = path.getOrDefault("packageName")
  valid_580206 = validateParameter(valid_580206, JString, required = true,
                                 default = nil)
  if valid_580206 != nil:
    section.add "packageName", valid_580206
  var valid_580207 = path.getOrDefault("editId")
  valid_580207 = validateParameter(valid_580207, JString, required = true,
                                 default = nil)
  if valid_580207 != nil:
    section.add "editId", valid_580207
  var valid_580208 = path.getOrDefault("language")
  valid_580208 = validateParameter(valid_580208, JString, required = true,
                                 default = nil)
  if valid_580208 != nil:
    section.add "language", valid_580208
  var valid_580209 = path.getOrDefault("apkVersionCode")
  valid_580209 = validateParameter(valid_580209, JInt, required = true, default = nil)
  if valid_580209 != nil:
    section.add "apkVersionCode", valid_580209
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
  var valid_580210 = query.getOrDefault("fields")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "fields", valid_580210
  var valid_580211 = query.getOrDefault("quotaUser")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "quotaUser", valid_580211
  var valid_580212 = query.getOrDefault("alt")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = newJString("json"))
  if valid_580212 != nil:
    section.add "alt", valid_580212
  var valid_580213 = query.getOrDefault("oauth_token")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "oauth_token", valid_580213
  var valid_580214 = query.getOrDefault("userIp")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "userIp", valid_580214
  var valid_580215 = query.getOrDefault("key")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "key", valid_580215
  var valid_580216 = query.getOrDefault("prettyPrint")
  valid_580216 = validateParameter(valid_580216, JBool, required = false,
                                 default = newJBool(true))
  if valid_580216 != nil:
    section.add "prettyPrint", valid_580216
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

proc call*(call_580218: Call_AndroidpublisherEditsApklistingsUpdate_580203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates or creates the APK-specific localized listing for a specified APK and language code.
  ## 
  let valid = call_580218.validator(path, query, header, formData, body)
  let scheme = call_580218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580218.url(scheme.get, call_580218.host, call_580218.base,
                         call_580218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580218, url, valid)

proc call*(call_580219: Call_AndroidpublisherEditsApklistingsUpdate_580203;
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
  var path_580220 = newJObject()
  var query_580221 = newJObject()
  var body_580222 = newJObject()
  add(query_580221, "fields", newJString(fields))
  add(path_580220, "packageName", newJString(packageName))
  add(query_580221, "quotaUser", newJString(quotaUser))
  add(query_580221, "alt", newJString(alt))
  add(path_580220, "editId", newJString(editId))
  add(query_580221, "oauth_token", newJString(oauthToken))
  add(path_580220, "language", newJString(language))
  add(query_580221, "userIp", newJString(userIp))
  add(query_580221, "key", newJString(key))
  if body != nil:
    body_580222 = body
  add(query_580221, "prettyPrint", newJBool(prettyPrint))
  add(path_580220, "apkVersionCode", newJInt(apkVersionCode))
  result = call_580219.call(path_580220, query_580221, nil, nil, body_580222)

var androidpublisherEditsApklistingsUpdate* = Call_AndroidpublisherEditsApklistingsUpdate_580203(
    name: "androidpublisherEditsApklistingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings/{language}",
    validator: validate_AndroidpublisherEditsApklistingsUpdate_580204,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsUpdate_580205,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsGet_580185 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsApklistingsGet_580187(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsApklistingsGet_580186(path: JsonNode;
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
  var valid_580188 = path.getOrDefault("packageName")
  valid_580188 = validateParameter(valid_580188, JString, required = true,
                                 default = nil)
  if valid_580188 != nil:
    section.add "packageName", valid_580188
  var valid_580189 = path.getOrDefault("editId")
  valid_580189 = validateParameter(valid_580189, JString, required = true,
                                 default = nil)
  if valid_580189 != nil:
    section.add "editId", valid_580189
  var valid_580190 = path.getOrDefault("language")
  valid_580190 = validateParameter(valid_580190, JString, required = true,
                                 default = nil)
  if valid_580190 != nil:
    section.add "language", valid_580190
  var valid_580191 = path.getOrDefault("apkVersionCode")
  valid_580191 = validateParameter(valid_580191, JInt, required = true, default = nil)
  if valid_580191 != nil:
    section.add "apkVersionCode", valid_580191
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
  var valid_580192 = query.getOrDefault("fields")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "fields", valid_580192
  var valid_580193 = query.getOrDefault("quotaUser")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "quotaUser", valid_580193
  var valid_580194 = query.getOrDefault("alt")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = newJString("json"))
  if valid_580194 != nil:
    section.add "alt", valid_580194
  var valid_580195 = query.getOrDefault("oauth_token")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "oauth_token", valid_580195
  var valid_580196 = query.getOrDefault("userIp")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "userIp", valid_580196
  var valid_580197 = query.getOrDefault("key")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "key", valid_580197
  var valid_580198 = query.getOrDefault("prettyPrint")
  valid_580198 = validateParameter(valid_580198, JBool, required = false,
                                 default = newJBool(true))
  if valid_580198 != nil:
    section.add "prettyPrint", valid_580198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580199: Call_AndroidpublisherEditsApklistingsGet_580185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the APK-specific localized listing for a specified APK and language code.
  ## 
  let valid = call_580199.validator(path, query, header, formData, body)
  let scheme = call_580199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580199.url(scheme.get, call_580199.host, call_580199.base,
                         call_580199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580199, url, valid)

proc call*(call_580200: Call_AndroidpublisherEditsApklistingsGet_580185;
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
  var path_580201 = newJObject()
  var query_580202 = newJObject()
  add(query_580202, "fields", newJString(fields))
  add(path_580201, "packageName", newJString(packageName))
  add(query_580202, "quotaUser", newJString(quotaUser))
  add(query_580202, "alt", newJString(alt))
  add(path_580201, "editId", newJString(editId))
  add(query_580202, "oauth_token", newJString(oauthToken))
  add(path_580201, "language", newJString(language))
  add(query_580202, "userIp", newJString(userIp))
  add(query_580202, "key", newJString(key))
  add(query_580202, "prettyPrint", newJBool(prettyPrint))
  add(path_580201, "apkVersionCode", newJInt(apkVersionCode))
  result = call_580200.call(path_580201, query_580202, nil, nil, nil)

var androidpublisherEditsApklistingsGet* = Call_AndroidpublisherEditsApklistingsGet_580185(
    name: "androidpublisherEditsApklistingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings/{language}",
    validator: validate_AndroidpublisherEditsApklistingsGet_580186,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsGet_580187, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsPatch_580241 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsApklistingsPatch_580243(protocol: Scheme;
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

proc validate_AndroidpublisherEditsApklistingsPatch_580242(path: JsonNode;
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
  var valid_580244 = path.getOrDefault("packageName")
  valid_580244 = validateParameter(valid_580244, JString, required = true,
                                 default = nil)
  if valid_580244 != nil:
    section.add "packageName", valid_580244
  var valid_580245 = path.getOrDefault("editId")
  valid_580245 = validateParameter(valid_580245, JString, required = true,
                                 default = nil)
  if valid_580245 != nil:
    section.add "editId", valid_580245
  var valid_580246 = path.getOrDefault("language")
  valid_580246 = validateParameter(valid_580246, JString, required = true,
                                 default = nil)
  if valid_580246 != nil:
    section.add "language", valid_580246
  var valid_580247 = path.getOrDefault("apkVersionCode")
  valid_580247 = validateParameter(valid_580247, JInt, required = true, default = nil)
  if valid_580247 != nil:
    section.add "apkVersionCode", valid_580247
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
  var valid_580248 = query.getOrDefault("fields")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "fields", valid_580248
  var valid_580249 = query.getOrDefault("quotaUser")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "quotaUser", valid_580249
  var valid_580250 = query.getOrDefault("alt")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = newJString("json"))
  if valid_580250 != nil:
    section.add "alt", valid_580250
  var valid_580251 = query.getOrDefault("oauth_token")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "oauth_token", valid_580251
  var valid_580252 = query.getOrDefault("userIp")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "userIp", valid_580252
  var valid_580253 = query.getOrDefault("key")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "key", valid_580253
  var valid_580254 = query.getOrDefault("prettyPrint")
  valid_580254 = validateParameter(valid_580254, JBool, required = false,
                                 default = newJBool(true))
  if valid_580254 != nil:
    section.add "prettyPrint", valid_580254
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

proc call*(call_580256: Call_AndroidpublisherEditsApklistingsPatch_580241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates or creates the APK-specific localized listing for a specified APK and language code. This method supports patch semantics.
  ## 
  let valid = call_580256.validator(path, query, header, formData, body)
  let scheme = call_580256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580256.url(scheme.get, call_580256.host, call_580256.base,
                         call_580256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580256, url, valid)

proc call*(call_580257: Call_AndroidpublisherEditsApklistingsPatch_580241;
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
  var path_580258 = newJObject()
  var query_580259 = newJObject()
  var body_580260 = newJObject()
  add(query_580259, "fields", newJString(fields))
  add(path_580258, "packageName", newJString(packageName))
  add(query_580259, "quotaUser", newJString(quotaUser))
  add(query_580259, "alt", newJString(alt))
  add(path_580258, "editId", newJString(editId))
  add(query_580259, "oauth_token", newJString(oauthToken))
  add(path_580258, "language", newJString(language))
  add(query_580259, "userIp", newJString(userIp))
  add(query_580259, "key", newJString(key))
  if body != nil:
    body_580260 = body
  add(query_580259, "prettyPrint", newJBool(prettyPrint))
  add(path_580258, "apkVersionCode", newJInt(apkVersionCode))
  result = call_580257.call(path_580258, query_580259, nil, nil, body_580260)

var androidpublisherEditsApklistingsPatch* = Call_AndroidpublisherEditsApklistingsPatch_580241(
    name: "androidpublisherEditsApklistingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings/{language}",
    validator: validate_AndroidpublisherEditsApklistingsPatch_580242,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsPatch_580243, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsDelete_580223 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsApklistingsDelete_580225(protocol: Scheme;
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

proc validate_AndroidpublisherEditsApklistingsDelete_580224(path: JsonNode;
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
  var valid_580226 = path.getOrDefault("packageName")
  valid_580226 = validateParameter(valid_580226, JString, required = true,
                                 default = nil)
  if valid_580226 != nil:
    section.add "packageName", valid_580226
  var valid_580227 = path.getOrDefault("editId")
  valid_580227 = validateParameter(valid_580227, JString, required = true,
                                 default = nil)
  if valid_580227 != nil:
    section.add "editId", valid_580227
  var valid_580228 = path.getOrDefault("language")
  valid_580228 = validateParameter(valid_580228, JString, required = true,
                                 default = nil)
  if valid_580228 != nil:
    section.add "language", valid_580228
  var valid_580229 = path.getOrDefault("apkVersionCode")
  valid_580229 = validateParameter(valid_580229, JInt, required = true, default = nil)
  if valid_580229 != nil:
    section.add "apkVersionCode", valid_580229
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
  var valid_580230 = query.getOrDefault("fields")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "fields", valid_580230
  var valid_580231 = query.getOrDefault("quotaUser")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "quotaUser", valid_580231
  var valid_580232 = query.getOrDefault("alt")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = newJString("json"))
  if valid_580232 != nil:
    section.add "alt", valid_580232
  var valid_580233 = query.getOrDefault("oauth_token")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "oauth_token", valid_580233
  var valid_580234 = query.getOrDefault("userIp")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "userIp", valid_580234
  var valid_580235 = query.getOrDefault("key")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "key", valid_580235
  var valid_580236 = query.getOrDefault("prettyPrint")
  valid_580236 = validateParameter(valid_580236, JBool, required = false,
                                 default = newJBool(true))
  if valid_580236 != nil:
    section.add "prettyPrint", valid_580236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580237: Call_AndroidpublisherEditsApklistingsDelete_580223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the APK-specific localized listing for a specified APK and language code.
  ## 
  let valid = call_580237.validator(path, query, header, formData, body)
  let scheme = call_580237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580237.url(scheme.get, call_580237.host, call_580237.base,
                         call_580237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580237, url, valid)

proc call*(call_580238: Call_AndroidpublisherEditsApklistingsDelete_580223;
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
  var path_580239 = newJObject()
  var query_580240 = newJObject()
  add(query_580240, "fields", newJString(fields))
  add(path_580239, "packageName", newJString(packageName))
  add(query_580240, "quotaUser", newJString(quotaUser))
  add(query_580240, "alt", newJString(alt))
  add(path_580239, "editId", newJString(editId))
  add(query_580240, "oauth_token", newJString(oauthToken))
  add(path_580239, "language", newJString(language))
  add(query_580240, "userIp", newJString(userIp))
  add(query_580240, "key", newJString(key))
  add(query_580240, "prettyPrint", newJBool(prettyPrint))
  add(path_580239, "apkVersionCode", newJInt(apkVersionCode))
  result = call_580238.call(path_580239, query_580240, nil, nil, nil)

var androidpublisherEditsApklistingsDelete* = Call_AndroidpublisherEditsApklistingsDelete_580223(
    name: "androidpublisherEditsApklistingsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings/{language}",
    validator: validate_AndroidpublisherEditsApklistingsDelete_580224,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsDelete_580225,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsBundlesUpload_580277 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsBundlesUpload_580279(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsBundlesUpload_580278(path: JsonNode;
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
  var valid_580280 = path.getOrDefault("packageName")
  valid_580280 = validateParameter(valid_580280, JString, required = true,
                                 default = nil)
  if valid_580280 != nil:
    section.add "packageName", valid_580280
  var valid_580281 = path.getOrDefault("editId")
  valid_580281 = validateParameter(valid_580281, JString, required = true,
                                 default = nil)
  if valid_580281 != nil:
    section.add "editId", valid_580281
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
  var valid_580282 = query.getOrDefault("fields")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "fields", valid_580282
  var valid_580283 = query.getOrDefault("quotaUser")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "quotaUser", valid_580283
  var valid_580284 = query.getOrDefault("alt")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = newJString("json"))
  if valid_580284 != nil:
    section.add "alt", valid_580284
  var valid_580285 = query.getOrDefault("oauth_token")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "oauth_token", valid_580285
  var valid_580286 = query.getOrDefault("userIp")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "userIp", valid_580286
  var valid_580287 = query.getOrDefault("key")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "key", valid_580287
  var valid_580288 = query.getOrDefault("prettyPrint")
  valid_580288 = validateParameter(valid_580288, JBool, required = false,
                                 default = newJBool(true))
  if valid_580288 != nil:
    section.add "prettyPrint", valid_580288
  var valid_580289 = query.getOrDefault("ackBundleInstallationWarning")
  valid_580289 = validateParameter(valid_580289, JBool, required = false, default = nil)
  if valid_580289 != nil:
    section.add "ackBundleInstallationWarning", valid_580289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580290: Call_AndroidpublisherEditsBundlesUpload_580277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a new Android App Bundle to this edit. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  let valid = call_580290.validator(path, query, header, formData, body)
  let scheme = call_580290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580290.url(scheme.get, call_580290.host, call_580290.base,
                         call_580290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580290, url, valid)

proc call*(call_580291: Call_AndroidpublisherEditsBundlesUpload_580277;
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
  var path_580292 = newJObject()
  var query_580293 = newJObject()
  add(query_580293, "fields", newJString(fields))
  add(path_580292, "packageName", newJString(packageName))
  add(query_580293, "quotaUser", newJString(quotaUser))
  add(query_580293, "alt", newJString(alt))
  add(path_580292, "editId", newJString(editId))
  add(query_580293, "oauth_token", newJString(oauthToken))
  add(query_580293, "userIp", newJString(userIp))
  add(query_580293, "key", newJString(key))
  add(query_580293, "prettyPrint", newJBool(prettyPrint))
  add(query_580293, "ackBundleInstallationWarning",
      newJBool(ackBundleInstallationWarning))
  result = call_580291.call(path_580292, query_580293, nil, nil, nil)

var androidpublisherEditsBundlesUpload* = Call_AndroidpublisherEditsBundlesUpload_580277(
    name: "androidpublisherEditsBundlesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/bundles",
    validator: validate_AndroidpublisherEditsBundlesUpload_580278,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsBundlesUpload_580279, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsBundlesList_580261 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsBundlesList_580263(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsBundlesList_580262(path: JsonNode;
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
  var valid_580264 = path.getOrDefault("packageName")
  valid_580264 = validateParameter(valid_580264, JString, required = true,
                                 default = nil)
  if valid_580264 != nil:
    section.add "packageName", valid_580264
  var valid_580265 = path.getOrDefault("editId")
  valid_580265 = validateParameter(valid_580265, JString, required = true,
                                 default = nil)
  if valid_580265 != nil:
    section.add "editId", valid_580265
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
  var valid_580266 = query.getOrDefault("fields")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "fields", valid_580266
  var valid_580267 = query.getOrDefault("quotaUser")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "quotaUser", valid_580267
  var valid_580268 = query.getOrDefault("alt")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = newJString("json"))
  if valid_580268 != nil:
    section.add "alt", valid_580268
  var valid_580269 = query.getOrDefault("oauth_token")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "oauth_token", valid_580269
  var valid_580270 = query.getOrDefault("userIp")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "userIp", valid_580270
  var valid_580271 = query.getOrDefault("key")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "key", valid_580271
  var valid_580272 = query.getOrDefault("prettyPrint")
  valid_580272 = validateParameter(valid_580272, JBool, required = false,
                                 default = newJBool(true))
  if valid_580272 != nil:
    section.add "prettyPrint", valid_580272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580273: Call_AndroidpublisherEditsBundlesList_580261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_580273.validator(path, query, header, formData, body)
  let scheme = call_580273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580273.url(scheme.get, call_580273.host, call_580273.base,
                         call_580273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580273, url, valid)

proc call*(call_580274: Call_AndroidpublisherEditsBundlesList_580261;
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
  var path_580275 = newJObject()
  var query_580276 = newJObject()
  add(query_580276, "fields", newJString(fields))
  add(path_580275, "packageName", newJString(packageName))
  add(query_580276, "quotaUser", newJString(quotaUser))
  add(query_580276, "alt", newJString(alt))
  add(path_580275, "editId", newJString(editId))
  add(query_580276, "oauth_token", newJString(oauthToken))
  add(query_580276, "userIp", newJString(userIp))
  add(query_580276, "key", newJString(key))
  add(query_580276, "prettyPrint", newJBool(prettyPrint))
  result = call_580274.call(path_580275, query_580276, nil, nil, nil)

var androidpublisherEditsBundlesList* = Call_AndroidpublisherEditsBundlesList_580261(
    name: "androidpublisherEditsBundlesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/bundles",
    validator: validate_AndroidpublisherEditsBundlesList_580262,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsBundlesList_580263, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsUpdate_580310 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsDetailsUpdate_580312(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsDetailsUpdate_580311(path: JsonNode;
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
  var valid_580313 = path.getOrDefault("packageName")
  valid_580313 = validateParameter(valid_580313, JString, required = true,
                                 default = nil)
  if valid_580313 != nil:
    section.add "packageName", valid_580313
  var valid_580314 = path.getOrDefault("editId")
  valid_580314 = validateParameter(valid_580314, JString, required = true,
                                 default = nil)
  if valid_580314 != nil:
    section.add "editId", valid_580314
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
  var valid_580315 = query.getOrDefault("fields")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "fields", valid_580315
  var valid_580316 = query.getOrDefault("quotaUser")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "quotaUser", valid_580316
  var valid_580317 = query.getOrDefault("alt")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = newJString("json"))
  if valid_580317 != nil:
    section.add "alt", valid_580317
  var valid_580318 = query.getOrDefault("oauth_token")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "oauth_token", valid_580318
  var valid_580319 = query.getOrDefault("userIp")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "userIp", valid_580319
  var valid_580320 = query.getOrDefault("key")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "key", valid_580320
  var valid_580321 = query.getOrDefault("prettyPrint")
  valid_580321 = validateParameter(valid_580321, JBool, required = false,
                                 default = newJBool(true))
  if valid_580321 != nil:
    section.add "prettyPrint", valid_580321
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

proc call*(call_580323: Call_AndroidpublisherEditsDetailsUpdate_580310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates app details for this edit.
  ## 
  let valid = call_580323.validator(path, query, header, formData, body)
  let scheme = call_580323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580323.url(scheme.get, call_580323.host, call_580323.base,
                         call_580323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580323, url, valid)

proc call*(call_580324: Call_AndroidpublisherEditsDetailsUpdate_580310;
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
  var path_580325 = newJObject()
  var query_580326 = newJObject()
  var body_580327 = newJObject()
  add(query_580326, "fields", newJString(fields))
  add(path_580325, "packageName", newJString(packageName))
  add(query_580326, "quotaUser", newJString(quotaUser))
  add(query_580326, "alt", newJString(alt))
  add(path_580325, "editId", newJString(editId))
  add(query_580326, "oauth_token", newJString(oauthToken))
  add(query_580326, "userIp", newJString(userIp))
  add(query_580326, "key", newJString(key))
  if body != nil:
    body_580327 = body
  add(query_580326, "prettyPrint", newJBool(prettyPrint))
  result = call_580324.call(path_580325, query_580326, nil, nil, body_580327)

var androidpublisherEditsDetailsUpdate* = Call_AndroidpublisherEditsDetailsUpdate_580310(
    name: "androidpublisherEditsDetailsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsUpdate_580311,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDetailsUpdate_580312, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsGet_580294 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsDetailsGet_580296(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsDetailsGet_580295(path: JsonNode;
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
  var valid_580297 = path.getOrDefault("packageName")
  valid_580297 = validateParameter(valid_580297, JString, required = true,
                                 default = nil)
  if valid_580297 != nil:
    section.add "packageName", valid_580297
  var valid_580298 = path.getOrDefault("editId")
  valid_580298 = validateParameter(valid_580298, JString, required = true,
                                 default = nil)
  if valid_580298 != nil:
    section.add "editId", valid_580298
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
  var valid_580299 = query.getOrDefault("fields")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "fields", valid_580299
  var valid_580300 = query.getOrDefault("quotaUser")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "quotaUser", valid_580300
  var valid_580301 = query.getOrDefault("alt")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = newJString("json"))
  if valid_580301 != nil:
    section.add "alt", valid_580301
  var valid_580302 = query.getOrDefault("oauth_token")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "oauth_token", valid_580302
  var valid_580303 = query.getOrDefault("userIp")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "userIp", valid_580303
  var valid_580304 = query.getOrDefault("key")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "key", valid_580304
  var valid_580305 = query.getOrDefault("prettyPrint")
  valid_580305 = validateParameter(valid_580305, JBool, required = false,
                                 default = newJBool(true))
  if valid_580305 != nil:
    section.add "prettyPrint", valid_580305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580306: Call_AndroidpublisherEditsDetailsGet_580294;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches app details for this edit. This includes the default language and developer support contact information.
  ## 
  let valid = call_580306.validator(path, query, header, formData, body)
  let scheme = call_580306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580306.url(scheme.get, call_580306.host, call_580306.base,
                         call_580306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580306, url, valid)

proc call*(call_580307: Call_AndroidpublisherEditsDetailsGet_580294;
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
  var path_580308 = newJObject()
  var query_580309 = newJObject()
  add(query_580309, "fields", newJString(fields))
  add(path_580308, "packageName", newJString(packageName))
  add(query_580309, "quotaUser", newJString(quotaUser))
  add(query_580309, "alt", newJString(alt))
  add(path_580308, "editId", newJString(editId))
  add(query_580309, "oauth_token", newJString(oauthToken))
  add(query_580309, "userIp", newJString(userIp))
  add(query_580309, "key", newJString(key))
  add(query_580309, "prettyPrint", newJBool(prettyPrint))
  result = call_580307.call(path_580308, query_580309, nil, nil, nil)

var androidpublisherEditsDetailsGet* = Call_AndroidpublisherEditsDetailsGet_580294(
    name: "androidpublisherEditsDetailsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsGet_580295,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDetailsGet_580296, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsPatch_580328 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsDetailsPatch_580330(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsDetailsPatch_580329(path: JsonNode;
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
  var valid_580331 = path.getOrDefault("packageName")
  valid_580331 = validateParameter(valid_580331, JString, required = true,
                                 default = nil)
  if valid_580331 != nil:
    section.add "packageName", valid_580331
  var valid_580332 = path.getOrDefault("editId")
  valid_580332 = validateParameter(valid_580332, JString, required = true,
                                 default = nil)
  if valid_580332 != nil:
    section.add "editId", valid_580332
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
  var valid_580333 = query.getOrDefault("fields")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "fields", valid_580333
  var valid_580334 = query.getOrDefault("quotaUser")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "quotaUser", valid_580334
  var valid_580335 = query.getOrDefault("alt")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = newJString("json"))
  if valid_580335 != nil:
    section.add "alt", valid_580335
  var valid_580336 = query.getOrDefault("oauth_token")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "oauth_token", valid_580336
  var valid_580337 = query.getOrDefault("userIp")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "userIp", valid_580337
  var valid_580338 = query.getOrDefault("key")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "key", valid_580338
  var valid_580339 = query.getOrDefault("prettyPrint")
  valid_580339 = validateParameter(valid_580339, JBool, required = false,
                                 default = newJBool(true))
  if valid_580339 != nil:
    section.add "prettyPrint", valid_580339
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

proc call*(call_580341: Call_AndroidpublisherEditsDetailsPatch_580328;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates app details for this edit. This method supports patch semantics.
  ## 
  let valid = call_580341.validator(path, query, header, formData, body)
  let scheme = call_580341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580341.url(scheme.get, call_580341.host, call_580341.base,
                         call_580341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580341, url, valid)

proc call*(call_580342: Call_AndroidpublisherEditsDetailsPatch_580328;
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
  var path_580343 = newJObject()
  var query_580344 = newJObject()
  var body_580345 = newJObject()
  add(query_580344, "fields", newJString(fields))
  add(path_580343, "packageName", newJString(packageName))
  add(query_580344, "quotaUser", newJString(quotaUser))
  add(query_580344, "alt", newJString(alt))
  add(path_580343, "editId", newJString(editId))
  add(query_580344, "oauth_token", newJString(oauthToken))
  add(query_580344, "userIp", newJString(userIp))
  add(query_580344, "key", newJString(key))
  if body != nil:
    body_580345 = body
  add(query_580344, "prettyPrint", newJBool(prettyPrint))
  result = call_580342.call(path_580343, query_580344, nil, nil, body_580345)

var androidpublisherEditsDetailsPatch* = Call_AndroidpublisherEditsDetailsPatch_580328(
    name: "androidpublisherEditsDetailsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsPatch_580329,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDetailsPatch_580330, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsList_580346 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsListingsList_580348(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsList_580347(path: JsonNode;
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
  var valid_580349 = path.getOrDefault("packageName")
  valid_580349 = validateParameter(valid_580349, JString, required = true,
                                 default = nil)
  if valid_580349 != nil:
    section.add "packageName", valid_580349
  var valid_580350 = path.getOrDefault("editId")
  valid_580350 = validateParameter(valid_580350, JString, required = true,
                                 default = nil)
  if valid_580350 != nil:
    section.add "editId", valid_580350
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
  var valid_580351 = query.getOrDefault("fields")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "fields", valid_580351
  var valid_580352 = query.getOrDefault("quotaUser")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "quotaUser", valid_580352
  var valid_580353 = query.getOrDefault("alt")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = newJString("json"))
  if valid_580353 != nil:
    section.add "alt", valid_580353
  var valid_580354 = query.getOrDefault("oauth_token")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "oauth_token", valid_580354
  var valid_580355 = query.getOrDefault("userIp")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "userIp", valid_580355
  var valid_580356 = query.getOrDefault("key")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "key", valid_580356
  var valid_580357 = query.getOrDefault("prettyPrint")
  valid_580357 = validateParameter(valid_580357, JBool, required = false,
                                 default = newJBool(true))
  if valid_580357 != nil:
    section.add "prettyPrint", valid_580357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580358: Call_AndroidpublisherEditsListingsList_580346;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all of the localized store listings attached to this edit.
  ## 
  let valid = call_580358.validator(path, query, header, formData, body)
  let scheme = call_580358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580358.url(scheme.get, call_580358.host, call_580358.base,
                         call_580358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580358, url, valid)

proc call*(call_580359: Call_AndroidpublisherEditsListingsList_580346;
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
  var path_580360 = newJObject()
  var query_580361 = newJObject()
  add(query_580361, "fields", newJString(fields))
  add(path_580360, "packageName", newJString(packageName))
  add(query_580361, "quotaUser", newJString(quotaUser))
  add(query_580361, "alt", newJString(alt))
  add(path_580360, "editId", newJString(editId))
  add(query_580361, "oauth_token", newJString(oauthToken))
  add(query_580361, "userIp", newJString(userIp))
  add(query_580361, "key", newJString(key))
  add(query_580361, "prettyPrint", newJBool(prettyPrint))
  result = call_580359.call(path_580360, query_580361, nil, nil, nil)

var androidpublisherEditsListingsList* = Call_AndroidpublisherEditsListingsList_580346(
    name: "androidpublisherEditsListingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings",
    validator: validate_AndroidpublisherEditsListingsList_580347,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsList_580348, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsDeleteall_580362 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsListingsDeleteall_580364(protocol: Scheme;
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

proc validate_AndroidpublisherEditsListingsDeleteall_580363(path: JsonNode;
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
  var valid_580365 = path.getOrDefault("packageName")
  valid_580365 = validateParameter(valid_580365, JString, required = true,
                                 default = nil)
  if valid_580365 != nil:
    section.add "packageName", valid_580365
  var valid_580366 = path.getOrDefault("editId")
  valid_580366 = validateParameter(valid_580366, JString, required = true,
                                 default = nil)
  if valid_580366 != nil:
    section.add "editId", valid_580366
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
  var valid_580367 = query.getOrDefault("fields")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "fields", valid_580367
  var valid_580368 = query.getOrDefault("quotaUser")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "quotaUser", valid_580368
  var valid_580369 = query.getOrDefault("alt")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = newJString("json"))
  if valid_580369 != nil:
    section.add "alt", valid_580369
  var valid_580370 = query.getOrDefault("oauth_token")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "oauth_token", valid_580370
  var valid_580371 = query.getOrDefault("userIp")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "userIp", valid_580371
  var valid_580372 = query.getOrDefault("key")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "key", valid_580372
  var valid_580373 = query.getOrDefault("prettyPrint")
  valid_580373 = validateParameter(valid_580373, JBool, required = false,
                                 default = newJBool(true))
  if valid_580373 != nil:
    section.add "prettyPrint", valid_580373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580374: Call_AndroidpublisherEditsListingsDeleteall_580362;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all localized listings from an edit.
  ## 
  let valid = call_580374.validator(path, query, header, formData, body)
  let scheme = call_580374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580374.url(scheme.get, call_580374.host, call_580374.base,
                         call_580374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580374, url, valid)

proc call*(call_580375: Call_AndroidpublisherEditsListingsDeleteall_580362;
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
  var path_580376 = newJObject()
  var query_580377 = newJObject()
  add(query_580377, "fields", newJString(fields))
  add(path_580376, "packageName", newJString(packageName))
  add(query_580377, "quotaUser", newJString(quotaUser))
  add(query_580377, "alt", newJString(alt))
  add(path_580376, "editId", newJString(editId))
  add(query_580377, "oauth_token", newJString(oauthToken))
  add(query_580377, "userIp", newJString(userIp))
  add(query_580377, "key", newJString(key))
  add(query_580377, "prettyPrint", newJBool(prettyPrint))
  result = call_580375.call(path_580376, query_580377, nil, nil, nil)

var androidpublisherEditsListingsDeleteall* = Call_AndroidpublisherEditsListingsDeleteall_580362(
    name: "androidpublisherEditsListingsDeleteall", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings",
    validator: validate_AndroidpublisherEditsListingsDeleteall_580363,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsDeleteall_580364,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsUpdate_580395 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsListingsUpdate_580397(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsUpdate_580396(path: JsonNode;
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
  var valid_580398 = path.getOrDefault("packageName")
  valid_580398 = validateParameter(valid_580398, JString, required = true,
                                 default = nil)
  if valid_580398 != nil:
    section.add "packageName", valid_580398
  var valid_580399 = path.getOrDefault("editId")
  valid_580399 = validateParameter(valid_580399, JString, required = true,
                                 default = nil)
  if valid_580399 != nil:
    section.add "editId", valid_580399
  var valid_580400 = path.getOrDefault("language")
  valid_580400 = validateParameter(valid_580400, JString, required = true,
                                 default = nil)
  if valid_580400 != nil:
    section.add "language", valid_580400
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
  var valid_580401 = query.getOrDefault("fields")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "fields", valid_580401
  var valid_580402 = query.getOrDefault("quotaUser")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "quotaUser", valid_580402
  var valid_580403 = query.getOrDefault("alt")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = newJString("json"))
  if valid_580403 != nil:
    section.add "alt", valid_580403
  var valid_580404 = query.getOrDefault("oauth_token")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "oauth_token", valid_580404
  var valid_580405 = query.getOrDefault("userIp")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "userIp", valid_580405
  var valid_580406 = query.getOrDefault("key")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "key", valid_580406
  var valid_580407 = query.getOrDefault("prettyPrint")
  valid_580407 = validateParameter(valid_580407, JBool, required = false,
                                 default = newJBool(true))
  if valid_580407 != nil:
    section.add "prettyPrint", valid_580407
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

proc call*(call_580409: Call_AndroidpublisherEditsListingsUpdate_580395;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a localized store listing.
  ## 
  let valid = call_580409.validator(path, query, header, formData, body)
  let scheme = call_580409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580409.url(scheme.get, call_580409.host, call_580409.base,
                         call_580409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580409, url, valid)

proc call*(call_580410: Call_AndroidpublisherEditsListingsUpdate_580395;
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
  var path_580411 = newJObject()
  var query_580412 = newJObject()
  var body_580413 = newJObject()
  add(query_580412, "fields", newJString(fields))
  add(path_580411, "packageName", newJString(packageName))
  add(query_580412, "quotaUser", newJString(quotaUser))
  add(query_580412, "alt", newJString(alt))
  add(path_580411, "editId", newJString(editId))
  add(query_580412, "oauth_token", newJString(oauthToken))
  add(path_580411, "language", newJString(language))
  add(query_580412, "userIp", newJString(userIp))
  add(query_580412, "key", newJString(key))
  if body != nil:
    body_580413 = body
  add(query_580412, "prettyPrint", newJBool(prettyPrint))
  result = call_580410.call(path_580411, query_580412, nil, nil, body_580413)

var androidpublisherEditsListingsUpdate* = Call_AndroidpublisherEditsListingsUpdate_580395(
    name: "androidpublisherEditsListingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsUpdate_580396,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsUpdate_580397, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsGet_580378 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsListingsGet_580380(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsGet_580379(path: JsonNode;
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
  var valid_580381 = path.getOrDefault("packageName")
  valid_580381 = validateParameter(valid_580381, JString, required = true,
                                 default = nil)
  if valid_580381 != nil:
    section.add "packageName", valid_580381
  var valid_580382 = path.getOrDefault("editId")
  valid_580382 = validateParameter(valid_580382, JString, required = true,
                                 default = nil)
  if valid_580382 != nil:
    section.add "editId", valid_580382
  var valid_580383 = path.getOrDefault("language")
  valid_580383 = validateParameter(valid_580383, JString, required = true,
                                 default = nil)
  if valid_580383 != nil:
    section.add "language", valid_580383
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
  var valid_580384 = query.getOrDefault("fields")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "fields", valid_580384
  var valid_580385 = query.getOrDefault("quotaUser")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "quotaUser", valid_580385
  var valid_580386 = query.getOrDefault("alt")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = newJString("json"))
  if valid_580386 != nil:
    section.add "alt", valid_580386
  var valid_580387 = query.getOrDefault("oauth_token")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "oauth_token", valid_580387
  var valid_580388 = query.getOrDefault("userIp")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "userIp", valid_580388
  var valid_580389 = query.getOrDefault("key")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "key", valid_580389
  var valid_580390 = query.getOrDefault("prettyPrint")
  valid_580390 = validateParameter(valid_580390, JBool, required = false,
                                 default = newJBool(true))
  if valid_580390 != nil:
    section.add "prettyPrint", valid_580390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580391: Call_AndroidpublisherEditsListingsGet_580378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches information about a localized store listing.
  ## 
  let valid = call_580391.validator(path, query, header, formData, body)
  let scheme = call_580391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580391.url(scheme.get, call_580391.host, call_580391.base,
                         call_580391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580391, url, valid)

proc call*(call_580392: Call_AndroidpublisherEditsListingsGet_580378;
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
  var path_580393 = newJObject()
  var query_580394 = newJObject()
  add(query_580394, "fields", newJString(fields))
  add(path_580393, "packageName", newJString(packageName))
  add(query_580394, "quotaUser", newJString(quotaUser))
  add(query_580394, "alt", newJString(alt))
  add(path_580393, "editId", newJString(editId))
  add(query_580394, "oauth_token", newJString(oauthToken))
  add(path_580393, "language", newJString(language))
  add(query_580394, "userIp", newJString(userIp))
  add(query_580394, "key", newJString(key))
  add(query_580394, "prettyPrint", newJBool(prettyPrint))
  result = call_580392.call(path_580393, query_580394, nil, nil, nil)

var androidpublisherEditsListingsGet* = Call_AndroidpublisherEditsListingsGet_580378(
    name: "androidpublisherEditsListingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsGet_580379,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsGet_580380, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsPatch_580431 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsListingsPatch_580433(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsPatch_580432(path: JsonNode;
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
  var valid_580434 = path.getOrDefault("packageName")
  valid_580434 = validateParameter(valid_580434, JString, required = true,
                                 default = nil)
  if valid_580434 != nil:
    section.add "packageName", valid_580434
  var valid_580435 = path.getOrDefault("editId")
  valid_580435 = validateParameter(valid_580435, JString, required = true,
                                 default = nil)
  if valid_580435 != nil:
    section.add "editId", valid_580435
  var valid_580436 = path.getOrDefault("language")
  valid_580436 = validateParameter(valid_580436, JString, required = true,
                                 default = nil)
  if valid_580436 != nil:
    section.add "language", valid_580436
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
  var valid_580437 = query.getOrDefault("fields")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "fields", valid_580437
  var valid_580438 = query.getOrDefault("quotaUser")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "quotaUser", valid_580438
  var valid_580439 = query.getOrDefault("alt")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = newJString("json"))
  if valid_580439 != nil:
    section.add "alt", valid_580439
  var valid_580440 = query.getOrDefault("oauth_token")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "oauth_token", valid_580440
  var valid_580441 = query.getOrDefault("userIp")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = nil)
  if valid_580441 != nil:
    section.add "userIp", valid_580441
  var valid_580442 = query.getOrDefault("key")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "key", valid_580442
  var valid_580443 = query.getOrDefault("prettyPrint")
  valid_580443 = validateParameter(valid_580443, JBool, required = false,
                                 default = newJBool(true))
  if valid_580443 != nil:
    section.add "prettyPrint", valid_580443
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

proc call*(call_580445: Call_AndroidpublisherEditsListingsPatch_580431;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a localized store listing. This method supports patch semantics.
  ## 
  let valid = call_580445.validator(path, query, header, formData, body)
  let scheme = call_580445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580445.url(scheme.get, call_580445.host, call_580445.base,
                         call_580445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580445, url, valid)

proc call*(call_580446: Call_AndroidpublisherEditsListingsPatch_580431;
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
  var path_580447 = newJObject()
  var query_580448 = newJObject()
  var body_580449 = newJObject()
  add(query_580448, "fields", newJString(fields))
  add(path_580447, "packageName", newJString(packageName))
  add(query_580448, "quotaUser", newJString(quotaUser))
  add(query_580448, "alt", newJString(alt))
  add(path_580447, "editId", newJString(editId))
  add(query_580448, "oauth_token", newJString(oauthToken))
  add(path_580447, "language", newJString(language))
  add(query_580448, "userIp", newJString(userIp))
  add(query_580448, "key", newJString(key))
  if body != nil:
    body_580449 = body
  add(query_580448, "prettyPrint", newJBool(prettyPrint))
  result = call_580446.call(path_580447, query_580448, nil, nil, body_580449)

var androidpublisherEditsListingsPatch* = Call_AndroidpublisherEditsListingsPatch_580431(
    name: "androidpublisherEditsListingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsPatch_580432,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsPatch_580433, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsDelete_580414 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsListingsDelete_580416(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsDelete_580415(path: JsonNode;
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
  var valid_580417 = path.getOrDefault("packageName")
  valid_580417 = validateParameter(valid_580417, JString, required = true,
                                 default = nil)
  if valid_580417 != nil:
    section.add "packageName", valid_580417
  var valid_580418 = path.getOrDefault("editId")
  valid_580418 = validateParameter(valid_580418, JString, required = true,
                                 default = nil)
  if valid_580418 != nil:
    section.add "editId", valid_580418
  var valid_580419 = path.getOrDefault("language")
  valid_580419 = validateParameter(valid_580419, JString, required = true,
                                 default = nil)
  if valid_580419 != nil:
    section.add "language", valid_580419
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
  var valid_580420 = query.getOrDefault("fields")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "fields", valid_580420
  var valid_580421 = query.getOrDefault("quotaUser")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "quotaUser", valid_580421
  var valid_580422 = query.getOrDefault("alt")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = newJString("json"))
  if valid_580422 != nil:
    section.add "alt", valid_580422
  var valid_580423 = query.getOrDefault("oauth_token")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "oauth_token", valid_580423
  var valid_580424 = query.getOrDefault("userIp")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "userIp", valid_580424
  var valid_580425 = query.getOrDefault("key")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "key", valid_580425
  var valid_580426 = query.getOrDefault("prettyPrint")
  valid_580426 = validateParameter(valid_580426, JBool, required = false,
                                 default = newJBool(true))
  if valid_580426 != nil:
    section.add "prettyPrint", valid_580426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580427: Call_AndroidpublisherEditsListingsDelete_580414;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified localized store listing from an edit.
  ## 
  let valid = call_580427.validator(path, query, header, formData, body)
  let scheme = call_580427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580427.url(scheme.get, call_580427.host, call_580427.base,
                         call_580427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580427, url, valid)

proc call*(call_580428: Call_AndroidpublisherEditsListingsDelete_580414;
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
  var path_580429 = newJObject()
  var query_580430 = newJObject()
  add(query_580430, "fields", newJString(fields))
  add(path_580429, "packageName", newJString(packageName))
  add(query_580430, "quotaUser", newJString(quotaUser))
  add(query_580430, "alt", newJString(alt))
  add(path_580429, "editId", newJString(editId))
  add(query_580430, "oauth_token", newJString(oauthToken))
  add(path_580429, "language", newJString(language))
  add(query_580430, "userIp", newJString(userIp))
  add(query_580430, "key", newJString(key))
  add(query_580430, "prettyPrint", newJBool(prettyPrint))
  result = call_580428.call(path_580429, query_580430, nil, nil, nil)

var androidpublisherEditsListingsDelete* = Call_AndroidpublisherEditsListingsDelete_580414(
    name: "androidpublisherEditsListingsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsDelete_580415,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsDelete_580416, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesUpload_580468 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsImagesUpload_580470(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsImagesUpload_580469(path: JsonNode;
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
  var valid_580471 = path.getOrDefault("packageName")
  valid_580471 = validateParameter(valid_580471, JString, required = true,
                                 default = nil)
  if valid_580471 != nil:
    section.add "packageName", valid_580471
  var valid_580472 = path.getOrDefault("editId")
  valid_580472 = validateParameter(valid_580472, JString, required = true,
                                 default = nil)
  if valid_580472 != nil:
    section.add "editId", valid_580472
  var valid_580473 = path.getOrDefault("language")
  valid_580473 = validateParameter(valid_580473, JString, required = true,
                                 default = nil)
  if valid_580473 != nil:
    section.add "language", valid_580473
  var valid_580474 = path.getOrDefault("imageType")
  valid_580474 = validateParameter(valid_580474, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_580474 != nil:
    section.add "imageType", valid_580474
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
  var valid_580475 = query.getOrDefault("fields")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "fields", valid_580475
  var valid_580476 = query.getOrDefault("quotaUser")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = nil)
  if valid_580476 != nil:
    section.add "quotaUser", valid_580476
  var valid_580477 = query.getOrDefault("alt")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = newJString("json"))
  if valid_580477 != nil:
    section.add "alt", valid_580477
  var valid_580478 = query.getOrDefault("oauth_token")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "oauth_token", valid_580478
  var valid_580479 = query.getOrDefault("userIp")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = nil)
  if valid_580479 != nil:
    section.add "userIp", valid_580479
  var valid_580480 = query.getOrDefault("key")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "key", valid_580480
  var valid_580481 = query.getOrDefault("prettyPrint")
  valid_580481 = validateParameter(valid_580481, JBool, required = false,
                                 default = newJBool(true))
  if valid_580481 != nil:
    section.add "prettyPrint", valid_580481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580482: Call_AndroidpublisherEditsImagesUpload_580468;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a new image and adds it to the list of images for the specified language and image type.
  ## 
  let valid = call_580482.validator(path, query, header, formData, body)
  let scheme = call_580482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580482.url(scheme.get, call_580482.host, call_580482.base,
                         call_580482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580482, url, valid)

proc call*(call_580483: Call_AndroidpublisherEditsImagesUpload_580468;
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
  var path_580484 = newJObject()
  var query_580485 = newJObject()
  add(query_580485, "fields", newJString(fields))
  add(path_580484, "packageName", newJString(packageName))
  add(query_580485, "quotaUser", newJString(quotaUser))
  add(query_580485, "alt", newJString(alt))
  add(path_580484, "editId", newJString(editId))
  add(query_580485, "oauth_token", newJString(oauthToken))
  add(path_580484, "language", newJString(language))
  add(query_580485, "userIp", newJString(userIp))
  add(path_580484, "imageType", newJString(imageType))
  add(query_580485, "key", newJString(key))
  add(query_580485, "prettyPrint", newJBool(prettyPrint))
  result = call_580483.call(path_580484, query_580485, nil, nil, nil)

var androidpublisherEditsImagesUpload* = Call_AndroidpublisherEditsImagesUpload_580468(
    name: "androidpublisherEditsImagesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesUpload_580469,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsImagesUpload_580470, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesList_580450 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsImagesList_580452(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsImagesList_580451(path: JsonNode;
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
  var valid_580453 = path.getOrDefault("packageName")
  valid_580453 = validateParameter(valid_580453, JString, required = true,
                                 default = nil)
  if valid_580453 != nil:
    section.add "packageName", valid_580453
  var valid_580454 = path.getOrDefault("editId")
  valid_580454 = validateParameter(valid_580454, JString, required = true,
                                 default = nil)
  if valid_580454 != nil:
    section.add "editId", valid_580454
  var valid_580455 = path.getOrDefault("language")
  valid_580455 = validateParameter(valid_580455, JString, required = true,
                                 default = nil)
  if valid_580455 != nil:
    section.add "language", valid_580455
  var valid_580456 = path.getOrDefault("imageType")
  valid_580456 = validateParameter(valid_580456, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_580456 != nil:
    section.add "imageType", valid_580456
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
  var valid_580457 = query.getOrDefault("fields")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = nil)
  if valid_580457 != nil:
    section.add "fields", valid_580457
  var valid_580458 = query.getOrDefault("quotaUser")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = nil)
  if valid_580458 != nil:
    section.add "quotaUser", valid_580458
  var valid_580459 = query.getOrDefault("alt")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = newJString("json"))
  if valid_580459 != nil:
    section.add "alt", valid_580459
  var valid_580460 = query.getOrDefault("oauth_token")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = nil)
  if valid_580460 != nil:
    section.add "oauth_token", valid_580460
  var valid_580461 = query.getOrDefault("userIp")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "userIp", valid_580461
  var valid_580462 = query.getOrDefault("key")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "key", valid_580462
  var valid_580463 = query.getOrDefault("prettyPrint")
  valid_580463 = validateParameter(valid_580463, JBool, required = false,
                                 default = newJBool(true))
  if valid_580463 != nil:
    section.add "prettyPrint", valid_580463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580464: Call_AndroidpublisherEditsImagesList_580450;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all images for the specified language and image type.
  ## 
  let valid = call_580464.validator(path, query, header, formData, body)
  let scheme = call_580464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580464.url(scheme.get, call_580464.host, call_580464.base,
                         call_580464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580464, url, valid)

proc call*(call_580465: Call_AndroidpublisherEditsImagesList_580450;
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
  var path_580466 = newJObject()
  var query_580467 = newJObject()
  add(query_580467, "fields", newJString(fields))
  add(path_580466, "packageName", newJString(packageName))
  add(query_580467, "quotaUser", newJString(quotaUser))
  add(query_580467, "alt", newJString(alt))
  add(path_580466, "editId", newJString(editId))
  add(query_580467, "oauth_token", newJString(oauthToken))
  add(path_580466, "language", newJString(language))
  add(query_580467, "userIp", newJString(userIp))
  add(path_580466, "imageType", newJString(imageType))
  add(query_580467, "key", newJString(key))
  add(query_580467, "prettyPrint", newJBool(prettyPrint))
  result = call_580465.call(path_580466, query_580467, nil, nil, nil)

var androidpublisherEditsImagesList* = Call_AndroidpublisherEditsImagesList_580450(
    name: "androidpublisherEditsImagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesList_580451,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsImagesList_580452, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesDeleteall_580486 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsImagesDeleteall_580488(protocol: Scheme;
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

proc validate_AndroidpublisherEditsImagesDeleteall_580487(path: JsonNode;
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
  var valid_580489 = path.getOrDefault("packageName")
  valid_580489 = validateParameter(valid_580489, JString, required = true,
                                 default = nil)
  if valid_580489 != nil:
    section.add "packageName", valid_580489
  var valid_580490 = path.getOrDefault("editId")
  valid_580490 = validateParameter(valid_580490, JString, required = true,
                                 default = nil)
  if valid_580490 != nil:
    section.add "editId", valid_580490
  var valid_580491 = path.getOrDefault("language")
  valid_580491 = validateParameter(valid_580491, JString, required = true,
                                 default = nil)
  if valid_580491 != nil:
    section.add "language", valid_580491
  var valid_580492 = path.getOrDefault("imageType")
  valid_580492 = validateParameter(valid_580492, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_580492 != nil:
    section.add "imageType", valid_580492
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
  var valid_580493 = query.getOrDefault("fields")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = nil)
  if valid_580493 != nil:
    section.add "fields", valid_580493
  var valid_580494 = query.getOrDefault("quotaUser")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "quotaUser", valid_580494
  var valid_580495 = query.getOrDefault("alt")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = newJString("json"))
  if valid_580495 != nil:
    section.add "alt", valid_580495
  var valid_580496 = query.getOrDefault("oauth_token")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = nil)
  if valid_580496 != nil:
    section.add "oauth_token", valid_580496
  var valid_580497 = query.getOrDefault("userIp")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "userIp", valid_580497
  var valid_580498 = query.getOrDefault("key")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "key", valid_580498
  var valid_580499 = query.getOrDefault("prettyPrint")
  valid_580499 = validateParameter(valid_580499, JBool, required = false,
                                 default = newJBool(true))
  if valid_580499 != nil:
    section.add "prettyPrint", valid_580499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580500: Call_AndroidpublisherEditsImagesDeleteall_580486;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all images for the specified language and image type.
  ## 
  let valid = call_580500.validator(path, query, header, formData, body)
  let scheme = call_580500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580500.url(scheme.get, call_580500.host, call_580500.base,
                         call_580500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580500, url, valid)

proc call*(call_580501: Call_AndroidpublisherEditsImagesDeleteall_580486;
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
  var path_580502 = newJObject()
  var query_580503 = newJObject()
  add(query_580503, "fields", newJString(fields))
  add(path_580502, "packageName", newJString(packageName))
  add(query_580503, "quotaUser", newJString(quotaUser))
  add(query_580503, "alt", newJString(alt))
  add(path_580502, "editId", newJString(editId))
  add(query_580503, "oauth_token", newJString(oauthToken))
  add(path_580502, "language", newJString(language))
  add(query_580503, "userIp", newJString(userIp))
  add(path_580502, "imageType", newJString(imageType))
  add(query_580503, "key", newJString(key))
  add(query_580503, "prettyPrint", newJBool(prettyPrint))
  result = call_580501.call(path_580502, query_580503, nil, nil, nil)

var androidpublisherEditsImagesDeleteall* = Call_AndroidpublisherEditsImagesDeleteall_580486(
    name: "androidpublisherEditsImagesDeleteall", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesDeleteall_580487,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsImagesDeleteall_580488, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesDelete_580504 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsImagesDelete_580506(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsImagesDelete_580505(path: JsonNode;
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
  var valid_580507 = path.getOrDefault("imageId")
  valid_580507 = validateParameter(valid_580507, JString, required = true,
                                 default = nil)
  if valid_580507 != nil:
    section.add "imageId", valid_580507
  var valid_580508 = path.getOrDefault("packageName")
  valid_580508 = validateParameter(valid_580508, JString, required = true,
                                 default = nil)
  if valid_580508 != nil:
    section.add "packageName", valid_580508
  var valid_580509 = path.getOrDefault("editId")
  valid_580509 = validateParameter(valid_580509, JString, required = true,
                                 default = nil)
  if valid_580509 != nil:
    section.add "editId", valid_580509
  var valid_580510 = path.getOrDefault("language")
  valid_580510 = validateParameter(valid_580510, JString, required = true,
                                 default = nil)
  if valid_580510 != nil:
    section.add "language", valid_580510
  var valid_580511 = path.getOrDefault("imageType")
  valid_580511 = validateParameter(valid_580511, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_580511 != nil:
    section.add "imageType", valid_580511
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
  var valid_580512 = query.getOrDefault("fields")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = nil)
  if valid_580512 != nil:
    section.add "fields", valid_580512
  var valid_580513 = query.getOrDefault("quotaUser")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "quotaUser", valid_580513
  var valid_580514 = query.getOrDefault("alt")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = newJString("json"))
  if valid_580514 != nil:
    section.add "alt", valid_580514
  var valid_580515 = query.getOrDefault("oauth_token")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "oauth_token", valid_580515
  var valid_580516 = query.getOrDefault("userIp")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "userIp", valid_580516
  var valid_580517 = query.getOrDefault("key")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "key", valid_580517
  var valid_580518 = query.getOrDefault("prettyPrint")
  valid_580518 = validateParameter(valid_580518, JBool, required = false,
                                 default = newJBool(true))
  if valid_580518 != nil:
    section.add "prettyPrint", valid_580518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580519: Call_AndroidpublisherEditsImagesDelete_580504;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the image (specified by id) from the edit.
  ## 
  let valid = call_580519.validator(path, query, header, formData, body)
  let scheme = call_580519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580519.url(scheme.get, call_580519.host, call_580519.base,
                         call_580519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580519, url, valid)

proc call*(call_580520: Call_AndroidpublisherEditsImagesDelete_580504;
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
  var path_580521 = newJObject()
  var query_580522 = newJObject()
  add(path_580521, "imageId", newJString(imageId))
  add(query_580522, "fields", newJString(fields))
  add(path_580521, "packageName", newJString(packageName))
  add(query_580522, "quotaUser", newJString(quotaUser))
  add(query_580522, "alt", newJString(alt))
  add(path_580521, "editId", newJString(editId))
  add(query_580522, "oauth_token", newJString(oauthToken))
  add(path_580521, "language", newJString(language))
  add(query_580522, "userIp", newJString(userIp))
  add(path_580521, "imageType", newJString(imageType))
  add(query_580522, "key", newJString(key))
  add(query_580522, "prettyPrint", newJBool(prettyPrint))
  result = call_580520.call(path_580521, query_580522, nil, nil, nil)

var androidpublisherEditsImagesDelete* = Call_AndroidpublisherEditsImagesDelete_580504(
    name: "androidpublisherEditsImagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}/{imageId}",
    validator: validate_AndroidpublisherEditsImagesDelete_580505,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsImagesDelete_580506, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersUpdate_580540 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsTestersUpdate_580542(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTestersUpdate_580541(path: JsonNode;
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
  var valid_580543 = path.getOrDefault("packageName")
  valid_580543 = validateParameter(valid_580543, JString, required = true,
                                 default = nil)
  if valid_580543 != nil:
    section.add "packageName", valid_580543
  var valid_580544 = path.getOrDefault("editId")
  valid_580544 = validateParameter(valid_580544, JString, required = true,
                                 default = nil)
  if valid_580544 != nil:
    section.add "editId", valid_580544
  var valid_580545 = path.getOrDefault("track")
  valid_580545 = validateParameter(valid_580545, JString, required = true,
                                 default = nil)
  if valid_580545 != nil:
    section.add "track", valid_580545
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
  var valid_580546 = query.getOrDefault("fields")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "fields", valid_580546
  var valid_580547 = query.getOrDefault("quotaUser")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "quotaUser", valid_580547
  var valid_580548 = query.getOrDefault("alt")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = newJString("json"))
  if valid_580548 != nil:
    section.add "alt", valid_580548
  var valid_580549 = query.getOrDefault("oauth_token")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "oauth_token", valid_580549
  var valid_580550 = query.getOrDefault("userIp")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = nil)
  if valid_580550 != nil:
    section.add "userIp", valid_580550
  var valid_580551 = query.getOrDefault("key")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "key", valid_580551
  var valid_580552 = query.getOrDefault("prettyPrint")
  valid_580552 = validateParameter(valid_580552, JBool, required = false,
                                 default = newJBool(true))
  if valid_580552 != nil:
    section.add "prettyPrint", valid_580552
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

proc call*(call_580554: Call_AndroidpublisherEditsTestersUpdate_580540;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_580554.validator(path, query, header, formData, body)
  let scheme = call_580554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580554.url(scheme.get, call_580554.host, call_580554.base,
                         call_580554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580554, url, valid)

proc call*(call_580555: Call_AndroidpublisherEditsTestersUpdate_580540;
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
  var path_580556 = newJObject()
  var query_580557 = newJObject()
  var body_580558 = newJObject()
  add(query_580557, "fields", newJString(fields))
  add(path_580556, "packageName", newJString(packageName))
  add(query_580557, "quotaUser", newJString(quotaUser))
  add(query_580557, "alt", newJString(alt))
  add(path_580556, "editId", newJString(editId))
  add(query_580557, "oauth_token", newJString(oauthToken))
  add(query_580557, "userIp", newJString(userIp))
  add(query_580557, "key", newJString(key))
  if body != nil:
    body_580558 = body
  add(query_580557, "prettyPrint", newJBool(prettyPrint))
  add(path_580556, "track", newJString(track))
  result = call_580555.call(path_580556, query_580557, nil, nil, body_580558)

var androidpublisherEditsTestersUpdate* = Call_AndroidpublisherEditsTestersUpdate_580540(
    name: "androidpublisherEditsTestersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersUpdate_580541,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTestersUpdate_580542, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersGet_580523 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsTestersGet_580525(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTestersGet_580524(path: JsonNode;
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
  var valid_580526 = path.getOrDefault("packageName")
  valid_580526 = validateParameter(valid_580526, JString, required = true,
                                 default = nil)
  if valid_580526 != nil:
    section.add "packageName", valid_580526
  var valid_580527 = path.getOrDefault("editId")
  valid_580527 = validateParameter(valid_580527, JString, required = true,
                                 default = nil)
  if valid_580527 != nil:
    section.add "editId", valid_580527
  var valid_580528 = path.getOrDefault("track")
  valid_580528 = validateParameter(valid_580528, JString, required = true,
                                 default = nil)
  if valid_580528 != nil:
    section.add "track", valid_580528
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
  var valid_580529 = query.getOrDefault("fields")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "fields", valid_580529
  var valid_580530 = query.getOrDefault("quotaUser")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "quotaUser", valid_580530
  var valid_580531 = query.getOrDefault("alt")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = newJString("json"))
  if valid_580531 != nil:
    section.add "alt", valid_580531
  var valid_580532 = query.getOrDefault("oauth_token")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "oauth_token", valid_580532
  var valid_580533 = query.getOrDefault("userIp")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "userIp", valid_580533
  var valid_580534 = query.getOrDefault("key")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "key", valid_580534
  var valid_580535 = query.getOrDefault("prettyPrint")
  valid_580535 = validateParameter(valid_580535, JBool, required = false,
                                 default = newJBool(true))
  if valid_580535 != nil:
    section.add "prettyPrint", valid_580535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580536: Call_AndroidpublisherEditsTestersGet_580523;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_580536.validator(path, query, header, formData, body)
  let scheme = call_580536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580536.url(scheme.get, call_580536.host, call_580536.base,
                         call_580536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580536, url, valid)

proc call*(call_580537: Call_AndroidpublisherEditsTestersGet_580523;
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
  var path_580538 = newJObject()
  var query_580539 = newJObject()
  add(query_580539, "fields", newJString(fields))
  add(path_580538, "packageName", newJString(packageName))
  add(query_580539, "quotaUser", newJString(quotaUser))
  add(query_580539, "alt", newJString(alt))
  add(path_580538, "editId", newJString(editId))
  add(query_580539, "oauth_token", newJString(oauthToken))
  add(query_580539, "userIp", newJString(userIp))
  add(query_580539, "key", newJString(key))
  add(query_580539, "prettyPrint", newJBool(prettyPrint))
  add(path_580538, "track", newJString(track))
  result = call_580537.call(path_580538, query_580539, nil, nil, nil)

var androidpublisherEditsTestersGet* = Call_AndroidpublisherEditsTestersGet_580523(
    name: "androidpublisherEditsTestersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersGet_580524,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTestersGet_580525, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersPatch_580559 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsTestersPatch_580561(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTestersPatch_580560(path: JsonNode;
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
  var valid_580562 = path.getOrDefault("packageName")
  valid_580562 = validateParameter(valid_580562, JString, required = true,
                                 default = nil)
  if valid_580562 != nil:
    section.add "packageName", valid_580562
  var valid_580563 = path.getOrDefault("editId")
  valid_580563 = validateParameter(valid_580563, JString, required = true,
                                 default = nil)
  if valid_580563 != nil:
    section.add "editId", valid_580563
  var valid_580564 = path.getOrDefault("track")
  valid_580564 = validateParameter(valid_580564, JString, required = true,
                                 default = nil)
  if valid_580564 != nil:
    section.add "track", valid_580564
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
  var valid_580565 = query.getOrDefault("fields")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "fields", valid_580565
  var valid_580566 = query.getOrDefault("quotaUser")
  valid_580566 = validateParameter(valid_580566, JString, required = false,
                                 default = nil)
  if valid_580566 != nil:
    section.add "quotaUser", valid_580566
  var valid_580567 = query.getOrDefault("alt")
  valid_580567 = validateParameter(valid_580567, JString, required = false,
                                 default = newJString("json"))
  if valid_580567 != nil:
    section.add "alt", valid_580567
  var valid_580568 = query.getOrDefault("oauth_token")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "oauth_token", valid_580568
  var valid_580569 = query.getOrDefault("userIp")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "userIp", valid_580569
  var valid_580570 = query.getOrDefault("key")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "key", valid_580570
  var valid_580571 = query.getOrDefault("prettyPrint")
  valid_580571 = validateParameter(valid_580571, JBool, required = false,
                                 default = newJBool(true))
  if valid_580571 != nil:
    section.add "prettyPrint", valid_580571
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

proc call*(call_580573: Call_AndroidpublisherEditsTestersPatch_580559;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_580573.validator(path, query, header, formData, body)
  let scheme = call_580573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580573.url(scheme.get, call_580573.host, call_580573.base,
                         call_580573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580573, url, valid)

proc call*(call_580574: Call_AndroidpublisherEditsTestersPatch_580559;
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
  var path_580575 = newJObject()
  var query_580576 = newJObject()
  var body_580577 = newJObject()
  add(query_580576, "fields", newJString(fields))
  add(path_580575, "packageName", newJString(packageName))
  add(query_580576, "quotaUser", newJString(quotaUser))
  add(query_580576, "alt", newJString(alt))
  add(path_580575, "editId", newJString(editId))
  add(query_580576, "oauth_token", newJString(oauthToken))
  add(query_580576, "userIp", newJString(userIp))
  add(query_580576, "key", newJString(key))
  if body != nil:
    body_580577 = body
  add(query_580576, "prettyPrint", newJBool(prettyPrint))
  add(path_580575, "track", newJString(track))
  result = call_580574.call(path_580575, query_580576, nil, nil, body_580577)

var androidpublisherEditsTestersPatch* = Call_AndroidpublisherEditsTestersPatch_580559(
    name: "androidpublisherEditsTestersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersPatch_580560,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTestersPatch_580561, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksList_580578 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsTracksList_580580(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTracksList_580579(path: JsonNode;
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
  var valid_580581 = path.getOrDefault("packageName")
  valid_580581 = validateParameter(valid_580581, JString, required = true,
                                 default = nil)
  if valid_580581 != nil:
    section.add "packageName", valid_580581
  var valid_580582 = path.getOrDefault("editId")
  valid_580582 = validateParameter(valid_580582, JString, required = true,
                                 default = nil)
  if valid_580582 != nil:
    section.add "editId", valid_580582
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
  var valid_580583 = query.getOrDefault("fields")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "fields", valid_580583
  var valid_580584 = query.getOrDefault("quotaUser")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = nil)
  if valid_580584 != nil:
    section.add "quotaUser", valid_580584
  var valid_580585 = query.getOrDefault("alt")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = newJString("json"))
  if valid_580585 != nil:
    section.add "alt", valid_580585
  var valid_580586 = query.getOrDefault("oauth_token")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = nil)
  if valid_580586 != nil:
    section.add "oauth_token", valid_580586
  var valid_580587 = query.getOrDefault("userIp")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "userIp", valid_580587
  var valid_580588 = query.getOrDefault("key")
  valid_580588 = validateParameter(valid_580588, JString, required = false,
                                 default = nil)
  if valid_580588 != nil:
    section.add "key", valid_580588
  var valid_580589 = query.getOrDefault("prettyPrint")
  valid_580589 = validateParameter(valid_580589, JBool, required = false,
                                 default = newJBool(true))
  if valid_580589 != nil:
    section.add "prettyPrint", valid_580589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580590: Call_AndroidpublisherEditsTracksList_580578;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the track configurations for this edit.
  ## 
  let valid = call_580590.validator(path, query, header, formData, body)
  let scheme = call_580590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580590.url(scheme.get, call_580590.host, call_580590.base,
                         call_580590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580590, url, valid)

proc call*(call_580591: Call_AndroidpublisherEditsTracksList_580578;
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
  var path_580592 = newJObject()
  var query_580593 = newJObject()
  add(query_580593, "fields", newJString(fields))
  add(path_580592, "packageName", newJString(packageName))
  add(query_580593, "quotaUser", newJString(quotaUser))
  add(query_580593, "alt", newJString(alt))
  add(path_580592, "editId", newJString(editId))
  add(query_580593, "oauth_token", newJString(oauthToken))
  add(query_580593, "userIp", newJString(userIp))
  add(query_580593, "key", newJString(key))
  add(query_580593, "prettyPrint", newJBool(prettyPrint))
  result = call_580591.call(path_580592, query_580593, nil, nil, nil)

var androidpublisherEditsTracksList* = Call_AndroidpublisherEditsTracksList_580578(
    name: "androidpublisherEditsTracksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/tracks",
    validator: validate_AndroidpublisherEditsTracksList_580579,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTracksList_580580, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksUpdate_580611 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsTracksUpdate_580613(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTracksUpdate_580612(path: JsonNode;
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
  var valid_580614 = path.getOrDefault("packageName")
  valid_580614 = validateParameter(valid_580614, JString, required = true,
                                 default = nil)
  if valid_580614 != nil:
    section.add "packageName", valid_580614
  var valid_580615 = path.getOrDefault("editId")
  valid_580615 = validateParameter(valid_580615, JString, required = true,
                                 default = nil)
  if valid_580615 != nil:
    section.add "editId", valid_580615
  var valid_580616 = path.getOrDefault("track")
  valid_580616 = validateParameter(valid_580616, JString, required = true,
                                 default = nil)
  if valid_580616 != nil:
    section.add "track", valid_580616
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
  var valid_580617 = query.getOrDefault("fields")
  valid_580617 = validateParameter(valid_580617, JString, required = false,
                                 default = nil)
  if valid_580617 != nil:
    section.add "fields", valid_580617
  var valid_580618 = query.getOrDefault("quotaUser")
  valid_580618 = validateParameter(valid_580618, JString, required = false,
                                 default = nil)
  if valid_580618 != nil:
    section.add "quotaUser", valid_580618
  var valid_580619 = query.getOrDefault("alt")
  valid_580619 = validateParameter(valid_580619, JString, required = false,
                                 default = newJString("json"))
  if valid_580619 != nil:
    section.add "alt", valid_580619
  var valid_580620 = query.getOrDefault("oauth_token")
  valid_580620 = validateParameter(valid_580620, JString, required = false,
                                 default = nil)
  if valid_580620 != nil:
    section.add "oauth_token", valid_580620
  var valid_580621 = query.getOrDefault("userIp")
  valid_580621 = validateParameter(valid_580621, JString, required = false,
                                 default = nil)
  if valid_580621 != nil:
    section.add "userIp", valid_580621
  var valid_580622 = query.getOrDefault("key")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = nil)
  if valid_580622 != nil:
    section.add "key", valid_580622
  var valid_580623 = query.getOrDefault("prettyPrint")
  valid_580623 = validateParameter(valid_580623, JBool, required = false,
                                 default = newJBool(true))
  if valid_580623 != nil:
    section.add "prettyPrint", valid_580623
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

proc call*(call_580625: Call_AndroidpublisherEditsTracksUpdate_580611;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the track configuration for the specified track type.
  ## 
  let valid = call_580625.validator(path, query, header, formData, body)
  let scheme = call_580625.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580625.url(scheme.get, call_580625.host, call_580625.base,
                         call_580625.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580625, url, valid)

proc call*(call_580626: Call_AndroidpublisherEditsTracksUpdate_580611;
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
  var path_580627 = newJObject()
  var query_580628 = newJObject()
  var body_580629 = newJObject()
  add(query_580628, "fields", newJString(fields))
  add(path_580627, "packageName", newJString(packageName))
  add(query_580628, "quotaUser", newJString(quotaUser))
  add(query_580628, "alt", newJString(alt))
  add(path_580627, "editId", newJString(editId))
  add(query_580628, "oauth_token", newJString(oauthToken))
  add(query_580628, "userIp", newJString(userIp))
  add(query_580628, "key", newJString(key))
  if body != nil:
    body_580629 = body
  add(query_580628, "prettyPrint", newJBool(prettyPrint))
  add(path_580627, "track", newJString(track))
  result = call_580626.call(path_580627, query_580628, nil, nil, body_580629)

var androidpublisherEditsTracksUpdate* = Call_AndroidpublisherEditsTracksUpdate_580611(
    name: "androidpublisherEditsTracksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksUpdate_580612,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTracksUpdate_580613, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksGet_580594 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsTracksGet_580596(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTracksGet_580595(path: JsonNode;
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
  var valid_580597 = path.getOrDefault("packageName")
  valid_580597 = validateParameter(valid_580597, JString, required = true,
                                 default = nil)
  if valid_580597 != nil:
    section.add "packageName", valid_580597
  var valid_580598 = path.getOrDefault("editId")
  valid_580598 = validateParameter(valid_580598, JString, required = true,
                                 default = nil)
  if valid_580598 != nil:
    section.add "editId", valid_580598
  var valid_580599 = path.getOrDefault("track")
  valid_580599 = validateParameter(valid_580599, JString, required = true,
                                 default = nil)
  if valid_580599 != nil:
    section.add "track", valid_580599
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
  var valid_580600 = query.getOrDefault("fields")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = nil)
  if valid_580600 != nil:
    section.add "fields", valid_580600
  var valid_580601 = query.getOrDefault("quotaUser")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = nil)
  if valid_580601 != nil:
    section.add "quotaUser", valid_580601
  var valid_580602 = query.getOrDefault("alt")
  valid_580602 = validateParameter(valid_580602, JString, required = false,
                                 default = newJString("json"))
  if valid_580602 != nil:
    section.add "alt", valid_580602
  var valid_580603 = query.getOrDefault("oauth_token")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = nil)
  if valid_580603 != nil:
    section.add "oauth_token", valid_580603
  var valid_580604 = query.getOrDefault("userIp")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = nil)
  if valid_580604 != nil:
    section.add "userIp", valid_580604
  var valid_580605 = query.getOrDefault("key")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "key", valid_580605
  var valid_580606 = query.getOrDefault("prettyPrint")
  valid_580606 = validateParameter(valid_580606, JBool, required = false,
                                 default = newJBool(true))
  if valid_580606 != nil:
    section.add "prettyPrint", valid_580606
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580607: Call_AndroidpublisherEditsTracksGet_580594; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the track configuration for the specified track type. Includes the APK version codes that are in this track.
  ## 
  let valid = call_580607.validator(path, query, header, formData, body)
  let scheme = call_580607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580607.url(scheme.get, call_580607.host, call_580607.base,
                         call_580607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580607, url, valid)

proc call*(call_580608: Call_AndroidpublisherEditsTracksGet_580594;
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
  var path_580609 = newJObject()
  var query_580610 = newJObject()
  add(query_580610, "fields", newJString(fields))
  add(path_580609, "packageName", newJString(packageName))
  add(query_580610, "quotaUser", newJString(quotaUser))
  add(query_580610, "alt", newJString(alt))
  add(path_580609, "editId", newJString(editId))
  add(query_580610, "oauth_token", newJString(oauthToken))
  add(query_580610, "userIp", newJString(userIp))
  add(query_580610, "key", newJString(key))
  add(query_580610, "prettyPrint", newJBool(prettyPrint))
  add(path_580609, "track", newJString(track))
  result = call_580608.call(path_580609, query_580610, nil, nil, nil)

var androidpublisherEditsTracksGet* = Call_AndroidpublisherEditsTracksGet_580594(
    name: "androidpublisherEditsTracksGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksGet_580595,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTracksGet_580596, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksPatch_580630 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsTracksPatch_580632(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTracksPatch_580631(path: JsonNode;
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
  var valid_580633 = path.getOrDefault("packageName")
  valid_580633 = validateParameter(valid_580633, JString, required = true,
                                 default = nil)
  if valid_580633 != nil:
    section.add "packageName", valid_580633
  var valid_580634 = path.getOrDefault("editId")
  valid_580634 = validateParameter(valid_580634, JString, required = true,
                                 default = nil)
  if valid_580634 != nil:
    section.add "editId", valid_580634
  var valid_580635 = path.getOrDefault("track")
  valid_580635 = validateParameter(valid_580635, JString, required = true,
                                 default = nil)
  if valid_580635 != nil:
    section.add "track", valid_580635
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
  var valid_580636 = query.getOrDefault("fields")
  valid_580636 = validateParameter(valid_580636, JString, required = false,
                                 default = nil)
  if valid_580636 != nil:
    section.add "fields", valid_580636
  var valid_580637 = query.getOrDefault("quotaUser")
  valid_580637 = validateParameter(valid_580637, JString, required = false,
                                 default = nil)
  if valid_580637 != nil:
    section.add "quotaUser", valid_580637
  var valid_580638 = query.getOrDefault("alt")
  valid_580638 = validateParameter(valid_580638, JString, required = false,
                                 default = newJString("json"))
  if valid_580638 != nil:
    section.add "alt", valid_580638
  var valid_580639 = query.getOrDefault("oauth_token")
  valid_580639 = validateParameter(valid_580639, JString, required = false,
                                 default = nil)
  if valid_580639 != nil:
    section.add "oauth_token", valid_580639
  var valid_580640 = query.getOrDefault("userIp")
  valid_580640 = validateParameter(valid_580640, JString, required = false,
                                 default = nil)
  if valid_580640 != nil:
    section.add "userIp", valid_580640
  var valid_580641 = query.getOrDefault("key")
  valid_580641 = validateParameter(valid_580641, JString, required = false,
                                 default = nil)
  if valid_580641 != nil:
    section.add "key", valid_580641
  var valid_580642 = query.getOrDefault("prettyPrint")
  valid_580642 = validateParameter(valid_580642, JBool, required = false,
                                 default = newJBool(true))
  if valid_580642 != nil:
    section.add "prettyPrint", valid_580642
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

proc call*(call_580644: Call_AndroidpublisherEditsTracksPatch_580630;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the track configuration for the specified track type. This method supports patch semantics.
  ## 
  let valid = call_580644.validator(path, query, header, formData, body)
  let scheme = call_580644.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580644.url(scheme.get, call_580644.host, call_580644.base,
                         call_580644.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580644, url, valid)

proc call*(call_580645: Call_AndroidpublisherEditsTracksPatch_580630;
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
  var path_580646 = newJObject()
  var query_580647 = newJObject()
  var body_580648 = newJObject()
  add(query_580647, "fields", newJString(fields))
  add(path_580646, "packageName", newJString(packageName))
  add(query_580647, "quotaUser", newJString(quotaUser))
  add(query_580647, "alt", newJString(alt))
  add(path_580646, "editId", newJString(editId))
  add(query_580647, "oauth_token", newJString(oauthToken))
  add(query_580647, "userIp", newJString(userIp))
  add(query_580647, "key", newJString(key))
  if body != nil:
    body_580648 = body
  add(query_580647, "prettyPrint", newJBool(prettyPrint))
  add(path_580646, "track", newJString(track))
  result = call_580645.call(path_580646, query_580647, nil, nil, body_580648)

var androidpublisherEditsTracksPatch* = Call_AndroidpublisherEditsTracksPatch_580630(
    name: "androidpublisherEditsTracksPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksPatch_580631,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTracksPatch_580632, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsCommit_580649 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsCommit_580651(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsCommit_580650(path: JsonNode; query: JsonNode;
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
  var valid_580652 = path.getOrDefault("packageName")
  valid_580652 = validateParameter(valid_580652, JString, required = true,
                                 default = nil)
  if valid_580652 != nil:
    section.add "packageName", valid_580652
  var valid_580653 = path.getOrDefault("editId")
  valid_580653 = validateParameter(valid_580653, JString, required = true,
                                 default = nil)
  if valid_580653 != nil:
    section.add "editId", valid_580653
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
  var valid_580654 = query.getOrDefault("fields")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = nil)
  if valid_580654 != nil:
    section.add "fields", valid_580654
  var valid_580655 = query.getOrDefault("quotaUser")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = nil)
  if valid_580655 != nil:
    section.add "quotaUser", valid_580655
  var valid_580656 = query.getOrDefault("alt")
  valid_580656 = validateParameter(valid_580656, JString, required = false,
                                 default = newJString("json"))
  if valid_580656 != nil:
    section.add "alt", valid_580656
  var valid_580657 = query.getOrDefault("oauth_token")
  valid_580657 = validateParameter(valid_580657, JString, required = false,
                                 default = nil)
  if valid_580657 != nil:
    section.add "oauth_token", valid_580657
  var valid_580658 = query.getOrDefault("userIp")
  valid_580658 = validateParameter(valid_580658, JString, required = false,
                                 default = nil)
  if valid_580658 != nil:
    section.add "userIp", valid_580658
  var valid_580659 = query.getOrDefault("key")
  valid_580659 = validateParameter(valid_580659, JString, required = false,
                                 default = nil)
  if valid_580659 != nil:
    section.add "key", valid_580659
  var valid_580660 = query.getOrDefault("prettyPrint")
  valid_580660 = validateParameter(valid_580660, JBool, required = false,
                                 default = newJBool(true))
  if valid_580660 != nil:
    section.add "prettyPrint", valid_580660
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580661: Call_AndroidpublisherEditsCommit_580649; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Commits/applies the changes made in this edit back to the app.
  ## 
  let valid = call_580661.validator(path, query, header, formData, body)
  let scheme = call_580661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580661.url(scheme.get, call_580661.host, call_580661.base,
                         call_580661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580661, url, valid)

proc call*(call_580662: Call_AndroidpublisherEditsCommit_580649;
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
  var path_580663 = newJObject()
  var query_580664 = newJObject()
  add(query_580664, "fields", newJString(fields))
  add(path_580663, "packageName", newJString(packageName))
  add(query_580664, "quotaUser", newJString(quotaUser))
  add(query_580664, "alt", newJString(alt))
  add(path_580663, "editId", newJString(editId))
  add(query_580664, "oauth_token", newJString(oauthToken))
  add(query_580664, "userIp", newJString(userIp))
  add(query_580664, "key", newJString(key))
  add(query_580664, "prettyPrint", newJBool(prettyPrint))
  result = call_580662.call(path_580663, query_580664, nil, nil, nil)

var androidpublisherEditsCommit* = Call_AndroidpublisherEditsCommit_580649(
    name: "androidpublisherEditsCommit", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}:commit",
    validator: validate_AndroidpublisherEditsCommit_580650,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsCommit_580651, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsValidate_580665 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsValidate_580667(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsValidate_580666(path: JsonNode; query: JsonNode;
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
  var valid_580668 = path.getOrDefault("packageName")
  valid_580668 = validateParameter(valid_580668, JString, required = true,
                                 default = nil)
  if valid_580668 != nil:
    section.add "packageName", valid_580668
  var valid_580669 = path.getOrDefault("editId")
  valid_580669 = validateParameter(valid_580669, JString, required = true,
                                 default = nil)
  if valid_580669 != nil:
    section.add "editId", valid_580669
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
  var valid_580670 = query.getOrDefault("fields")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = nil)
  if valid_580670 != nil:
    section.add "fields", valid_580670
  var valid_580671 = query.getOrDefault("quotaUser")
  valid_580671 = validateParameter(valid_580671, JString, required = false,
                                 default = nil)
  if valid_580671 != nil:
    section.add "quotaUser", valid_580671
  var valid_580672 = query.getOrDefault("alt")
  valid_580672 = validateParameter(valid_580672, JString, required = false,
                                 default = newJString("json"))
  if valid_580672 != nil:
    section.add "alt", valid_580672
  var valid_580673 = query.getOrDefault("oauth_token")
  valid_580673 = validateParameter(valid_580673, JString, required = false,
                                 default = nil)
  if valid_580673 != nil:
    section.add "oauth_token", valid_580673
  var valid_580674 = query.getOrDefault("userIp")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = nil)
  if valid_580674 != nil:
    section.add "userIp", valid_580674
  var valid_580675 = query.getOrDefault("key")
  valid_580675 = validateParameter(valid_580675, JString, required = false,
                                 default = nil)
  if valid_580675 != nil:
    section.add "key", valid_580675
  var valid_580676 = query.getOrDefault("prettyPrint")
  valid_580676 = validateParameter(valid_580676, JBool, required = false,
                                 default = newJBool(true))
  if valid_580676 != nil:
    section.add "prettyPrint", valid_580676
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580677: Call_AndroidpublisherEditsValidate_580665; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that the edit can be successfully committed. The edit's changes are not applied to the live app.
  ## 
  let valid = call_580677.validator(path, query, header, formData, body)
  let scheme = call_580677.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580677.url(scheme.get, call_580677.host, call_580677.base,
                         call_580677.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580677, url, valid)

proc call*(call_580678: Call_AndroidpublisherEditsValidate_580665;
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
  var path_580679 = newJObject()
  var query_580680 = newJObject()
  add(query_580680, "fields", newJString(fields))
  add(path_580679, "packageName", newJString(packageName))
  add(query_580680, "quotaUser", newJString(quotaUser))
  add(query_580680, "alt", newJString(alt))
  add(path_580679, "editId", newJString(editId))
  add(query_580680, "oauth_token", newJString(oauthToken))
  add(query_580680, "userIp", newJString(userIp))
  add(query_580680, "key", newJString(key))
  add(query_580680, "prettyPrint", newJBool(prettyPrint))
  result = call_580678.call(path_580679, query_580680, nil, nil, nil)

var androidpublisherEditsValidate* = Call_AndroidpublisherEditsValidate_580665(
    name: "androidpublisherEditsValidate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}:validate",
    validator: validate_AndroidpublisherEditsValidate_580666,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsValidate_580667, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsInsert_580699 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherInappproductsInsert_580701(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsInsert_580700(path: JsonNode;
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
  var valid_580702 = path.getOrDefault("packageName")
  valid_580702 = validateParameter(valid_580702, JString, required = true,
                                 default = nil)
  if valid_580702 != nil:
    section.add "packageName", valid_580702
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
  var valid_580703 = query.getOrDefault("fields")
  valid_580703 = validateParameter(valid_580703, JString, required = false,
                                 default = nil)
  if valid_580703 != nil:
    section.add "fields", valid_580703
  var valid_580704 = query.getOrDefault("quotaUser")
  valid_580704 = validateParameter(valid_580704, JString, required = false,
                                 default = nil)
  if valid_580704 != nil:
    section.add "quotaUser", valid_580704
  var valid_580705 = query.getOrDefault("alt")
  valid_580705 = validateParameter(valid_580705, JString, required = false,
                                 default = newJString("json"))
  if valid_580705 != nil:
    section.add "alt", valid_580705
  var valid_580706 = query.getOrDefault("oauth_token")
  valid_580706 = validateParameter(valid_580706, JString, required = false,
                                 default = nil)
  if valid_580706 != nil:
    section.add "oauth_token", valid_580706
  var valid_580707 = query.getOrDefault("userIp")
  valid_580707 = validateParameter(valid_580707, JString, required = false,
                                 default = nil)
  if valid_580707 != nil:
    section.add "userIp", valid_580707
  var valid_580708 = query.getOrDefault("key")
  valid_580708 = validateParameter(valid_580708, JString, required = false,
                                 default = nil)
  if valid_580708 != nil:
    section.add "key", valid_580708
  var valid_580709 = query.getOrDefault("autoConvertMissingPrices")
  valid_580709 = validateParameter(valid_580709, JBool, required = false, default = nil)
  if valid_580709 != nil:
    section.add "autoConvertMissingPrices", valid_580709
  var valid_580710 = query.getOrDefault("prettyPrint")
  valid_580710 = validateParameter(valid_580710, JBool, required = false,
                                 default = newJBool(true))
  if valid_580710 != nil:
    section.add "prettyPrint", valid_580710
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

proc call*(call_580712: Call_AndroidpublisherInappproductsInsert_580699;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new in-app product for an app.
  ## 
  let valid = call_580712.validator(path, query, header, formData, body)
  let scheme = call_580712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580712.url(scheme.get, call_580712.host, call_580712.base,
                         call_580712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580712, url, valid)

proc call*(call_580713: Call_AndroidpublisherInappproductsInsert_580699;
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
  var path_580714 = newJObject()
  var query_580715 = newJObject()
  var body_580716 = newJObject()
  add(query_580715, "fields", newJString(fields))
  add(path_580714, "packageName", newJString(packageName))
  add(query_580715, "quotaUser", newJString(quotaUser))
  add(query_580715, "alt", newJString(alt))
  add(query_580715, "oauth_token", newJString(oauthToken))
  add(query_580715, "userIp", newJString(userIp))
  add(query_580715, "key", newJString(key))
  add(query_580715, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_580716 = body
  add(query_580715, "prettyPrint", newJBool(prettyPrint))
  result = call_580713.call(path_580714, query_580715, nil, nil, body_580716)

var androidpublisherInappproductsInsert* = Call_AndroidpublisherInappproductsInsert_580699(
    name: "androidpublisherInappproductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts",
    validator: validate_AndroidpublisherInappproductsInsert_580700,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsInsert_580701, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsList_580681 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherInappproductsList_580683(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsList_580682(path: JsonNode;
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
  var valid_580684 = path.getOrDefault("packageName")
  valid_580684 = validateParameter(valid_580684, JString, required = true,
                                 default = nil)
  if valid_580684 != nil:
    section.add "packageName", valid_580684
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
  var valid_580685 = query.getOrDefault("token")
  valid_580685 = validateParameter(valid_580685, JString, required = false,
                                 default = nil)
  if valid_580685 != nil:
    section.add "token", valid_580685
  var valid_580686 = query.getOrDefault("fields")
  valid_580686 = validateParameter(valid_580686, JString, required = false,
                                 default = nil)
  if valid_580686 != nil:
    section.add "fields", valid_580686
  var valid_580687 = query.getOrDefault("quotaUser")
  valid_580687 = validateParameter(valid_580687, JString, required = false,
                                 default = nil)
  if valid_580687 != nil:
    section.add "quotaUser", valid_580687
  var valid_580688 = query.getOrDefault("alt")
  valid_580688 = validateParameter(valid_580688, JString, required = false,
                                 default = newJString("json"))
  if valid_580688 != nil:
    section.add "alt", valid_580688
  var valid_580689 = query.getOrDefault("oauth_token")
  valid_580689 = validateParameter(valid_580689, JString, required = false,
                                 default = nil)
  if valid_580689 != nil:
    section.add "oauth_token", valid_580689
  var valid_580690 = query.getOrDefault("userIp")
  valid_580690 = validateParameter(valid_580690, JString, required = false,
                                 default = nil)
  if valid_580690 != nil:
    section.add "userIp", valid_580690
  var valid_580691 = query.getOrDefault("maxResults")
  valid_580691 = validateParameter(valid_580691, JInt, required = false, default = nil)
  if valid_580691 != nil:
    section.add "maxResults", valid_580691
  var valid_580692 = query.getOrDefault("key")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = nil)
  if valid_580692 != nil:
    section.add "key", valid_580692
  var valid_580693 = query.getOrDefault("prettyPrint")
  valid_580693 = validateParameter(valid_580693, JBool, required = false,
                                 default = newJBool(true))
  if valid_580693 != nil:
    section.add "prettyPrint", valid_580693
  var valid_580694 = query.getOrDefault("startIndex")
  valid_580694 = validateParameter(valid_580694, JInt, required = false, default = nil)
  if valid_580694 != nil:
    section.add "startIndex", valid_580694
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580695: Call_AndroidpublisherInappproductsList_580681;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the in-app products for an Android app, both subscriptions and managed in-app products..
  ## 
  let valid = call_580695.validator(path, query, header, formData, body)
  let scheme = call_580695.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580695.url(scheme.get, call_580695.host, call_580695.base,
                         call_580695.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580695, url, valid)

proc call*(call_580696: Call_AndroidpublisherInappproductsList_580681;
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
  var path_580697 = newJObject()
  var query_580698 = newJObject()
  add(query_580698, "token", newJString(token))
  add(query_580698, "fields", newJString(fields))
  add(path_580697, "packageName", newJString(packageName))
  add(query_580698, "quotaUser", newJString(quotaUser))
  add(query_580698, "alt", newJString(alt))
  add(query_580698, "oauth_token", newJString(oauthToken))
  add(query_580698, "userIp", newJString(userIp))
  add(query_580698, "maxResults", newJInt(maxResults))
  add(query_580698, "key", newJString(key))
  add(query_580698, "prettyPrint", newJBool(prettyPrint))
  add(query_580698, "startIndex", newJInt(startIndex))
  result = call_580696.call(path_580697, query_580698, nil, nil, nil)

var androidpublisherInappproductsList* = Call_AndroidpublisherInappproductsList_580681(
    name: "androidpublisherInappproductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts",
    validator: validate_AndroidpublisherInappproductsList_580682,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsList_580683, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsUpdate_580733 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherInappproductsUpdate_580735(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsUpdate_580734(path: JsonNode;
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
  var valid_580736 = path.getOrDefault("packageName")
  valid_580736 = validateParameter(valid_580736, JString, required = true,
                                 default = nil)
  if valid_580736 != nil:
    section.add "packageName", valid_580736
  var valid_580737 = path.getOrDefault("sku")
  valid_580737 = validateParameter(valid_580737, JString, required = true,
                                 default = nil)
  if valid_580737 != nil:
    section.add "sku", valid_580737
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
  var valid_580738 = query.getOrDefault("fields")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = nil)
  if valid_580738 != nil:
    section.add "fields", valid_580738
  var valid_580739 = query.getOrDefault("quotaUser")
  valid_580739 = validateParameter(valid_580739, JString, required = false,
                                 default = nil)
  if valid_580739 != nil:
    section.add "quotaUser", valid_580739
  var valid_580740 = query.getOrDefault("alt")
  valid_580740 = validateParameter(valid_580740, JString, required = false,
                                 default = newJString("json"))
  if valid_580740 != nil:
    section.add "alt", valid_580740
  var valid_580741 = query.getOrDefault("oauth_token")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = nil)
  if valid_580741 != nil:
    section.add "oauth_token", valid_580741
  var valid_580742 = query.getOrDefault("userIp")
  valid_580742 = validateParameter(valid_580742, JString, required = false,
                                 default = nil)
  if valid_580742 != nil:
    section.add "userIp", valid_580742
  var valid_580743 = query.getOrDefault("key")
  valid_580743 = validateParameter(valid_580743, JString, required = false,
                                 default = nil)
  if valid_580743 != nil:
    section.add "key", valid_580743
  var valid_580744 = query.getOrDefault("autoConvertMissingPrices")
  valid_580744 = validateParameter(valid_580744, JBool, required = false, default = nil)
  if valid_580744 != nil:
    section.add "autoConvertMissingPrices", valid_580744
  var valid_580745 = query.getOrDefault("prettyPrint")
  valid_580745 = validateParameter(valid_580745, JBool, required = false,
                                 default = newJBool(true))
  if valid_580745 != nil:
    section.add "prettyPrint", valid_580745
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

proc call*(call_580747: Call_AndroidpublisherInappproductsUpdate_580733;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the details of an in-app product.
  ## 
  let valid = call_580747.validator(path, query, header, formData, body)
  let scheme = call_580747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580747.url(scheme.get, call_580747.host, call_580747.base,
                         call_580747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580747, url, valid)

proc call*(call_580748: Call_AndroidpublisherInappproductsUpdate_580733;
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
  var path_580749 = newJObject()
  var query_580750 = newJObject()
  var body_580751 = newJObject()
  add(query_580750, "fields", newJString(fields))
  add(path_580749, "packageName", newJString(packageName))
  add(query_580750, "quotaUser", newJString(quotaUser))
  add(query_580750, "alt", newJString(alt))
  add(query_580750, "oauth_token", newJString(oauthToken))
  add(query_580750, "userIp", newJString(userIp))
  add(path_580749, "sku", newJString(sku))
  add(query_580750, "key", newJString(key))
  add(query_580750, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_580751 = body
  add(query_580750, "prettyPrint", newJBool(prettyPrint))
  result = call_580748.call(path_580749, query_580750, nil, nil, body_580751)

var androidpublisherInappproductsUpdate* = Call_AndroidpublisherInappproductsUpdate_580733(
    name: "androidpublisherInappproductsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsUpdate_580734,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsUpdate_580735, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsGet_580717 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherInappproductsGet_580719(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsGet_580718(path: JsonNode;
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
  var valid_580720 = path.getOrDefault("packageName")
  valid_580720 = validateParameter(valid_580720, JString, required = true,
                                 default = nil)
  if valid_580720 != nil:
    section.add "packageName", valid_580720
  var valid_580721 = path.getOrDefault("sku")
  valid_580721 = validateParameter(valid_580721, JString, required = true,
                                 default = nil)
  if valid_580721 != nil:
    section.add "sku", valid_580721
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
  var valid_580722 = query.getOrDefault("fields")
  valid_580722 = validateParameter(valid_580722, JString, required = false,
                                 default = nil)
  if valid_580722 != nil:
    section.add "fields", valid_580722
  var valid_580723 = query.getOrDefault("quotaUser")
  valid_580723 = validateParameter(valid_580723, JString, required = false,
                                 default = nil)
  if valid_580723 != nil:
    section.add "quotaUser", valid_580723
  var valid_580724 = query.getOrDefault("alt")
  valid_580724 = validateParameter(valid_580724, JString, required = false,
                                 default = newJString("json"))
  if valid_580724 != nil:
    section.add "alt", valid_580724
  var valid_580725 = query.getOrDefault("oauth_token")
  valid_580725 = validateParameter(valid_580725, JString, required = false,
                                 default = nil)
  if valid_580725 != nil:
    section.add "oauth_token", valid_580725
  var valid_580726 = query.getOrDefault("userIp")
  valid_580726 = validateParameter(valid_580726, JString, required = false,
                                 default = nil)
  if valid_580726 != nil:
    section.add "userIp", valid_580726
  var valid_580727 = query.getOrDefault("key")
  valid_580727 = validateParameter(valid_580727, JString, required = false,
                                 default = nil)
  if valid_580727 != nil:
    section.add "key", valid_580727
  var valid_580728 = query.getOrDefault("prettyPrint")
  valid_580728 = validateParameter(valid_580728, JBool, required = false,
                                 default = newJBool(true))
  if valid_580728 != nil:
    section.add "prettyPrint", valid_580728
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580729: Call_AndroidpublisherInappproductsGet_580717;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the in-app product specified.
  ## 
  let valid = call_580729.validator(path, query, header, formData, body)
  let scheme = call_580729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580729.url(scheme.get, call_580729.host, call_580729.base,
                         call_580729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580729, url, valid)

proc call*(call_580730: Call_AndroidpublisherInappproductsGet_580717;
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
  var path_580731 = newJObject()
  var query_580732 = newJObject()
  add(query_580732, "fields", newJString(fields))
  add(path_580731, "packageName", newJString(packageName))
  add(query_580732, "quotaUser", newJString(quotaUser))
  add(query_580732, "alt", newJString(alt))
  add(query_580732, "oauth_token", newJString(oauthToken))
  add(query_580732, "userIp", newJString(userIp))
  add(path_580731, "sku", newJString(sku))
  add(query_580732, "key", newJString(key))
  add(query_580732, "prettyPrint", newJBool(prettyPrint))
  result = call_580730.call(path_580731, query_580732, nil, nil, nil)

var androidpublisherInappproductsGet* = Call_AndroidpublisherInappproductsGet_580717(
    name: "androidpublisherInappproductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsGet_580718,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsGet_580719, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsPatch_580768 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherInappproductsPatch_580770(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsPatch_580769(path: JsonNode;
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
  var valid_580771 = path.getOrDefault("packageName")
  valid_580771 = validateParameter(valid_580771, JString, required = true,
                                 default = nil)
  if valid_580771 != nil:
    section.add "packageName", valid_580771
  var valid_580772 = path.getOrDefault("sku")
  valid_580772 = validateParameter(valid_580772, JString, required = true,
                                 default = nil)
  if valid_580772 != nil:
    section.add "sku", valid_580772
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
  var valid_580773 = query.getOrDefault("fields")
  valid_580773 = validateParameter(valid_580773, JString, required = false,
                                 default = nil)
  if valid_580773 != nil:
    section.add "fields", valid_580773
  var valid_580774 = query.getOrDefault("quotaUser")
  valid_580774 = validateParameter(valid_580774, JString, required = false,
                                 default = nil)
  if valid_580774 != nil:
    section.add "quotaUser", valid_580774
  var valid_580775 = query.getOrDefault("alt")
  valid_580775 = validateParameter(valid_580775, JString, required = false,
                                 default = newJString("json"))
  if valid_580775 != nil:
    section.add "alt", valid_580775
  var valid_580776 = query.getOrDefault("oauth_token")
  valid_580776 = validateParameter(valid_580776, JString, required = false,
                                 default = nil)
  if valid_580776 != nil:
    section.add "oauth_token", valid_580776
  var valid_580777 = query.getOrDefault("userIp")
  valid_580777 = validateParameter(valid_580777, JString, required = false,
                                 default = nil)
  if valid_580777 != nil:
    section.add "userIp", valid_580777
  var valid_580778 = query.getOrDefault("key")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = nil)
  if valid_580778 != nil:
    section.add "key", valid_580778
  var valid_580779 = query.getOrDefault("autoConvertMissingPrices")
  valid_580779 = validateParameter(valid_580779, JBool, required = false, default = nil)
  if valid_580779 != nil:
    section.add "autoConvertMissingPrices", valid_580779
  var valid_580780 = query.getOrDefault("prettyPrint")
  valid_580780 = validateParameter(valid_580780, JBool, required = false,
                                 default = newJBool(true))
  if valid_580780 != nil:
    section.add "prettyPrint", valid_580780
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

proc call*(call_580782: Call_AndroidpublisherInappproductsPatch_580768;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the details of an in-app product. This method supports patch semantics.
  ## 
  let valid = call_580782.validator(path, query, header, formData, body)
  let scheme = call_580782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580782.url(scheme.get, call_580782.host, call_580782.base,
                         call_580782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580782, url, valid)

proc call*(call_580783: Call_AndroidpublisherInappproductsPatch_580768;
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
  var path_580784 = newJObject()
  var query_580785 = newJObject()
  var body_580786 = newJObject()
  add(query_580785, "fields", newJString(fields))
  add(path_580784, "packageName", newJString(packageName))
  add(query_580785, "quotaUser", newJString(quotaUser))
  add(query_580785, "alt", newJString(alt))
  add(query_580785, "oauth_token", newJString(oauthToken))
  add(query_580785, "userIp", newJString(userIp))
  add(path_580784, "sku", newJString(sku))
  add(query_580785, "key", newJString(key))
  add(query_580785, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_580786 = body
  add(query_580785, "prettyPrint", newJBool(prettyPrint))
  result = call_580783.call(path_580784, query_580785, nil, nil, body_580786)

var androidpublisherInappproductsPatch* = Call_AndroidpublisherInappproductsPatch_580768(
    name: "androidpublisherInappproductsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsPatch_580769,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsPatch_580770, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsDelete_580752 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherInappproductsDelete_580754(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsDelete_580753(path: JsonNode;
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
  var valid_580755 = path.getOrDefault("packageName")
  valid_580755 = validateParameter(valid_580755, JString, required = true,
                                 default = nil)
  if valid_580755 != nil:
    section.add "packageName", valid_580755
  var valid_580756 = path.getOrDefault("sku")
  valid_580756 = validateParameter(valid_580756, JString, required = true,
                                 default = nil)
  if valid_580756 != nil:
    section.add "sku", valid_580756
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
  var valid_580757 = query.getOrDefault("fields")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = nil)
  if valid_580757 != nil:
    section.add "fields", valid_580757
  var valid_580758 = query.getOrDefault("quotaUser")
  valid_580758 = validateParameter(valid_580758, JString, required = false,
                                 default = nil)
  if valid_580758 != nil:
    section.add "quotaUser", valid_580758
  var valid_580759 = query.getOrDefault("alt")
  valid_580759 = validateParameter(valid_580759, JString, required = false,
                                 default = newJString("json"))
  if valid_580759 != nil:
    section.add "alt", valid_580759
  var valid_580760 = query.getOrDefault("oauth_token")
  valid_580760 = validateParameter(valid_580760, JString, required = false,
                                 default = nil)
  if valid_580760 != nil:
    section.add "oauth_token", valid_580760
  var valid_580761 = query.getOrDefault("userIp")
  valid_580761 = validateParameter(valid_580761, JString, required = false,
                                 default = nil)
  if valid_580761 != nil:
    section.add "userIp", valid_580761
  var valid_580762 = query.getOrDefault("key")
  valid_580762 = validateParameter(valid_580762, JString, required = false,
                                 default = nil)
  if valid_580762 != nil:
    section.add "key", valid_580762
  var valid_580763 = query.getOrDefault("prettyPrint")
  valid_580763 = validateParameter(valid_580763, JBool, required = false,
                                 default = newJBool(true))
  if valid_580763 != nil:
    section.add "prettyPrint", valid_580763
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580764: Call_AndroidpublisherInappproductsDelete_580752;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an in-app product for an app.
  ## 
  let valid = call_580764.validator(path, query, header, formData, body)
  let scheme = call_580764.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580764.url(scheme.get, call_580764.host, call_580764.base,
                         call_580764.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580764, url, valid)

proc call*(call_580765: Call_AndroidpublisherInappproductsDelete_580752;
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
  var path_580766 = newJObject()
  var query_580767 = newJObject()
  add(query_580767, "fields", newJString(fields))
  add(path_580766, "packageName", newJString(packageName))
  add(query_580767, "quotaUser", newJString(quotaUser))
  add(query_580767, "alt", newJString(alt))
  add(query_580767, "oauth_token", newJString(oauthToken))
  add(query_580767, "userIp", newJString(userIp))
  add(path_580766, "sku", newJString(sku))
  add(query_580767, "key", newJString(key))
  add(query_580767, "prettyPrint", newJBool(prettyPrint))
  result = call_580765.call(path_580766, query_580767, nil, nil, nil)

var androidpublisherInappproductsDelete* = Call_AndroidpublisherInappproductsDelete_580752(
    name: "androidpublisherInappproductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsDelete_580753,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsDelete_580754, schemes: {Scheme.Https})
type
  Call_AndroidpublisherOrdersRefund_580787 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherOrdersRefund_580789(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherOrdersRefund_580788(path: JsonNode; query: JsonNode;
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
  var valid_580790 = path.getOrDefault("packageName")
  valid_580790 = validateParameter(valid_580790, JString, required = true,
                                 default = nil)
  if valid_580790 != nil:
    section.add "packageName", valid_580790
  var valid_580791 = path.getOrDefault("orderId")
  valid_580791 = validateParameter(valid_580791, JString, required = true,
                                 default = nil)
  if valid_580791 != nil:
    section.add "orderId", valid_580791
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
  var valid_580792 = query.getOrDefault("fields")
  valid_580792 = validateParameter(valid_580792, JString, required = false,
                                 default = nil)
  if valid_580792 != nil:
    section.add "fields", valid_580792
  var valid_580793 = query.getOrDefault("quotaUser")
  valid_580793 = validateParameter(valid_580793, JString, required = false,
                                 default = nil)
  if valid_580793 != nil:
    section.add "quotaUser", valid_580793
  var valid_580794 = query.getOrDefault("alt")
  valid_580794 = validateParameter(valid_580794, JString, required = false,
                                 default = newJString("json"))
  if valid_580794 != nil:
    section.add "alt", valid_580794
  var valid_580795 = query.getOrDefault("oauth_token")
  valid_580795 = validateParameter(valid_580795, JString, required = false,
                                 default = nil)
  if valid_580795 != nil:
    section.add "oauth_token", valid_580795
  var valid_580796 = query.getOrDefault("userIp")
  valid_580796 = validateParameter(valid_580796, JString, required = false,
                                 default = nil)
  if valid_580796 != nil:
    section.add "userIp", valid_580796
  var valid_580797 = query.getOrDefault("key")
  valid_580797 = validateParameter(valid_580797, JString, required = false,
                                 default = nil)
  if valid_580797 != nil:
    section.add "key", valid_580797
  var valid_580798 = query.getOrDefault("revoke")
  valid_580798 = validateParameter(valid_580798, JBool, required = false, default = nil)
  if valid_580798 != nil:
    section.add "revoke", valid_580798
  var valid_580799 = query.getOrDefault("prettyPrint")
  valid_580799 = validateParameter(valid_580799, JBool, required = false,
                                 default = newJBool(true))
  if valid_580799 != nil:
    section.add "prettyPrint", valid_580799
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580800: Call_AndroidpublisherOrdersRefund_580787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Refund a user's subscription or in-app purchase order.
  ## 
  let valid = call_580800.validator(path, query, header, formData, body)
  let scheme = call_580800.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580800.url(scheme.get, call_580800.host, call_580800.base,
                         call_580800.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580800, url, valid)

proc call*(call_580801: Call_AndroidpublisherOrdersRefund_580787;
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
  var path_580802 = newJObject()
  var query_580803 = newJObject()
  add(query_580803, "fields", newJString(fields))
  add(path_580802, "packageName", newJString(packageName))
  add(query_580803, "quotaUser", newJString(quotaUser))
  add(query_580803, "alt", newJString(alt))
  add(query_580803, "oauth_token", newJString(oauthToken))
  add(query_580803, "userIp", newJString(userIp))
  add(path_580802, "orderId", newJString(orderId))
  add(query_580803, "key", newJString(key))
  add(query_580803, "revoke", newJBool(revoke))
  add(query_580803, "prettyPrint", newJBool(prettyPrint))
  result = call_580801.call(path_580802, query_580803, nil, nil, nil)

var androidpublisherOrdersRefund* = Call_AndroidpublisherOrdersRefund_580787(
    name: "androidpublisherOrdersRefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/orders/{orderId}:refund",
    validator: validate_AndroidpublisherOrdersRefund_580788,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherOrdersRefund_580789, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesProductsGet_580804 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherPurchasesProductsGet_580806(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesProductsGet_580805(path: JsonNode;
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
  var valid_580807 = path.getOrDefault("packageName")
  valid_580807 = validateParameter(valid_580807, JString, required = true,
                                 default = nil)
  if valid_580807 != nil:
    section.add "packageName", valid_580807
  var valid_580808 = path.getOrDefault("token")
  valid_580808 = validateParameter(valid_580808, JString, required = true,
                                 default = nil)
  if valid_580808 != nil:
    section.add "token", valid_580808
  var valid_580809 = path.getOrDefault("productId")
  valid_580809 = validateParameter(valid_580809, JString, required = true,
                                 default = nil)
  if valid_580809 != nil:
    section.add "productId", valid_580809
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
  var valid_580810 = query.getOrDefault("fields")
  valid_580810 = validateParameter(valid_580810, JString, required = false,
                                 default = nil)
  if valid_580810 != nil:
    section.add "fields", valid_580810
  var valid_580811 = query.getOrDefault("quotaUser")
  valid_580811 = validateParameter(valid_580811, JString, required = false,
                                 default = nil)
  if valid_580811 != nil:
    section.add "quotaUser", valid_580811
  var valid_580812 = query.getOrDefault("alt")
  valid_580812 = validateParameter(valid_580812, JString, required = false,
                                 default = newJString("json"))
  if valid_580812 != nil:
    section.add "alt", valid_580812
  var valid_580813 = query.getOrDefault("oauth_token")
  valid_580813 = validateParameter(valid_580813, JString, required = false,
                                 default = nil)
  if valid_580813 != nil:
    section.add "oauth_token", valid_580813
  var valid_580814 = query.getOrDefault("userIp")
  valid_580814 = validateParameter(valid_580814, JString, required = false,
                                 default = nil)
  if valid_580814 != nil:
    section.add "userIp", valid_580814
  var valid_580815 = query.getOrDefault("key")
  valid_580815 = validateParameter(valid_580815, JString, required = false,
                                 default = nil)
  if valid_580815 != nil:
    section.add "key", valid_580815
  var valid_580816 = query.getOrDefault("prettyPrint")
  valid_580816 = validateParameter(valid_580816, JBool, required = false,
                                 default = newJBool(true))
  if valid_580816 != nil:
    section.add "prettyPrint", valid_580816
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580817: Call_AndroidpublisherPurchasesProductsGet_580804;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks the purchase and consumption status of an inapp item.
  ## 
  let valid = call_580817.validator(path, query, header, formData, body)
  let scheme = call_580817.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580817.url(scheme.get, call_580817.host, call_580817.base,
                         call_580817.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580817, url, valid)

proc call*(call_580818: Call_AndroidpublisherPurchasesProductsGet_580804;
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
  var path_580819 = newJObject()
  var query_580820 = newJObject()
  add(query_580820, "fields", newJString(fields))
  add(path_580819, "packageName", newJString(packageName))
  add(query_580820, "quotaUser", newJString(quotaUser))
  add(query_580820, "alt", newJString(alt))
  add(query_580820, "oauth_token", newJString(oauthToken))
  add(query_580820, "userIp", newJString(userIp))
  add(query_580820, "key", newJString(key))
  add(path_580819, "token", newJString(token))
  add(path_580819, "productId", newJString(productId))
  add(query_580820, "prettyPrint", newJBool(prettyPrint))
  result = call_580818.call(path_580819, query_580820, nil, nil, nil)

var androidpublisherPurchasesProductsGet* = Call_AndroidpublisherPurchasesProductsGet_580804(
    name: "androidpublisherPurchasesProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/purchases/products/{productId}/tokens/{token}",
    validator: validate_AndroidpublisherPurchasesProductsGet_580805,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesProductsGet_580806, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsGet_580821 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherPurchasesSubscriptionsGet_580823(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsGet_580822(path: JsonNode;
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
  var valid_580824 = path.getOrDefault("packageName")
  valid_580824 = validateParameter(valid_580824, JString, required = true,
                                 default = nil)
  if valid_580824 != nil:
    section.add "packageName", valid_580824
  var valid_580825 = path.getOrDefault("subscriptionId")
  valid_580825 = validateParameter(valid_580825, JString, required = true,
                                 default = nil)
  if valid_580825 != nil:
    section.add "subscriptionId", valid_580825
  var valid_580826 = path.getOrDefault("token")
  valid_580826 = validateParameter(valid_580826, JString, required = true,
                                 default = nil)
  if valid_580826 != nil:
    section.add "token", valid_580826
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
  var valid_580827 = query.getOrDefault("fields")
  valid_580827 = validateParameter(valid_580827, JString, required = false,
                                 default = nil)
  if valid_580827 != nil:
    section.add "fields", valid_580827
  var valid_580828 = query.getOrDefault("quotaUser")
  valid_580828 = validateParameter(valid_580828, JString, required = false,
                                 default = nil)
  if valid_580828 != nil:
    section.add "quotaUser", valid_580828
  var valid_580829 = query.getOrDefault("alt")
  valid_580829 = validateParameter(valid_580829, JString, required = false,
                                 default = newJString("json"))
  if valid_580829 != nil:
    section.add "alt", valid_580829
  var valid_580830 = query.getOrDefault("oauth_token")
  valid_580830 = validateParameter(valid_580830, JString, required = false,
                                 default = nil)
  if valid_580830 != nil:
    section.add "oauth_token", valid_580830
  var valid_580831 = query.getOrDefault("userIp")
  valid_580831 = validateParameter(valid_580831, JString, required = false,
                                 default = nil)
  if valid_580831 != nil:
    section.add "userIp", valid_580831
  var valid_580832 = query.getOrDefault("key")
  valid_580832 = validateParameter(valid_580832, JString, required = false,
                                 default = nil)
  if valid_580832 != nil:
    section.add "key", valid_580832
  var valid_580833 = query.getOrDefault("prettyPrint")
  valid_580833 = validateParameter(valid_580833, JBool, required = false,
                                 default = newJBool(true))
  if valid_580833 != nil:
    section.add "prettyPrint", valid_580833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580834: Call_AndroidpublisherPurchasesSubscriptionsGet_580821;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ## 
  let valid = call_580834.validator(path, query, header, formData, body)
  let scheme = call_580834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580834.url(scheme.get, call_580834.host, call_580834.base,
                         call_580834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580834, url, valid)

proc call*(call_580835: Call_AndroidpublisherPurchasesSubscriptionsGet_580821;
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
  var path_580836 = newJObject()
  var query_580837 = newJObject()
  add(query_580837, "fields", newJString(fields))
  add(path_580836, "packageName", newJString(packageName))
  add(query_580837, "quotaUser", newJString(quotaUser))
  add(query_580837, "alt", newJString(alt))
  add(path_580836, "subscriptionId", newJString(subscriptionId))
  add(query_580837, "oauth_token", newJString(oauthToken))
  add(query_580837, "userIp", newJString(userIp))
  add(query_580837, "key", newJString(key))
  add(path_580836, "token", newJString(token))
  add(query_580837, "prettyPrint", newJBool(prettyPrint))
  result = call_580835.call(path_580836, query_580837, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsGet* = Call_AndroidpublisherPurchasesSubscriptionsGet_580821(
    name: "androidpublisherPurchasesSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}",
    validator: validate_AndroidpublisherPurchasesSubscriptionsGet_580822,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsGet_580823,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsCancel_580838 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherPurchasesSubscriptionsCancel_580840(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsCancel_580839(path: JsonNode;
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
  var valid_580841 = path.getOrDefault("packageName")
  valid_580841 = validateParameter(valid_580841, JString, required = true,
                                 default = nil)
  if valid_580841 != nil:
    section.add "packageName", valid_580841
  var valid_580842 = path.getOrDefault("subscriptionId")
  valid_580842 = validateParameter(valid_580842, JString, required = true,
                                 default = nil)
  if valid_580842 != nil:
    section.add "subscriptionId", valid_580842
  var valid_580843 = path.getOrDefault("token")
  valid_580843 = validateParameter(valid_580843, JString, required = true,
                                 default = nil)
  if valid_580843 != nil:
    section.add "token", valid_580843
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
  var valid_580844 = query.getOrDefault("fields")
  valid_580844 = validateParameter(valid_580844, JString, required = false,
                                 default = nil)
  if valid_580844 != nil:
    section.add "fields", valid_580844
  var valid_580845 = query.getOrDefault("quotaUser")
  valid_580845 = validateParameter(valid_580845, JString, required = false,
                                 default = nil)
  if valid_580845 != nil:
    section.add "quotaUser", valid_580845
  var valid_580846 = query.getOrDefault("alt")
  valid_580846 = validateParameter(valid_580846, JString, required = false,
                                 default = newJString("json"))
  if valid_580846 != nil:
    section.add "alt", valid_580846
  var valid_580847 = query.getOrDefault("oauth_token")
  valid_580847 = validateParameter(valid_580847, JString, required = false,
                                 default = nil)
  if valid_580847 != nil:
    section.add "oauth_token", valid_580847
  var valid_580848 = query.getOrDefault("userIp")
  valid_580848 = validateParameter(valid_580848, JString, required = false,
                                 default = nil)
  if valid_580848 != nil:
    section.add "userIp", valid_580848
  var valid_580849 = query.getOrDefault("key")
  valid_580849 = validateParameter(valid_580849, JString, required = false,
                                 default = nil)
  if valid_580849 != nil:
    section.add "key", valid_580849
  var valid_580850 = query.getOrDefault("prettyPrint")
  valid_580850 = validateParameter(valid_580850, JBool, required = false,
                                 default = newJBool(true))
  if valid_580850 != nil:
    section.add "prettyPrint", valid_580850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580851: Call_AndroidpublisherPurchasesSubscriptionsCancel_580838;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ## 
  let valid = call_580851.validator(path, query, header, formData, body)
  let scheme = call_580851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580851.url(scheme.get, call_580851.host, call_580851.base,
                         call_580851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580851, url, valid)

proc call*(call_580852: Call_AndroidpublisherPurchasesSubscriptionsCancel_580838;
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
  var path_580853 = newJObject()
  var query_580854 = newJObject()
  add(query_580854, "fields", newJString(fields))
  add(path_580853, "packageName", newJString(packageName))
  add(query_580854, "quotaUser", newJString(quotaUser))
  add(query_580854, "alt", newJString(alt))
  add(path_580853, "subscriptionId", newJString(subscriptionId))
  add(query_580854, "oauth_token", newJString(oauthToken))
  add(query_580854, "userIp", newJString(userIp))
  add(query_580854, "key", newJString(key))
  add(path_580853, "token", newJString(token))
  add(query_580854, "prettyPrint", newJBool(prettyPrint))
  result = call_580852.call(path_580853, query_580854, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsCancel* = Call_AndroidpublisherPurchasesSubscriptionsCancel_580838(
    name: "androidpublisherPurchasesSubscriptionsCancel",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:cancel",
    validator: validate_AndroidpublisherPurchasesSubscriptionsCancel_580839,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsCancel_580840,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsDefer_580855 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherPurchasesSubscriptionsDefer_580857(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsDefer_580856(path: JsonNode;
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
  var valid_580858 = path.getOrDefault("packageName")
  valid_580858 = validateParameter(valid_580858, JString, required = true,
                                 default = nil)
  if valid_580858 != nil:
    section.add "packageName", valid_580858
  var valid_580859 = path.getOrDefault("subscriptionId")
  valid_580859 = validateParameter(valid_580859, JString, required = true,
                                 default = nil)
  if valid_580859 != nil:
    section.add "subscriptionId", valid_580859
  var valid_580860 = path.getOrDefault("token")
  valid_580860 = validateParameter(valid_580860, JString, required = true,
                                 default = nil)
  if valid_580860 != nil:
    section.add "token", valid_580860
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
  var valid_580861 = query.getOrDefault("fields")
  valid_580861 = validateParameter(valid_580861, JString, required = false,
                                 default = nil)
  if valid_580861 != nil:
    section.add "fields", valid_580861
  var valid_580862 = query.getOrDefault("quotaUser")
  valid_580862 = validateParameter(valid_580862, JString, required = false,
                                 default = nil)
  if valid_580862 != nil:
    section.add "quotaUser", valid_580862
  var valid_580863 = query.getOrDefault("alt")
  valid_580863 = validateParameter(valid_580863, JString, required = false,
                                 default = newJString("json"))
  if valid_580863 != nil:
    section.add "alt", valid_580863
  var valid_580864 = query.getOrDefault("oauth_token")
  valid_580864 = validateParameter(valid_580864, JString, required = false,
                                 default = nil)
  if valid_580864 != nil:
    section.add "oauth_token", valid_580864
  var valid_580865 = query.getOrDefault("userIp")
  valid_580865 = validateParameter(valid_580865, JString, required = false,
                                 default = nil)
  if valid_580865 != nil:
    section.add "userIp", valid_580865
  var valid_580866 = query.getOrDefault("key")
  valid_580866 = validateParameter(valid_580866, JString, required = false,
                                 default = nil)
  if valid_580866 != nil:
    section.add "key", valid_580866
  var valid_580867 = query.getOrDefault("prettyPrint")
  valid_580867 = validateParameter(valid_580867, JBool, required = false,
                                 default = newJBool(true))
  if valid_580867 != nil:
    section.add "prettyPrint", valid_580867
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

proc call*(call_580869: Call_AndroidpublisherPurchasesSubscriptionsDefer_580855;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Defers a user's subscription purchase until a specified future expiration time.
  ## 
  let valid = call_580869.validator(path, query, header, formData, body)
  let scheme = call_580869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580869.url(scheme.get, call_580869.host, call_580869.base,
                         call_580869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580869, url, valid)

proc call*(call_580870: Call_AndroidpublisherPurchasesSubscriptionsDefer_580855;
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
  var path_580871 = newJObject()
  var query_580872 = newJObject()
  var body_580873 = newJObject()
  add(query_580872, "fields", newJString(fields))
  add(path_580871, "packageName", newJString(packageName))
  add(query_580872, "quotaUser", newJString(quotaUser))
  add(query_580872, "alt", newJString(alt))
  add(path_580871, "subscriptionId", newJString(subscriptionId))
  add(query_580872, "oauth_token", newJString(oauthToken))
  add(query_580872, "userIp", newJString(userIp))
  add(query_580872, "key", newJString(key))
  add(path_580871, "token", newJString(token))
  if body != nil:
    body_580873 = body
  add(query_580872, "prettyPrint", newJBool(prettyPrint))
  result = call_580870.call(path_580871, query_580872, nil, nil, body_580873)

var androidpublisherPurchasesSubscriptionsDefer* = Call_AndroidpublisherPurchasesSubscriptionsDefer_580855(
    name: "androidpublisherPurchasesSubscriptionsDefer",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:defer",
    validator: validate_AndroidpublisherPurchasesSubscriptionsDefer_580856,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsDefer_580857,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsRefund_580874 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherPurchasesSubscriptionsRefund_580876(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsRefund_580875(path: JsonNode;
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
  var valid_580877 = path.getOrDefault("packageName")
  valid_580877 = validateParameter(valid_580877, JString, required = true,
                                 default = nil)
  if valid_580877 != nil:
    section.add "packageName", valid_580877
  var valid_580878 = path.getOrDefault("subscriptionId")
  valid_580878 = validateParameter(valid_580878, JString, required = true,
                                 default = nil)
  if valid_580878 != nil:
    section.add "subscriptionId", valid_580878
  var valid_580879 = path.getOrDefault("token")
  valid_580879 = validateParameter(valid_580879, JString, required = true,
                                 default = nil)
  if valid_580879 != nil:
    section.add "token", valid_580879
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
  var valid_580880 = query.getOrDefault("fields")
  valid_580880 = validateParameter(valid_580880, JString, required = false,
                                 default = nil)
  if valid_580880 != nil:
    section.add "fields", valid_580880
  var valid_580881 = query.getOrDefault("quotaUser")
  valid_580881 = validateParameter(valid_580881, JString, required = false,
                                 default = nil)
  if valid_580881 != nil:
    section.add "quotaUser", valid_580881
  var valid_580882 = query.getOrDefault("alt")
  valid_580882 = validateParameter(valid_580882, JString, required = false,
                                 default = newJString("json"))
  if valid_580882 != nil:
    section.add "alt", valid_580882
  var valid_580883 = query.getOrDefault("oauth_token")
  valid_580883 = validateParameter(valid_580883, JString, required = false,
                                 default = nil)
  if valid_580883 != nil:
    section.add "oauth_token", valid_580883
  var valid_580884 = query.getOrDefault("userIp")
  valid_580884 = validateParameter(valid_580884, JString, required = false,
                                 default = nil)
  if valid_580884 != nil:
    section.add "userIp", valid_580884
  var valid_580885 = query.getOrDefault("key")
  valid_580885 = validateParameter(valid_580885, JString, required = false,
                                 default = nil)
  if valid_580885 != nil:
    section.add "key", valid_580885
  var valid_580886 = query.getOrDefault("prettyPrint")
  valid_580886 = validateParameter(valid_580886, JBool, required = false,
                                 default = newJBool(true))
  if valid_580886 != nil:
    section.add "prettyPrint", valid_580886
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580887: Call_AndroidpublisherPurchasesSubscriptionsRefund_580874;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refunds a user's subscription purchase, but the subscription remains valid until its expiration time and it will continue to recur.
  ## 
  let valid = call_580887.validator(path, query, header, formData, body)
  let scheme = call_580887.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580887.url(scheme.get, call_580887.host, call_580887.base,
                         call_580887.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580887, url, valid)

proc call*(call_580888: Call_AndroidpublisherPurchasesSubscriptionsRefund_580874;
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
  var path_580889 = newJObject()
  var query_580890 = newJObject()
  add(query_580890, "fields", newJString(fields))
  add(path_580889, "packageName", newJString(packageName))
  add(query_580890, "quotaUser", newJString(quotaUser))
  add(query_580890, "alt", newJString(alt))
  add(path_580889, "subscriptionId", newJString(subscriptionId))
  add(query_580890, "oauth_token", newJString(oauthToken))
  add(query_580890, "userIp", newJString(userIp))
  add(query_580890, "key", newJString(key))
  add(path_580889, "token", newJString(token))
  add(query_580890, "prettyPrint", newJBool(prettyPrint))
  result = call_580888.call(path_580889, query_580890, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsRefund* = Call_AndroidpublisherPurchasesSubscriptionsRefund_580874(
    name: "androidpublisherPurchasesSubscriptionsRefund",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:refund",
    validator: validate_AndroidpublisherPurchasesSubscriptionsRefund_580875,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsRefund_580876,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsRevoke_580891 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherPurchasesSubscriptionsRevoke_580893(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsRevoke_580892(path: JsonNode;
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
  var valid_580894 = path.getOrDefault("packageName")
  valid_580894 = validateParameter(valid_580894, JString, required = true,
                                 default = nil)
  if valid_580894 != nil:
    section.add "packageName", valid_580894
  var valid_580895 = path.getOrDefault("subscriptionId")
  valid_580895 = validateParameter(valid_580895, JString, required = true,
                                 default = nil)
  if valid_580895 != nil:
    section.add "subscriptionId", valid_580895
  var valid_580896 = path.getOrDefault("token")
  valid_580896 = validateParameter(valid_580896, JString, required = true,
                                 default = nil)
  if valid_580896 != nil:
    section.add "token", valid_580896
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
  var valid_580897 = query.getOrDefault("fields")
  valid_580897 = validateParameter(valid_580897, JString, required = false,
                                 default = nil)
  if valid_580897 != nil:
    section.add "fields", valid_580897
  var valid_580898 = query.getOrDefault("quotaUser")
  valid_580898 = validateParameter(valid_580898, JString, required = false,
                                 default = nil)
  if valid_580898 != nil:
    section.add "quotaUser", valid_580898
  var valid_580899 = query.getOrDefault("alt")
  valid_580899 = validateParameter(valid_580899, JString, required = false,
                                 default = newJString("json"))
  if valid_580899 != nil:
    section.add "alt", valid_580899
  var valid_580900 = query.getOrDefault("oauth_token")
  valid_580900 = validateParameter(valid_580900, JString, required = false,
                                 default = nil)
  if valid_580900 != nil:
    section.add "oauth_token", valid_580900
  var valid_580901 = query.getOrDefault("userIp")
  valid_580901 = validateParameter(valid_580901, JString, required = false,
                                 default = nil)
  if valid_580901 != nil:
    section.add "userIp", valid_580901
  var valid_580902 = query.getOrDefault("key")
  valid_580902 = validateParameter(valid_580902, JString, required = false,
                                 default = nil)
  if valid_580902 != nil:
    section.add "key", valid_580902
  var valid_580903 = query.getOrDefault("prettyPrint")
  valid_580903 = validateParameter(valid_580903, JBool, required = false,
                                 default = newJBool(true))
  if valid_580903 != nil:
    section.add "prettyPrint", valid_580903
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580904: Call_AndroidpublisherPurchasesSubscriptionsRevoke_580891;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refunds and immediately revokes a user's subscription purchase. Access to the subscription will be terminated immediately and it will stop recurring.
  ## 
  let valid = call_580904.validator(path, query, header, formData, body)
  let scheme = call_580904.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580904.url(scheme.get, call_580904.host, call_580904.base,
                         call_580904.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580904, url, valid)

proc call*(call_580905: Call_AndroidpublisherPurchasesSubscriptionsRevoke_580891;
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
  var path_580906 = newJObject()
  var query_580907 = newJObject()
  add(query_580907, "fields", newJString(fields))
  add(path_580906, "packageName", newJString(packageName))
  add(query_580907, "quotaUser", newJString(quotaUser))
  add(query_580907, "alt", newJString(alt))
  add(path_580906, "subscriptionId", newJString(subscriptionId))
  add(query_580907, "oauth_token", newJString(oauthToken))
  add(query_580907, "userIp", newJString(userIp))
  add(query_580907, "key", newJString(key))
  add(path_580906, "token", newJString(token))
  add(query_580907, "prettyPrint", newJBool(prettyPrint))
  result = call_580905.call(path_580906, query_580907, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsRevoke* = Call_AndroidpublisherPurchasesSubscriptionsRevoke_580891(
    name: "androidpublisherPurchasesSubscriptionsRevoke",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:revoke",
    validator: validate_AndroidpublisherPurchasesSubscriptionsRevoke_580892,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsRevoke_580893,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesVoidedpurchasesList_580908 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherPurchasesVoidedpurchasesList_580910(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesVoidedpurchasesList_580909(path: JsonNode;
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
  var valid_580911 = path.getOrDefault("packageName")
  valid_580911 = validateParameter(valid_580911, JString, required = true,
                                 default = nil)
  if valid_580911 != nil:
    section.add "packageName", valid_580911
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
  var valid_580912 = query.getOrDefault("token")
  valid_580912 = validateParameter(valid_580912, JString, required = false,
                                 default = nil)
  if valid_580912 != nil:
    section.add "token", valid_580912
  var valid_580913 = query.getOrDefault("fields")
  valid_580913 = validateParameter(valid_580913, JString, required = false,
                                 default = nil)
  if valid_580913 != nil:
    section.add "fields", valid_580913
  var valid_580914 = query.getOrDefault("quotaUser")
  valid_580914 = validateParameter(valid_580914, JString, required = false,
                                 default = nil)
  if valid_580914 != nil:
    section.add "quotaUser", valid_580914
  var valid_580915 = query.getOrDefault("alt")
  valid_580915 = validateParameter(valid_580915, JString, required = false,
                                 default = newJString("json"))
  if valid_580915 != nil:
    section.add "alt", valid_580915
  var valid_580916 = query.getOrDefault("oauth_token")
  valid_580916 = validateParameter(valid_580916, JString, required = false,
                                 default = nil)
  if valid_580916 != nil:
    section.add "oauth_token", valid_580916
  var valid_580917 = query.getOrDefault("endTime")
  valid_580917 = validateParameter(valid_580917, JString, required = false,
                                 default = nil)
  if valid_580917 != nil:
    section.add "endTime", valid_580917
  var valid_580918 = query.getOrDefault("userIp")
  valid_580918 = validateParameter(valid_580918, JString, required = false,
                                 default = nil)
  if valid_580918 != nil:
    section.add "userIp", valid_580918
  var valid_580919 = query.getOrDefault("maxResults")
  valid_580919 = validateParameter(valid_580919, JInt, required = false, default = nil)
  if valid_580919 != nil:
    section.add "maxResults", valid_580919
  var valid_580920 = query.getOrDefault("key")
  valid_580920 = validateParameter(valid_580920, JString, required = false,
                                 default = nil)
  if valid_580920 != nil:
    section.add "key", valid_580920
  var valid_580921 = query.getOrDefault("prettyPrint")
  valid_580921 = validateParameter(valid_580921, JBool, required = false,
                                 default = newJBool(true))
  if valid_580921 != nil:
    section.add "prettyPrint", valid_580921
  var valid_580922 = query.getOrDefault("startTime")
  valid_580922 = validateParameter(valid_580922, JString, required = false,
                                 default = nil)
  if valid_580922 != nil:
    section.add "startTime", valid_580922
  var valid_580923 = query.getOrDefault("startIndex")
  valid_580923 = validateParameter(valid_580923, JInt, required = false, default = nil)
  if valid_580923 != nil:
    section.add "startIndex", valid_580923
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580924: Call_AndroidpublisherPurchasesVoidedpurchasesList_580908;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the purchases that were canceled, refunded or charged-back.
  ## 
  let valid = call_580924.validator(path, query, header, formData, body)
  let scheme = call_580924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580924.url(scheme.get, call_580924.host, call_580924.base,
                         call_580924.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580924, url, valid)

proc call*(call_580925: Call_AndroidpublisherPurchasesVoidedpurchasesList_580908;
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
  var path_580926 = newJObject()
  var query_580927 = newJObject()
  add(query_580927, "token", newJString(token))
  add(query_580927, "fields", newJString(fields))
  add(path_580926, "packageName", newJString(packageName))
  add(query_580927, "quotaUser", newJString(quotaUser))
  add(query_580927, "alt", newJString(alt))
  add(query_580927, "oauth_token", newJString(oauthToken))
  add(query_580927, "endTime", newJString(endTime))
  add(query_580927, "userIp", newJString(userIp))
  add(query_580927, "maxResults", newJInt(maxResults))
  add(query_580927, "key", newJString(key))
  add(query_580927, "prettyPrint", newJBool(prettyPrint))
  add(query_580927, "startTime", newJString(startTime))
  add(query_580927, "startIndex", newJInt(startIndex))
  result = call_580925.call(path_580926, query_580927, nil, nil, nil)

var androidpublisherPurchasesVoidedpurchasesList* = Call_AndroidpublisherPurchasesVoidedpurchasesList_580908(
    name: "androidpublisherPurchasesVoidedpurchasesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{packageName}/purchases/voidedpurchases",
    validator: validate_AndroidpublisherPurchasesVoidedpurchasesList_580909,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesVoidedpurchasesList_580910,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsList_580928 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherReviewsList_580930(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherReviewsList_580929(path: JsonNode; query: JsonNode;
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
  var valid_580931 = path.getOrDefault("packageName")
  valid_580931 = validateParameter(valid_580931, JString, required = true,
                                 default = nil)
  if valid_580931 != nil:
    section.add "packageName", valid_580931
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
  var valid_580932 = query.getOrDefault("translationLanguage")
  valid_580932 = validateParameter(valid_580932, JString, required = false,
                                 default = nil)
  if valid_580932 != nil:
    section.add "translationLanguage", valid_580932
  var valid_580933 = query.getOrDefault("token")
  valid_580933 = validateParameter(valid_580933, JString, required = false,
                                 default = nil)
  if valid_580933 != nil:
    section.add "token", valid_580933
  var valid_580934 = query.getOrDefault("fields")
  valid_580934 = validateParameter(valid_580934, JString, required = false,
                                 default = nil)
  if valid_580934 != nil:
    section.add "fields", valid_580934
  var valid_580935 = query.getOrDefault("quotaUser")
  valid_580935 = validateParameter(valid_580935, JString, required = false,
                                 default = nil)
  if valid_580935 != nil:
    section.add "quotaUser", valid_580935
  var valid_580936 = query.getOrDefault("alt")
  valid_580936 = validateParameter(valid_580936, JString, required = false,
                                 default = newJString("json"))
  if valid_580936 != nil:
    section.add "alt", valid_580936
  var valid_580937 = query.getOrDefault("oauth_token")
  valid_580937 = validateParameter(valid_580937, JString, required = false,
                                 default = nil)
  if valid_580937 != nil:
    section.add "oauth_token", valid_580937
  var valid_580938 = query.getOrDefault("userIp")
  valid_580938 = validateParameter(valid_580938, JString, required = false,
                                 default = nil)
  if valid_580938 != nil:
    section.add "userIp", valid_580938
  var valid_580939 = query.getOrDefault("maxResults")
  valid_580939 = validateParameter(valid_580939, JInt, required = false, default = nil)
  if valid_580939 != nil:
    section.add "maxResults", valid_580939
  var valid_580940 = query.getOrDefault("key")
  valid_580940 = validateParameter(valid_580940, JString, required = false,
                                 default = nil)
  if valid_580940 != nil:
    section.add "key", valid_580940
  var valid_580941 = query.getOrDefault("prettyPrint")
  valid_580941 = validateParameter(valid_580941, JBool, required = false,
                                 default = newJBool(true))
  if valid_580941 != nil:
    section.add "prettyPrint", valid_580941
  var valid_580942 = query.getOrDefault("startIndex")
  valid_580942 = validateParameter(valid_580942, JInt, required = false, default = nil)
  if valid_580942 != nil:
    section.add "startIndex", valid_580942
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580943: Call_AndroidpublisherReviewsList_580928; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of reviews. Only reviews from last week will be returned.
  ## 
  let valid = call_580943.validator(path, query, header, formData, body)
  let scheme = call_580943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580943.url(scheme.get, call_580943.host, call_580943.base,
                         call_580943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580943, url, valid)

proc call*(call_580944: Call_AndroidpublisherReviewsList_580928;
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
  var path_580945 = newJObject()
  var query_580946 = newJObject()
  add(query_580946, "translationLanguage", newJString(translationLanguage))
  add(query_580946, "token", newJString(token))
  add(query_580946, "fields", newJString(fields))
  add(path_580945, "packageName", newJString(packageName))
  add(query_580946, "quotaUser", newJString(quotaUser))
  add(query_580946, "alt", newJString(alt))
  add(query_580946, "oauth_token", newJString(oauthToken))
  add(query_580946, "userIp", newJString(userIp))
  add(query_580946, "maxResults", newJInt(maxResults))
  add(query_580946, "key", newJString(key))
  add(query_580946, "prettyPrint", newJBool(prettyPrint))
  add(query_580946, "startIndex", newJInt(startIndex))
  result = call_580944.call(path_580945, query_580946, nil, nil, nil)

var androidpublisherReviewsList* = Call_AndroidpublisherReviewsList_580928(
    name: "androidpublisherReviewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/reviews",
    validator: validate_AndroidpublisherReviewsList_580929,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherReviewsList_580930, schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsGet_580947 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherReviewsGet_580949(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherReviewsGet_580948(path: JsonNode; query: JsonNode;
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
  var valid_580950 = path.getOrDefault("packageName")
  valid_580950 = validateParameter(valid_580950, JString, required = true,
                                 default = nil)
  if valid_580950 != nil:
    section.add "packageName", valid_580950
  var valid_580951 = path.getOrDefault("reviewId")
  valid_580951 = validateParameter(valid_580951, JString, required = true,
                                 default = nil)
  if valid_580951 != nil:
    section.add "reviewId", valid_580951
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
  var valid_580952 = query.getOrDefault("translationLanguage")
  valid_580952 = validateParameter(valid_580952, JString, required = false,
                                 default = nil)
  if valid_580952 != nil:
    section.add "translationLanguage", valid_580952
  var valid_580953 = query.getOrDefault("fields")
  valid_580953 = validateParameter(valid_580953, JString, required = false,
                                 default = nil)
  if valid_580953 != nil:
    section.add "fields", valid_580953
  var valid_580954 = query.getOrDefault("quotaUser")
  valid_580954 = validateParameter(valid_580954, JString, required = false,
                                 default = nil)
  if valid_580954 != nil:
    section.add "quotaUser", valid_580954
  var valid_580955 = query.getOrDefault("alt")
  valid_580955 = validateParameter(valid_580955, JString, required = false,
                                 default = newJString("json"))
  if valid_580955 != nil:
    section.add "alt", valid_580955
  var valid_580956 = query.getOrDefault("oauth_token")
  valid_580956 = validateParameter(valid_580956, JString, required = false,
                                 default = nil)
  if valid_580956 != nil:
    section.add "oauth_token", valid_580956
  var valid_580957 = query.getOrDefault("userIp")
  valid_580957 = validateParameter(valid_580957, JString, required = false,
                                 default = nil)
  if valid_580957 != nil:
    section.add "userIp", valid_580957
  var valid_580958 = query.getOrDefault("key")
  valid_580958 = validateParameter(valid_580958, JString, required = false,
                                 default = nil)
  if valid_580958 != nil:
    section.add "key", valid_580958
  var valid_580959 = query.getOrDefault("prettyPrint")
  valid_580959 = validateParameter(valid_580959, JBool, required = false,
                                 default = newJBool(true))
  if valid_580959 != nil:
    section.add "prettyPrint", valid_580959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580960: Call_AndroidpublisherReviewsGet_580947; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a single review.
  ## 
  let valid = call_580960.validator(path, query, header, formData, body)
  let scheme = call_580960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580960.url(scheme.get, call_580960.host, call_580960.base,
                         call_580960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580960, url, valid)

proc call*(call_580961: Call_AndroidpublisherReviewsGet_580947;
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
  var path_580962 = newJObject()
  var query_580963 = newJObject()
  add(query_580963, "translationLanguage", newJString(translationLanguage))
  add(query_580963, "fields", newJString(fields))
  add(path_580962, "packageName", newJString(packageName))
  add(query_580963, "quotaUser", newJString(quotaUser))
  add(query_580963, "alt", newJString(alt))
  add(query_580963, "oauth_token", newJString(oauthToken))
  add(path_580962, "reviewId", newJString(reviewId))
  add(query_580963, "userIp", newJString(userIp))
  add(query_580963, "key", newJString(key))
  add(query_580963, "prettyPrint", newJBool(prettyPrint))
  result = call_580961.call(path_580962, query_580963, nil, nil, nil)

var androidpublisherReviewsGet* = Call_AndroidpublisherReviewsGet_580947(
    name: "androidpublisherReviewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/reviews/{reviewId}",
    validator: validate_AndroidpublisherReviewsGet_580948,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherReviewsGet_580949, schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsReply_580964 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherReviewsReply_580966(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherReviewsReply_580965(path: JsonNode; query: JsonNode;
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
  var valid_580967 = path.getOrDefault("packageName")
  valid_580967 = validateParameter(valid_580967, JString, required = true,
                                 default = nil)
  if valid_580967 != nil:
    section.add "packageName", valid_580967
  var valid_580968 = path.getOrDefault("reviewId")
  valid_580968 = validateParameter(valid_580968, JString, required = true,
                                 default = nil)
  if valid_580968 != nil:
    section.add "reviewId", valid_580968
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
  var valid_580969 = query.getOrDefault("fields")
  valid_580969 = validateParameter(valid_580969, JString, required = false,
                                 default = nil)
  if valid_580969 != nil:
    section.add "fields", valid_580969
  var valid_580970 = query.getOrDefault("quotaUser")
  valid_580970 = validateParameter(valid_580970, JString, required = false,
                                 default = nil)
  if valid_580970 != nil:
    section.add "quotaUser", valid_580970
  var valid_580971 = query.getOrDefault("alt")
  valid_580971 = validateParameter(valid_580971, JString, required = false,
                                 default = newJString("json"))
  if valid_580971 != nil:
    section.add "alt", valid_580971
  var valid_580972 = query.getOrDefault("oauth_token")
  valid_580972 = validateParameter(valid_580972, JString, required = false,
                                 default = nil)
  if valid_580972 != nil:
    section.add "oauth_token", valid_580972
  var valid_580973 = query.getOrDefault("userIp")
  valid_580973 = validateParameter(valid_580973, JString, required = false,
                                 default = nil)
  if valid_580973 != nil:
    section.add "userIp", valid_580973
  var valid_580974 = query.getOrDefault("key")
  valid_580974 = validateParameter(valid_580974, JString, required = false,
                                 default = nil)
  if valid_580974 != nil:
    section.add "key", valid_580974
  var valid_580975 = query.getOrDefault("prettyPrint")
  valid_580975 = validateParameter(valid_580975, JBool, required = false,
                                 default = newJBool(true))
  if valid_580975 != nil:
    section.add "prettyPrint", valid_580975
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

proc call*(call_580977: Call_AndroidpublisherReviewsReply_580964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reply to a single review, or update an existing reply.
  ## 
  let valid = call_580977.validator(path, query, header, formData, body)
  let scheme = call_580977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580977.url(scheme.get, call_580977.host, call_580977.base,
                         call_580977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580977, url, valid)

proc call*(call_580978: Call_AndroidpublisherReviewsReply_580964;
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
  var path_580979 = newJObject()
  var query_580980 = newJObject()
  var body_580981 = newJObject()
  add(query_580980, "fields", newJString(fields))
  add(path_580979, "packageName", newJString(packageName))
  add(query_580980, "quotaUser", newJString(quotaUser))
  add(query_580980, "alt", newJString(alt))
  add(query_580980, "oauth_token", newJString(oauthToken))
  add(path_580979, "reviewId", newJString(reviewId))
  add(query_580980, "userIp", newJString(userIp))
  add(query_580980, "key", newJString(key))
  if body != nil:
    body_580981 = body
  add(query_580980, "prettyPrint", newJBool(prettyPrint))
  result = call_580978.call(path_580979, query_580980, nil, nil, body_580981)

var androidpublisherReviewsReply* = Call_AndroidpublisherReviewsReply_580964(
    name: "androidpublisherReviewsReply", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/reviews/{reviewId}:reply",
    validator: validate_AndroidpublisherReviewsReply_580965,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherReviewsReply_580966, schemes: {Scheme.Https})
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
