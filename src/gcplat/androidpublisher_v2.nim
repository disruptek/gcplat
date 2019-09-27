
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597421): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidpublisherEditsInsert_597689 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsInsert_597691(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsInsert_597690(path: JsonNode; query: JsonNode;
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
  var valid_597817 = path.getOrDefault("packageName")
  valid_597817 = validateParameter(valid_597817, JString, required = true,
                                 default = nil)
  if valid_597817 != nil:
    section.add "packageName", valid_597817
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
  var valid_597818 = query.getOrDefault("fields")
  valid_597818 = validateParameter(valid_597818, JString, required = false,
                                 default = nil)
  if valid_597818 != nil:
    section.add "fields", valid_597818
  var valid_597819 = query.getOrDefault("quotaUser")
  valid_597819 = validateParameter(valid_597819, JString, required = false,
                                 default = nil)
  if valid_597819 != nil:
    section.add "quotaUser", valid_597819
  var valid_597833 = query.getOrDefault("alt")
  valid_597833 = validateParameter(valid_597833, JString, required = false,
                                 default = newJString("json"))
  if valid_597833 != nil:
    section.add "alt", valid_597833
  var valid_597834 = query.getOrDefault("oauth_token")
  valid_597834 = validateParameter(valid_597834, JString, required = false,
                                 default = nil)
  if valid_597834 != nil:
    section.add "oauth_token", valid_597834
  var valid_597835 = query.getOrDefault("userIp")
  valid_597835 = validateParameter(valid_597835, JString, required = false,
                                 default = nil)
  if valid_597835 != nil:
    section.add "userIp", valid_597835
  var valid_597836 = query.getOrDefault("key")
  valid_597836 = validateParameter(valid_597836, JString, required = false,
                                 default = nil)
  if valid_597836 != nil:
    section.add "key", valid_597836
  var valid_597837 = query.getOrDefault("prettyPrint")
  valid_597837 = validateParameter(valid_597837, JBool, required = false,
                                 default = newJBool(true))
  if valid_597837 != nil:
    section.add "prettyPrint", valid_597837
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

proc call*(call_597861: Call_AndroidpublisherEditsInsert_597689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new edit for an app, populated with the app's current state.
  ## 
  let valid = call_597861.validator(path, query, header, formData, body)
  let scheme = call_597861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597861.url(scheme.get, call_597861.host, call_597861.base,
                         call_597861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597861, url, valid)

proc call*(call_597932: Call_AndroidpublisherEditsInsert_597689;
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
  var path_597933 = newJObject()
  var query_597935 = newJObject()
  var body_597936 = newJObject()
  add(query_597935, "fields", newJString(fields))
  add(path_597933, "packageName", newJString(packageName))
  add(query_597935, "quotaUser", newJString(quotaUser))
  add(query_597935, "alt", newJString(alt))
  add(query_597935, "oauth_token", newJString(oauthToken))
  add(query_597935, "userIp", newJString(userIp))
  add(query_597935, "key", newJString(key))
  if body != nil:
    body_597936 = body
  add(query_597935, "prettyPrint", newJBool(prettyPrint))
  result = call_597932.call(path_597933, query_597935, nil, nil, body_597936)

var androidpublisherEditsInsert* = Call_AndroidpublisherEditsInsert_597689(
    name: "androidpublisherEditsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits",
    validator: validate_AndroidpublisherEditsInsert_597690,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsInsert_597691, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsGet_597975 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsGet_597977(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsGet_597976(path: JsonNode; query: JsonNode;
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
  var valid_597978 = path.getOrDefault("packageName")
  valid_597978 = validateParameter(valid_597978, JString, required = true,
                                 default = nil)
  if valid_597978 != nil:
    section.add "packageName", valid_597978
  var valid_597979 = path.getOrDefault("editId")
  valid_597979 = validateParameter(valid_597979, JString, required = true,
                                 default = nil)
  if valid_597979 != nil:
    section.add "editId", valid_597979
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
  var valid_597980 = query.getOrDefault("fields")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "fields", valid_597980
  var valid_597981 = query.getOrDefault("quotaUser")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "quotaUser", valid_597981
  var valid_597982 = query.getOrDefault("alt")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = newJString("json"))
  if valid_597982 != nil:
    section.add "alt", valid_597982
  var valid_597983 = query.getOrDefault("oauth_token")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = nil)
  if valid_597983 != nil:
    section.add "oauth_token", valid_597983
  var valid_597984 = query.getOrDefault("userIp")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = nil)
  if valid_597984 != nil:
    section.add "userIp", valid_597984
  var valid_597985 = query.getOrDefault("key")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = nil)
  if valid_597985 != nil:
    section.add "key", valid_597985
  var valid_597986 = query.getOrDefault("prettyPrint")
  valid_597986 = validateParameter(valid_597986, JBool, required = false,
                                 default = newJBool(true))
  if valid_597986 != nil:
    section.add "prettyPrint", valid_597986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597987: Call_AndroidpublisherEditsGet_597975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the edit specified. Calls will fail if the edit is no long active (e.g. has been deleted, superseded or expired).
  ## 
  let valid = call_597987.validator(path, query, header, formData, body)
  let scheme = call_597987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597987.url(scheme.get, call_597987.host, call_597987.base,
                         call_597987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597987, url, valid)

proc call*(call_597988: Call_AndroidpublisherEditsGet_597975; packageName: string;
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
  var path_597989 = newJObject()
  var query_597990 = newJObject()
  add(query_597990, "fields", newJString(fields))
  add(path_597989, "packageName", newJString(packageName))
  add(query_597990, "quotaUser", newJString(quotaUser))
  add(query_597990, "alt", newJString(alt))
  add(path_597989, "editId", newJString(editId))
  add(query_597990, "oauth_token", newJString(oauthToken))
  add(query_597990, "userIp", newJString(userIp))
  add(query_597990, "key", newJString(key))
  add(query_597990, "prettyPrint", newJBool(prettyPrint))
  result = call_597988.call(path_597989, query_597990, nil, nil, nil)

var androidpublisherEditsGet* = Call_AndroidpublisherEditsGet_597975(
    name: "androidpublisherEditsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}",
    validator: validate_AndroidpublisherEditsGet_597976,
    base: "/androidpublisher/v2/applications", url: url_AndroidpublisherEditsGet_597977,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDelete_597991 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsDelete_597993(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsDelete_597992(path: JsonNode; query: JsonNode;
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
  var valid_597994 = path.getOrDefault("packageName")
  valid_597994 = validateParameter(valid_597994, JString, required = true,
                                 default = nil)
  if valid_597994 != nil:
    section.add "packageName", valid_597994
  var valid_597995 = path.getOrDefault("editId")
  valid_597995 = validateParameter(valid_597995, JString, required = true,
                                 default = nil)
  if valid_597995 != nil:
    section.add "editId", valid_597995
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
  var valid_597996 = query.getOrDefault("fields")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "fields", valid_597996
  var valid_597997 = query.getOrDefault("quotaUser")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "quotaUser", valid_597997
  var valid_597998 = query.getOrDefault("alt")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = newJString("json"))
  if valid_597998 != nil:
    section.add "alt", valid_597998
  var valid_597999 = query.getOrDefault("oauth_token")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "oauth_token", valid_597999
  var valid_598000 = query.getOrDefault("userIp")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "userIp", valid_598000
  var valid_598001 = query.getOrDefault("key")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = nil)
  if valid_598001 != nil:
    section.add "key", valid_598001
  var valid_598002 = query.getOrDefault("prettyPrint")
  valid_598002 = validateParameter(valid_598002, JBool, required = false,
                                 default = newJBool(true))
  if valid_598002 != nil:
    section.add "prettyPrint", valid_598002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598003: Call_AndroidpublisherEditsDelete_597991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an edit for an app. Creating a new edit will automatically delete any of your previous edits so this method need only be called if you want to preemptively abandon an edit.
  ## 
  let valid = call_598003.validator(path, query, header, formData, body)
  let scheme = call_598003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598003.url(scheme.get, call_598003.host, call_598003.base,
                         call_598003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598003, url, valid)

proc call*(call_598004: Call_AndroidpublisherEditsDelete_597991;
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
  var path_598005 = newJObject()
  var query_598006 = newJObject()
  add(query_598006, "fields", newJString(fields))
  add(path_598005, "packageName", newJString(packageName))
  add(query_598006, "quotaUser", newJString(quotaUser))
  add(query_598006, "alt", newJString(alt))
  add(path_598005, "editId", newJString(editId))
  add(query_598006, "oauth_token", newJString(oauthToken))
  add(query_598006, "userIp", newJString(userIp))
  add(query_598006, "key", newJString(key))
  add(query_598006, "prettyPrint", newJBool(prettyPrint))
  result = call_598004.call(path_598005, query_598006, nil, nil, nil)

var androidpublisherEditsDelete* = Call_AndroidpublisherEditsDelete_597991(
    name: "androidpublisherEditsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}",
    validator: validate_AndroidpublisherEditsDelete_597992,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDelete_597993, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksUpload_598023 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsApksUpload_598025(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsApksUpload_598024(path: JsonNode;
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
  var valid_598026 = path.getOrDefault("packageName")
  valid_598026 = validateParameter(valid_598026, JString, required = true,
                                 default = nil)
  if valid_598026 != nil:
    section.add "packageName", valid_598026
  var valid_598027 = path.getOrDefault("editId")
  valid_598027 = validateParameter(valid_598027, JString, required = true,
                                 default = nil)
  if valid_598027 != nil:
    section.add "editId", valid_598027
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
  var valid_598028 = query.getOrDefault("fields")
  valid_598028 = validateParameter(valid_598028, JString, required = false,
                                 default = nil)
  if valid_598028 != nil:
    section.add "fields", valid_598028
  var valid_598029 = query.getOrDefault("quotaUser")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "quotaUser", valid_598029
  var valid_598030 = query.getOrDefault("alt")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = newJString("json"))
  if valid_598030 != nil:
    section.add "alt", valid_598030
  var valid_598031 = query.getOrDefault("oauth_token")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "oauth_token", valid_598031
  var valid_598032 = query.getOrDefault("userIp")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "userIp", valid_598032
  var valid_598033 = query.getOrDefault("key")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "key", valid_598033
  var valid_598034 = query.getOrDefault("prettyPrint")
  valid_598034 = validateParameter(valid_598034, JBool, required = false,
                                 default = newJBool(true))
  if valid_598034 != nil:
    section.add "prettyPrint", valid_598034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598035: Call_AndroidpublisherEditsApksUpload_598023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_598035.validator(path, query, header, formData, body)
  let scheme = call_598035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598035.url(scheme.get, call_598035.host, call_598035.base,
                         call_598035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598035, url, valid)

proc call*(call_598036: Call_AndroidpublisherEditsApksUpload_598023;
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
  var path_598037 = newJObject()
  var query_598038 = newJObject()
  add(query_598038, "fields", newJString(fields))
  add(path_598037, "packageName", newJString(packageName))
  add(query_598038, "quotaUser", newJString(quotaUser))
  add(query_598038, "alt", newJString(alt))
  add(path_598037, "editId", newJString(editId))
  add(query_598038, "oauth_token", newJString(oauthToken))
  add(query_598038, "userIp", newJString(userIp))
  add(query_598038, "key", newJString(key))
  add(query_598038, "prettyPrint", newJBool(prettyPrint))
  result = call_598036.call(path_598037, query_598038, nil, nil, nil)

var androidpublisherEditsApksUpload* = Call_AndroidpublisherEditsApksUpload_598023(
    name: "androidpublisherEditsApksUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks",
    validator: validate_AndroidpublisherEditsApksUpload_598024,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApksUpload_598025, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksList_598007 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsApksList_598009(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsApksList_598008(path: JsonNode; query: JsonNode;
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
  var valid_598010 = path.getOrDefault("packageName")
  valid_598010 = validateParameter(valid_598010, JString, required = true,
                                 default = nil)
  if valid_598010 != nil:
    section.add "packageName", valid_598010
  var valid_598011 = path.getOrDefault("editId")
  valid_598011 = validateParameter(valid_598011, JString, required = true,
                                 default = nil)
  if valid_598011 != nil:
    section.add "editId", valid_598011
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
  var valid_598012 = query.getOrDefault("fields")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "fields", valid_598012
  var valid_598013 = query.getOrDefault("quotaUser")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "quotaUser", valid_598013
  var valid_598014 = query.getOrDefault("alt")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = newJString("json"))
  if valid_598014 != nil:
    section.add "alt", valid_598014
  var valid_598015 = query.getOrDefault("oauth_token")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "oauth_token", valid_598015
  var valid_598016 = query.getOrDefault("userIp")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "userIp", valid_598016
  var valid_598017 = query.getOrDefault("key")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "key", valid_598017
  var valid_598018 = query.getOrDefault("prettyPrint")
  valid_598018 = validateParameter(valid_598018, JBool, required = false,
                                 default = newJBool(true))
  if valid_598018 != nil:
    section.add "prettyPrint", valid_598018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598019: Call_AndroidpublisherEditsApksList_598007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_598019.validator(path, query, header, formData, body)
  let scheme = call_598019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598019.url(scheme.get, call_598019.host, call_598019.base,
                         call_598019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598019, url, valid)

proc call*(call_598020: Call_AndroidpublisherEditsApksList_598007;
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
  var path_598021 = newJObject()
  var query_598022 = newJObject()
  add(query_598022, "fields", newJString(fields))
  add(path_598021, "packageName", newJString(packageName))
  add(query_598022, "quotaUser", newJString(quotaUser))
  add(query_598022, "alt", newJString(alt))
  add(path_598021, "editId", newJString(editId))
  add(query_598022, "oauth_token", newJString(oauthToken))
  add(query_598022, "userIp", newJString(userIp))
  add(query_598022, "key", newJString(key))
  add(query_598022, "prettyPrint", newJBool(prettyPrint))
  result = call_598020.call(path_598021, query_598022, nil, nil, nil)

var androidpublisherEditsApksList* = Call_AndroidpublisherEditsApksList_598007(
    name: "androidpublisherEditsApksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks",
    validator: validate_AndroidpublisherEditsApksList_598008,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApksList_598009, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksAddexternallyhosted_598039 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsApksAddexternallyhosted_598041(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsApksAddexternallyhosted_598040(path: JsonNode;
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
  var valid_598042 = path.getOrDefault("packageName")
  valid_598042 = validateParameter(valid_598042, JString, required = true,
                                 default = nil)
  if valid_598042 != nil:
    section.add "packageName", valid_598042
  var valid_598043 = path.getOrDefault("editId")
  valid_598043 = validateParameter(valid_598043, JString, required = true,
                                 default = nil)
  if valid_598043 != nil:
    section.add "editId", valid_598043
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
  var valid_598044 = query.getOrDefault("fields")
  valid_598044 = validateParameter(valid_598044, JString, required = false,
                                 default = nil)
  if valid_598044 != nil:
    section.add "fields", valid_598044
  var valid_598045 = query.getOrDefault("quotaUser")
  valid_598045 = validateParameter(valid_598045, JString, required = false,
                                 default = nil)
  if valid_598045 != nil:
    section.add "quotaUser", valid_598045
  var valid_598046 = query.getOrDefault("alt")
  valid_598046 = validateParameter(valid_598046, JString, required = false,
                                 default = newJString("json"))
  if valid_598046 != nil:
    section.add "alt", valid_598046
  var valid_598047 = query.getOrDefault("oauth_token")
  valid_598047 = validateParameter(valid_598047, JString, required = false,
                                 default = nil)
  if valid_598047 != nil:
    section.add "oauth_token", valid_598047
  var valid_598048 = query.getOrDefault("userIp")
  valid_598048 = validateParameter(valid_598048, JString, required = false,
                                 default = nil)
  if valid_598048 != nil:
    section.add "userIp", valid_598048
  var valid_598049 = query.getOrDefault("key")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "key", valid_598049
  var valid_598050 = query.getOrDefault("prettyPrint")
  valid_598050 = validateParameter(valid_598050, JBool, required = false,
                                 default = newJBool(true))
  if valid_598050 != nil:
    section.add "prettyPrint", valid_598050
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

proc call*(call_598052: Call_AndroidpublisherEditsApksAddexternallyhosted_598039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new APK without uploading the APK itself to Google Play, instead hosting the APK at a specified URL. This function is only available to enterprises using Google Play for Work whose application is configured to restrict distribution to the enterprise domain.
  ## 
  let valid = call_598052.validator(path, query, header, formData, body)
  let scheme = call_598052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598052.url(scheme.get, call_598052.host, call_598052.base,
                         call_598052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598052, url, valid)

proc call*(call_598053: Call_AndroidpublisherEditsApksAddexternallyhosted_598039;
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
  var path_598054 = newJObject()
  var query_598055 = newJObject()
  var body_598056 = newJObject()
  add(query_598055, "fields", newJString(fields))
  add(path_598054, "packageName", newJString(packageName))
  add(query_598055, "quotaUser", newJString(quotaUser))
  add(query_598055, "alt", newJString(alt))
  add(path_598054, "editId", newJString(editId))
  add(query_598055, "oauth_token", newJString(oauthToken))
  add(query_598055, "userIp", newJString(userIp))
  add(query_598055, "key", newJString(key))
  if body != nil:
    body_598056 = body
  add(query_598055, "prettyPrint", newJBool(prettyPrint))
  result = call_598053.call(path_598054, query_598055, nil, nil, body_598056)

var androidpublisherEditsApksAddexternallyhosted* = Call_AndroidpublisherEditsApksAddexternallyhosted_598039(
    name: "androidpublisherEditsApksAddexternallyhosted",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/apks/externallyHosted",
    validator: validate_AndroidpublisherEditsApksAddexternallyhosted_598040,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApksAddexternallyhosted_598041,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDeobfuscationfilesUpload_598057 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsDeobfuscationfilesUpload_598059(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsDeobfuscationfilesUpload_598058(
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
  var valid_598060 = path.getOrDefault("packageName")
  valid_598060 = validateParameter(valid_598060, JString, required = true,
                                 default = nil)
  if valid_598060 != nil:
    section.add "packageName", valid_598060
  var valid_598061 = path.getOrDefault("deobfuscationFileType")
  valid_598061 = validateParameter(valid_598061, JString, required = true,
                                 default = newJString("proguard"))
  if valid_598061 != nil:
    section.add "deobfuscationFileType", valid_598061
  var valid_598062 = path.getOrDefault("editId")
  valid_598062 = validateParameter(valid_598062, JString, required = true,
                                 default = nil)
  if valid_598062 != nil:
    section.add "editId", valid_598062
  var valid_598063 = path.getOrDefault("apkVersionCode")
  valid_598063 = validateParameter(valid_598063, JInt, required = true, default = nil)
  if valid_598063 != nil:
    section.add "apkVersionCode", valid_598063
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
  var valid_598064 = query.getOrDefault("fields")
  valid_598064 = validateParameter(valid_598064, JString, required = false,
                                 default = nil)
  if valid_598064 != nil:
    section.add "fields", valid_598064
  var valid_598065 = query.getOrDefault("quotaUser")
  valid_598065 = validateParameter(valid_598065, JString, required = false,
                                 default = nil)
  if valid_598065 != nil:
    section.add "quotaUser", valid_598065
  var valid_598066 = query.getOrDefault("alt")
  valid_598066 = validateParameter(valid_598066, JString, required = false,
                                 default = newJString("json"))
  if valid_598066 != nil:
    section.add "alt", valid_598066
  var valid_598067 = query.getOrDefault("oauth_token")
  valid_598067 = validateParameter(valid_598067, JString, required = false,
                                 default = nil)
  if valid_598067 != nil:
    section.add "oauth_token", valid_598067
  var valid_598068 = query.getOrDefault("userIp")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "userIp", valid_598068
  var valid_598069 = query.getOrDefault("key")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "key", valid_598069
  var valid_598070 = query.getOrDefault("prettyPrint")
  valid_598070 = validateParameter(valid_598070, JBool, required = false,
                                 default = newJBool(true))
  if valid_598070 != nil:
    section.add "prettyPrint", valid_598070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598071: Call_AndroidpublisherEditsDeobfuscationfilesUpload_598057;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads the deobfuscation file of the specified APK. If a deobfuscation file already exists, it will be replaced.
  ## 
  let valid = call_598071.validator(path, query, header, formData, body)
  let scheme = call_598071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598071.url(scheme.get, call_598071.host, call_598071.base,
                         call_598071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598071, url, valid)

proc call*(call_598072: Call_AndroidpublisherEditsDeobfuscationfilesUpload_598057;
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
  var path_598073 = newJObject()
  var query_598074 = newJObject()
  add(query_598074, "fields", newJString(fields))
  add(path_598073, "packageName", newJString(packageName))
  add(query_598074, "quotaUser", newJString(quotaUser))
  add(path_598073, "deobfuscationFileType", newJString(deobfuscationFileType))
  add(query_598074, "alt", newJString(alt))
  add(path_598073, "editId", newJString(editId))
  add(query_598074, "oauth_token", newJString(oauthToken))
  add(query_598074, "userIp", newJString(userIp))
  add(query_598074, "key", newJString(key))
  add(query_598074, "prettyPrint", newJBool(prettyPrint))
  add(path_598073, "apkVersionCode", newJInt(apkVersionCode))
  result = call_598072.call(path_598073, query_598074, nil, nil, nil)

var androidpublisherEditsDeobfuscationfilesUpload* = Call_AndroidpublisherEditsDeobfuscationfilesUpload_598057(
    name: "androidpublisherEditsDeobfuscationfilesUpload",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/deobfuscationFiles/{deobfuscationFileType}",
    validator: validate_AndroidpublisherEditsDeobfuscationfilesUpload_598058,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDeobfuscationfilesUpload_598059,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesUpdate_598093 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsExpansionfilesUpdate_598095(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsExpansionfilesUpdate_598094(path: JsonNode;
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
  var valid_598096 = path.getOrDefault("packageName")
  valid_598096 = validateParameter(valid_598096, JString, required = true,
                                 default = nil)
  if valid_598096 != nil:
    section.add "packageName", valid_598096
  var valid_598097 = path.getOrDefault("editId")
  valid_598097 = validateParameter(valid_598097, JString, required = true,
                                 default = nil)
  if valid_598097 != nil:
    section.add "editId", valid_598097
  var valid_598098 = path.getOrDefault("expansionFileType")
  valid_598098 = validateParameter(valid_598098, JString, required = true,
                                 default = newJString("main"))
  if valid_598098 != nil:
    section.add "expansionFileType", valid_598098
  var valid_598099 = path.getOrDefault("apkVersionCode")
  valid_598099 = validateParameter(valid_598099, JInt, required = true, default = nil)
  if valid_598099 != nil:
    section.add "apkVersionCode", valid_598099
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
  var valid_598100 = query.getOrDefault("fields")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "fields", valid_598100
  var valid_598101 = query.getOrDefault("quotaUser")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "quotaUser", valid_598101
  var valid_598102 = query.getOrDefault("alt")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = newJString("json"))
  if valid_598102 != nil:
    section.add "alt", valid_598102
  var valid_598103 = query.getOrDefault("oauth_token")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = nil)
  if valid_598103 != nil:
    section.add "oauth_token", valid_598103
  var valid_598104 = query.getOrDefault("userIp")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = nil)
  if valid_598104 != nil:
    section.add "userIp", valid_598104
  var valid_598105 = query.getOrDefault("key")
  valid_598105 = validateParameter(valid_598105, JString, required = false,
                                 default = nil)
  if valid_598105 != nil:
    section.add "key", valid_598105
  var valid_598106 = query.getOrDefault("prettyPrint")
  valid_598106 = validateParameter(valid_598106, JBool, required = false,
                                 default = newJBool(true))
  if valid_598106 != nil:
    section.add "prettyPrint", valid_598106
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

proc call*(call_598108: Call_AndroidpublisherEditsExpansionfilesUpdate_598093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method.
  ## 
  let valid = call_598108.validator(path, query, header, formData, body)
  let scheme = call_598108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598108.url(scheme.get, call_598108.host, call_598108.base,
                         call_598108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598108, url, valid)

proc call*(call_598109: Call_AndroidpublisherEditsExpansionfilesUpdate_598093;
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
  var path_598110 = newJObject()
  var query_598111 = newJObject()
  var body_598112 = newJObject()
  add(query_598111, "fields", newJString(fields))
  add(path_598110, "packageName", newJString(packageName))
  add(query_598111, "quotaUser", newJString(quotaUser))
  add(query_598111, "alt", newJString(alt))
  add(path_598110, "editId", newJString(editId))
  add(query_598111, "oauth_token", newJString(oauthToken))
  add(query_598111, "userIp", newJString(userIp))
  add(query_598111, "key", newJString(key))
  add(path_598110, "expansionFileType", newJString(expansionFileType))
  if body != nil:
    body_598112 = body
  add(query_598111, "prettyPrint", newJBool(prettyPrint))
  add(path_598110, "apkVersionCode", newJInt(apkVersionCode))
  result = call_598109.call(path_598110, query_598111, nil, nil, body_598112)

var androidpublisherEditsExpansionfilesUpdate* = Call_AndroidpublisherEditsExpansionfilesUpdate_598093(
    name: "androidpublisherEditsExpansionfilesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesUpdate_598094,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsExpansionfilesUpdate_598095,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesUpload_598113 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsExpansionfilesUpload_598115(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsExpansionfilesUpload_598114(path: JsonNode;
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
  var valid_598116 = path.getOrDefault("packageName")
  valid_598116 = validateParameter(valid_598116, JString, required = true,
                                 default = nil)
  if valid_598116 != nil:
    section.add "packageName", valid_598116
  var valid_598117 = path.getOrDefault("editId")
  valid_598117 = validateParameter(valid_598117, JString, required = true,
                                 default = nil)
  if valid_598117 != nil:
    section.add "editId", valid_598117
  var valid_598118 = path.getOrDefault("expansionFileType")
  valid_598118 = validateParameter(valid_598118, JString, required = true,
                                 default = newJString("main"))
  if valid_598118 != nil:
    section.add "expansionFileType", valid_598118
  var valid_598119 = path.getOrDefault("apkVersionCode")
  valid_598119 = validateParameter(valid_598119, JInt, required = true, default = nil)
  if valid_598119 != nil:
    section.add "apkVersionCode", valid_598119
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
  var valid_598120 = query.getOrDefault("fields")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = nil)
  if valid_598120 != nil:
    section.add "fields", valid_598120
  var valid_598121 = query.getOrDefault("quotaUser")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "quotaUser", valid_598121
  var valid_598122 = query.getOrDefault("alt")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = newJString("json"))
  if valid_598122 != nil:
    section.add "alt", valid_598122
  var valid_598123 = query.getOrDefault("oauth_token")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "oauth_token", valid_598123
  var valid_598124 = query.getOrDefault("userIp")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "userIp", valid_598124
  var valid_598125 = query.getOrDefault("key")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "key", valid_598125
  var valid_598126 = query.getOrDefault("prettyPrint")
  valid_598126 = validateParameter(valid_598126, JBool, required = false,
                                 default = newJBool(true))
  if valid_598126 != nil:
    section.add "prettyPrint", valid_598126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598127: Call_AndroidpublisherEditsExpansionfilesUpload_598113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads and attaches a new Expansion File to the APK specified.
  ## 
  let valid = call_598127.validator(path, query, header, formData, body)
  let scheme = call_598127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598127.url(scheme.get, call_598127.host, call_598127.base,
                         call_598127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598127, url, valid)

proc call*(call_598128: Call_AndroidpublisherEditsExpansionfilesUpload_598113;
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
  var path_598129 = newJObject()
  var query_598130 = newJObject()
  add(query_598130, "fields", newJString(fields))
  add(path_598129, "packageName", newJString(packageName))
  add(query_598130, "quotaUser", newJString(quotaUser))
  add(query_598130, "alt", newJString(alt))
  add(path_598129, "editId", newJString(editId))
  add(query_598130, "oauth_token", newJString(oauthToken))
  add(query_598130, "userIp", newJString(userIp))
  add(query_598130, "key", newJString(key))
  add(path_598129, "expansionFileType", newJString(expansionFileType))
  add(query_598130, "prettyPrint", newJBool(prettyPrint))
  add(path_598129, "apkVersionCode", newJInt(apkVersionCode))
  result = call_598128.call(path_598129, query_598130, nil, nil, nil)

var androidpublisherEditsExpansionfilesUpload* = Call_AndroidpublisherEditsExpansionfilesUpload_598113(
    name: "androidpublisherEditsExpansionfilesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesUpload_598114,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsExpansionfilesUpload_598115,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesGet_598075 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsExpansionfilesGet_598077(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsExpansionfilesGet_598076(path: JsonNode;
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
  var valid_598078 = path.getOrDefault("packageName")
  valid_598078 = validateParameter(valid_598078, JString, required = true,
                                 default = nil)
  if valid_598078 != nil:
    section.add "packageName", valid_598078
  var valid_598079 = path.getOrDefault("editId")
  valid_598079 = validateParameter(valid_598079, JString, required = true,
                                 default = nil)
  if valid_598079 != nil:
    section.add "editId", valid_598079
  var valid_598080 = path.getOrDefault("expansionFileType")
  valid_598080 = validateParameter(valid_598080, JString, required = true,
                                 default = newJString("main"))
  if valid_598080 != nil:
    section.add "expansionFileType", valid_598080
  var valid_598081 = path.getOrDefault("apkVersionCode")
  valid_598081 = validateParameter(valid_598081, JInt, required = true, default = nil)
  if valid_598081 != nil:
    section.add "apkVersionCode", valid_598081
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
  var valid_598082 = query.getOrDefault("fields")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "fields", valid_598082
  var valid_598083 = query.getOrDefault("quotaUser")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = nil)
  if valid_598083 != nil:
    section.add "quotaUser", valid_598083
  var valid_598084 = query.getOrDefault("alt")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = newJString("json"))
  if valid_598084 != nil:
    section.add "alt", valid_598084
  var valid_598085 = query.getOrDefault("oauth_token")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = nil)
  if valid_598085 != nil:
    section.add "oauth_token", valid_598085
  var valid_598086 = query.getOrDefault("userIp")
  valid_598086 = validateParameter(valid_598086, JString, required = false,
                                 default = nil)
  if valid_598086 != nil:
    section.add "userIp", valid_598086
  var valid_598087 = query.getOrDefault("key")
  valid_598087 = validateParameter(valid_598087, JString, required = false,
                                 default = nil)
  if valid_598087 != nil:
    section.add "key", valid_598087
  var valid_598088 = query.getOrDefault("prettyPrint")
  valid_598088 = validateParameter(valid_598088, JBool, required = false,
                                 default = newJBool(true))
  if valid_598088 != nil:
    section.add "prettyPrint", valid_598088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598089: Call_AndroidpublisherEditsExpansionfilesGet_598075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the Expansion File configuration for the APK specified.
  ## 
  let valid = call_598089.validator(path, query, header, formData, body)
  let scheme = call_598089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598089.url(scheme.get, call_598089.host, call_598089.base,
                         call_598089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598089, url, valid)

proc call*(call_598090: Call_AndroidpublisherEditsExpansionfilesGet_598075;
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
  var path_598091 = newJObject()
  var query_598092 = newJObject()
  add(query_598092, "fields", newJString(fields))
  add(path_598091, "packageName", newJString(packageName))
  add(query_598092, "quotaUser", newJString(quotaUser))
  add(query_598092, "alt", newJString(alt))
  add(path_598091, "editId", newJString(editId))
  add(query_598092, "oauth_token", newJString(oauthToken))
  add(query_598092, "userIp", newJString(userIp))
  add(query_598092, "key", newJString(key))
  add(path_598091, "expansionFileType", newJString(expansionFileType))
  add(query_598092, "prettyPrint", newJBool(prettyPrint))
  add(path_598091, "apkVersionCode", newJInt(apkVersionCode))
  result = call_598090.call(path_598091, query_598092, nil, nil, nil)

var androidpublisherEditsExpansionfilesGet* = Call_AndroidpublisherEditsExpansionfilesGet_598075(
    name: "androidpublisherEditsExpansionfilesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesGet_598076,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsExpansionfilesGet_598077,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesPatch_598131 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsExpansionfilesPatch_598133(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsExpansionfilesPatch_598132(path: JsonNode;
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
  var valid_598134 = path.getOrDefault("packageName")
  valid_598134 = validateParameter(valid_598134, JString, required = true,
                                 default = nil)
  if valid_598134 != nil:
    section.add "packageName", valid_598134
  var valid_598135 = path.getOrDefault("editId")
  valid_598135 = validateParameter(valid_598135, JString, required = true,
                                 default = nil)
  if valid_598135 != nil:
    section.add "editId", valid_598135
  var valid_598136 = path.getOrDefault("expansionFileType")
  valid_598136 = validateParameter(valid_598136, JString, required = true,
                                 default = newJString("main"))
  if valid_598136 != nil:
    section.add "expansionFileType", valid_598136
  var valid_598137 = path.getOrDefault("apkVersionCode")
  valid_598137 = validateParameter(valid_598137, JInt, required = true, default = nil)
  if valid_598137 != nil:
    section.add "apkVersionCode", valid_598137
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
  var valid_598138 = query.getOrDefault("fields")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "fields", valid_598138
  var valid_598139 = query.getOrDefault("quotaUser")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "quotaUser", valid_598139
  var valid_598140 = query.getOrDefault("alt")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = newJString("json"))
  if valid_598140 != nil:
    section.add "alt", valid_598140
  var valid_598141 = query.getOrDefault("oauth_token")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "oauth_token", valid_598141
  var valid_598142 = query.getOrDefault("userIp")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "userIp", valid_598142
  var valid_598143 = query.getOrDefault("key")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "key", valid_598143
  var valid_598144 = query.getOrDefault("prettyPrint")
  valid_598144 = validateParameter(valid_598144, JBool, required = false,
                                 default = newJBool(true))
  if valid_598144 != nil:
    section.add "prettyPrint", valid_598144
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

proc call*(call_598146: Call_AndroidpublisherEditsExpansionfilesPatch_598131;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method. This method supports patch semantics.
  ## 
  let valid = call_598146.validator(path, query, header, formData, body)
  let scheme = call_598146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598146.url(scheme.get, call_598146.host, call_598146.base,
                         call_598146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598146, url, valid)

proc call*(call_598147: Call_AndroidpublisherEditsExpansionfilesPatch_598131;
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
  var path_598148 = newJObject()
  var query_598149 = newJObject()
  var body_598150 = newJObject()
  add(query_598149, "fields", newJString(fields))
  add(path_598148, "packageName", newJString(packageName))
  add(query_598149, "quotaUser", newJString(quotaUser))
  add(query_598149, "alt", newJString(alt))
  add(path_598148, "editId", newJString(editId))
  add(query_598149, "oauth_token", newJString(oauthToken))
  add(query_598149, "userIp", newJString(userIp))
  add(query_598149, "key", newJString(key))
  add(path_598148, "expansionFileType", newJString(expansionFileType))
  if body != nil:
    body_598150 = body
  add(query_598149, "prettyPrint", newJBool(prettyPrint))
  add(path_598148, "apkVersionCode", newJInt(apkVersionCode))
  result = call_598147.call(path_598148, query_598149, nil, nil, body_598150)

var androidpublisherEditsExpansionfilesPatch* = Call_AndroidpublisherEditsExpansionfilesPatch_598131(
    name: "androidpublisherEditsExpansionfilesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesPatch_598132,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsExpansionfilesPatch_598133,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsList_598151 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsApklistingsList_598153(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsApklistingsList_598152(path: JsonNode;
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
  var valid_598154 = path.getOrDefault("packageName")
  valid_598154 = validateParameter(valid_598154, JString, required = true,
                                 default = nil)
  if valid_598154 != nil:
    section.add "packageName", valid_598154
  var valid_598155 = path.getOrDefault("editId")
  valid_598155 = validateParameter(valid_598155, JString, required = true,
                                 default = nil)
  if valid_598155 != nil:
    section.add "editId", valid_598155
  var valid_598156 = path.getOrDefault("apkVersionCode")
  valid_598156 = validateParameter(valid_598156, JInt, required = true, default = nil)
  if valid_598156 != nil:
    section.add "apkVersionCode", valid_598156
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
  var valid_598157 = query.getOrDefault("fields")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = nil)
  if valid_598157 != nil:
    section.add "fields", valid_598157
  var valid_598158 = query.getOrDefault("quotaUser")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = nil)
  if valid_598158 != nil:
    section.add "quotaUser", valid_598158
  var valid_598159 = query.getOrDefault("alt")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = newJString("json"))
  if valid_598159 != nil:
    section.add "alt", valid_598159
  var valid_598160 = query.getOrDefault("oauth_token")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "oauth_token", valid_598160
  var valid_598161 = query.getOrDefault("userIp")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "userIp", valid_598161
  var valid_598162 = query.getOrDefault("key")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "key", valid_598162
  var valid_598163 = query.getOrDefault("prettyPrint")
  valid_598163 = validateParameter(valid_598163, JBool, required = false,
                                 default = newJBool(true))
  if valid_598163 != nil:
    section.add "prettyPrint", valid_598163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598164: Call_AndroidpublisherEditsApklistingsList_598151;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the APK-specific localized listings for a specified APK.
  ## 
  let valid = call_598164.validator(path, query, header, formData, body)
  let scheme = call_598164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598164.url(scheme.get, call_598164.host, call_598164.base,
                         call_598164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598164, url, valid)

proc call*(call_598165: Call_AndroidpublisherEditsApklistingsList_598151;
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
  var path_598166 = newJObject()
  var query_598167 = newJObject()
  add(query_598167, "fields", newJString(fields))
  add(path_598166, "packageName", newJString(packageName))
  add(query_598167, "quotaUser", newJString(quotaUser))
  add(query_598167, "alt", newJString(alt))
  add(path_598166, "editId", newJString(editId))
  add(query_598167, "oauth_token", newJString(oauthToken))
  add(query_598167, "userIp", newJString(userIp))
  add(query_598167, "key", newJString(key))
  add(query_598167, "prettyPrint", newJBool(prettyPrint))
  add(path_598166, "apkVersionCode", newJInt(apkVersionCode))
  result = call_598165.call(path_598166, query_598167, nil, nil, nil)

var androidpublisherEditsApklistingsList* = Call_AndroidpublisherEditsApklistingsList_598151(
    name: "androidpublisherEditsApklistingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings",
    validator: validate_AndroidpublisherEditsApklistingsList_598152,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsList_598153, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsDeleteall_598168 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsApklistingsDeleteall_598170(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsApklistingsDeleteall_598169(path: JsonNode;
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
  var valid_598171 = path.getOrDefault("packageName")
  valid_598171 = validateParameter(valid_598171, JString, required = true,
                                 default = nil)
  if valid_598171 != nil:
    section.add "packageName", valid_598171
  var valid_598172 = path.getOrDefault("editId")
  valid_598172 = validateParameter(valid_598172, JString, required = true,
                                 default = nil)
  if valid_598172 != nil:
    section.add "editId", valid_598172
  var valid_598173 = path.getOrDefault("apkVersionCode")
  valid_598173 = validateParameter(valid_598173, JInt, required = true, default = nil)
  if valid_598173 != nil:
    section.add "apkVersionCode", valid_598173
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
  var valid_598174 = query.getOrDefault("fields")
  valid_598174 = validateParameter(valid_598174, JString, required = false,
                                 default = nil)
  if valid_598174 != nil:
    section.add "fields", valid_598174
  var valid_598175 = query.getOrDefault("quotaUser")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "quotaUser", valid_598175
  var valid_598176 = query.getOrDefault("alt")
  valid_598176 = validateParameter(valid_598176, JString, required = false,
                                 default = newJString("json"))
  if valid_598176 != nil:
    section.add "alt", valid_598176
  var valid_598177 = query.getOrDefault("oauth_token")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = nil)
  if valid_598177 != nil:
    section.add "oauth_token", valid_598177
  var valid_598178 = query.getOrDefault("userIp")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = nil)
  if valid_598178 != nil:
    section.add "userIp", valid_598178
  var valid_598179 = query.getOrDefault("key")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "key", valid_598179
  var valid_598180 = query.getOrDefault("prettyPrint")
  valid_598180 = validateParameter(valid_598180, JBool, required = false,
                                 default = newJBool(true))
  if valid_598180 != nil:
    section.add "prettyPrint", valid_598180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598181: Call_AndroidpublisherEditsApklistingsDeleteall_598168;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all the APK-specific localized listings for a specified APK.
  ## 
  let valid = call_598181.validator(path, query, header, formData, body)
  let scheme = call_598181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598181.url(scheme.get, call_598181.host, call_598181.base,
                         call_598181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598181, url, valid)

proc call*(call_598182: Call_AndroidpublisherEditsApklistingsDeleteall_598168;
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
  var path_598183 = newJObject()
  var query_598184 = newJObject()
  add(query_598184, "fields", newJString(fields))
  add(path_598183, "packageName", newJString(packageName))
  add(query_598184, "quotaUser", newJString(quotaUser))
  add(query_598184, "alt", newJString(alt))
  add(path_598183, "editId", newJString(editId))
  add(query_598184, "oauth_token", newJString(oauthToken))
  add(query_598184, "userIp", newJString(userIp))
  add(query_598184, "key", newJString(key))
  add(query_598184, "prettyPrint", newJBool(prettyPrint))
  add(path_598183, "apkVersionCode", newJInt(apkVersionCode))
  result = call_598182.call(path_598183, query_598184, nil, nil, nil)

var androidpublisherEditsApklistingsDeleteall* = Call_AndroidpublisherEditsApklistingsDeleteall_598168(
    name: "androidpublisherEditsApklistingsDeleteall",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings",
    validator: validate_AndroidpublisherEditsApklistingsDeleteall_598169,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsDeleteall_598170,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsUpdate_598203 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsApklistingsUpdate_598205(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsApklistingsUpdate_598204(path: JsonNode;
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
  var valid_598206 = path.getOrDefault("packageName")
  valid_598206 = validateParameter(valid_598206, JString, required = true,
                                 default = nil)
  if valid_598206 != nil:
    section.add "packageName", valid_598206
  var valid_598207 = path.getOrDefault("editId")
  valid_598207 = validateParameter(valid_598207, JString, required = true,
                                 default = nil)
  if valid_598207 != nil:
    section.add "editId", valid_598207
  var valid_598208 = path.getOrDefault("language")
  valid_598208 = validateParameter(valid_598208, JString, required = true,
                                 default = nil)
  if valid_598208 != nil:
    section.add "language", valid_598208
  var valid_598209 = path.getOrDefault("apkVersionCode")
  valid_598209 = validateParameter(valid_598209, JInt, required = true, default = nil)
  if valid_598209 != nil:
    section.add "apkVersionCode", valid_598209
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
  var valid_598210 = query.getOrDefault("fields")
  valid_598210 = validateParameter(valid_598210, JString, required = false,
                                 default = nil)
  if valid_598210 != nil:
    section.add "fields", valid_598210
  var valid_598211 = query.getOrDefault("quotaUser")
  valid_598211 = validateParameter(valid_598211, JString, required = false,
                                 default = nil)
  if valid_598211 != nil:
    section.add "quotaUser", valid_598211
  var valid_598212 = query.getOrDefault("alt")
  valid_598212 = validateParameter(valid_598212, JString, required = false,
                                 default = newJString("json"))
  if valid_598212 != nil:
    section.add "alt", valid_598212
  var valid_598213 = query.getOrDefault("oauth_token")
  valid_598213 = validateParameter(valid_598213, JString, required = false,
                                 default = nil)
  if valid_598213 != nil:
    section.add "oauth_token", valid_598213
  var valid_598214 = query.getOrDefault("userIp")
  valid_598214 = validateParameter(valid_598214, JString, required = false,
                                 default = nil)
  if valid_598214 != nil:
    section.add "userIp", valid_598214
  var valid_598215 = query.getOrDefault("key")
  valid_598215 = validateParameter(valid_598215, JString, required = false,
                                 default = nil)
  if valid_598215 != nil:
    section.add "key", valid_598215
  var valid_598216 = query.getOrDefault("prettyPrint")
  valid_598216 = validateParameter(valid_598216, JBool, required = false,
                                 default = newJBool(true))
  if valid_598216 != nil:
    section.add "prettyPrint", valid_598216
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

proc call*(call_598218: Call_AndroidpublisherEditsApklistingsUpdate_598203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates or creates the APK-specific localized listing for a specified APK and language code.
  ## 
  let valid = call_598218.validator(path, query, header, formData, body)
  let scheme = call_598218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598218.url(scheme.get, call_598218.host, call_598218.base,
                         call_598218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598218, url, valid)

proc call*(call_598219: Call_AndroidpublisherEditsApklistingsUpdate_598203;
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
  var path_598220 = newJObject()
  var query_598221 = newJObject()
  var body_598222 = newJObject()
  add(query_598221, "fields", newJString(fields))
  add(path_598220, "packageName", newJString(packageName))
  add(query_598221, "quotaUser", newJString(quotaUser))
  add(query_598221, "alt", newJString(alt))
  add(path_598220, "editId", newJString(editId))
  add(query_598221, "oauth_token", newJString(oauthToken))
  add(path_598220, "language", newJString(language))
  add(query_598221, "userIp", newJString(userIp))
  add(query_598221, "key", newJString(key))
  if body != nil:
    body_598222 = body
  add(query_598221, "prettyPrint", newJBool(prettyPrint))
  add(path_598220, "apkVersionCode", newJInt(apkVersionCode))
  result = call_598219.call(path_598220, query_598221, nil, nil, body_598222)

var androidpublisherEditsApklistingsUpdate* = Call_AndroidpublisherEditsApklistingsUpdate_598203(
    name: "androidpublisherEditsApklistingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings/{language}",
    validator: validate_AndroidpublisherEditsApklistingsUpdate_598204,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsUpdate_598205,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsGet_598185 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsApklistingsGet_598187(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsApklistingsGet_598186(path: JsonNode;
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
  var valid_598188 = path.getOrDefault("packageName")
  valid_598188 = validateParameter(valid_598188, JString, required = true,
                                 default = nil)
  if valid_598188 != nil:
    section.add "packageName", valid_598188
  var valid_598189 = path.getOrDefault("editId")
  valid_598189 = validateParameter(valid_598189, JString, required = true,
                                 default = nil)
  if valid_598189 != nil:
    section.add "editId", valid_598189
  var valid_598190 = path.getOrDefault("language")
  valid_598190 = validateParameter(valid_598190, JString, required = true,
                                 default = nil)
  if valid_598190 != nil:
    section.add "language", valid_598190
  var valid_598191 = path.getOrDefault("apkVersionCode")
  valid_598191 = validateParameter(valid_598191, JInt, required = true, default = nil)
  if valid_598191 != nil:
    section.add "apkVersionCode", valid_598191
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
  var valid_598192 = query.getOrDefault("fields")
  valid_598192 = validateParameter(valid_598192, JString, required = false,
                                 default = nil)
  if valid_598192 != nil:
    section.add "fields", valid_598192
  var valid_598193 = query.getOrDefault("quotaUser")
  valid_598193 = validateParameter(valid_598193, JString, required = false,
                                 default = nil)
  if valid_598193 != nil:
    section.add "quotaUser", valid_598193
  var valid_598194 = query.getOrDefault("alt")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = newJString("json"))
  if valid_598194 != nil:
    section.add "alt", valid_598194
  var valid_598195 = query.getOrDefault("oauth_token")
  valid_598195 = validateParameter(valid_598195, JString, required = false,
                                 default = nil)
  if valid_598195 != nil:
    section.add "oauth_token", valid_598195
  var valid_598196 = query.getOrDefault("userIp")
  valid_598196 = validateParameter(valid_598196, JString, required = false,
                                 default = nil)
  if valid_598196 != nil:
    section.add "userIp", valid_598196
  var valid_598197 = query.getOrDefault("key")
  valid_598197 = validateParameter(valid_598197, JString, required = false,
                                 default = nil)
  if valid_598197 != nil:
    section.add "key", valid_598197
  var valid_598198 = query.getOrDefault("prettyPrint")
  valid_598198 = validateParameter(valid_598198, JBool, required = false,
                                 default = newJBool(true))
  if valid_598198 != nil:
    section.add "prettyPrint", valid_598198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598199: Call_AndroidpublisherEditsApklistingsGet_598185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the APK-specific localized listing for a specified APK and language code.
  ## 
  let valid = call_598199.validator(path, query, header, formData, body)
  let scheme = call_598199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598199.url(scheme.get, call_598199.host, call_598199.base,
                         call_598199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598199, url, valid)

proc call*(call_598200: Call_AndroidpublisherEditsApklistingsGet_598185;
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
  var path_598201 = newJObject()
  var query_598202 = newJObject()
  add(query_598202, "fields", newJString(fields))
  add(path_598201, "packageName", newJString(packageName))
  add(query_598202, "quotaUser", newJString(quotaUser))
  add(query_598202, "alt", newJString(alt))
  add(path_598201, "editId", newJString(editId))
  add(query_598202, "oauth_token", newJString(oauthToken))
  add(path_598201, "language", newJString(language))
  add(query_598202, "userIp", newJString(userIp))
  add(query_598202, "key", newJString(key))
  add(query_598202, "prettyPrint", newJBool(prettyPrint))
  add(path_598201, "apkVersionCode", newJInt(apkVersionCode))
  result = call_598200.call(path_598201, query_598202, nil, nil, nil)

var androidpublisherEditsApklistingsGet* = Call_AndroidpublisherEditsApklistingsGet_598185(
    name: "androidpublisherEditsApklistingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings/{language}",
    validator: validate_AndroidpublisherEditsApklistingsGet_598186,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsGet_598187, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsPatch_598241 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsApklistingsPatch_598243(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsApklistingsPatch_598242(path: JsonNode;
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
  var valid_598244 = path.getOrDefault("packageName")
  valid_598244 = validateParameter(valid_598244, JString, required = true,
                                 default = nil)
  if valid_598244 != nil:
    section.add "packageName", valid_598244
  var valid_598245 = path.getOrDefault("editId")
  valid_598245 = validateParameter(valid_598245, JString, required = true,
                                 default = nil)
  if valid_598245 != nil:
    section.add "editId", valid_598245
  var valid_598246 = path.getOrDefault("language")
  valid_598246 = validateParameter(valid_598246, JString, required = true,
                                 default = nil)
  if valid_598246 != nil:
    section.add "language", valid_598246
  var valid_598247 = path.getOrDefault("apkVersionCode")
  valid_598247 = validateParameter(valid_598247, JInt, required = true, default = nil)
  if valid_598247 != nil:
    section.add "apkVersionCode", valid_598247
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
  var valid_598248 = query.getOrDefault("fields")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = nil)
  if valid_598248 != nil:
    section.add "fields", valid_598248
  var valid_598249 = query.getOrDefault("quotaUser")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "quotaUser", valid_598249
  var valid_598250 = query.getOrDefault("alt")
  valid_598250 = validateParameter(valid_598250, JString, required = false,
                                 default = newJString("json"))
  if valid_598250 != nil:
    section.add "alt", valid_598250
  var valid_598251 = query.getOrDefault("oauth_token")
  valid_598251 = validateParameter(valid_598251, JString, required = false,
                                 default = nil)
  if valid_598251 != nil:
    section.add "oauth_token", valid_598251
  var valid_598252 = query.getOrDefault("userIp")
  valid_598252 = validateParameter(valid_598252, JString, required = false,
                                 default = nil)
  if valid_598252 != nil:
    section.add "userIp", valid_598252
  var valid_598253 = query.getOrDefault("key")
  valid_598253 = validateParameter(valid_598253, JString, required = false,
                                 default = nil)
  if valid_598253 != nil:
    section.add "key", valid_598253
  var valid_598254 = query.getOrDefault("prettyPrint")
  valid_598254 = validateParameter(valid_598254, JBool, required = false,
                                 default = newJBool(true))
  if valid_598254 != nil:
    section.add "prettyPrint", valid_598254
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

proc call*(call_598256: Call_AndroidpublisherEditsApklistingsPatch_598241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates or creates the APK-specific localized listing for a specified APK and language code. This method supports patch semantics.
  ## 
  let valid = call_598256.validator(path, query, header, formData, body)
  let scheme = call_598256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598256.url(scheme.get, call_598256.host, call_598256.base,
                         call_598256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598256, url, valid)

proc call*(call_598257: Call_AndroidpublisherEditsApklistingsPatch_598241;
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
  var path_598258 = newJObject()
  var query_598259 = newJObject()
  var body_598260 = newJObject()
  add(query_598259, "fields", newJString(fields))
  add(path_598258, "packageName", newJString(packageName))
  add(query_598259, "quotaUser", newJString(quotaUser))
  add(query_598259, "alt", newJString(alt))
  add(path_598258, "editId", newJString(editId))
  add(query_598259, "oauth_token", newJString(oauthToken))
  add(path_598258, "language", newJString(language))
  add(query_598259, "userIp", newJString(userIp))
  add(query_598259, "key", newJString(key))
  if body != nil:
    body_598260 = body
  add(query_598259, "prettyPrint", newJBool(prettyPrint))
  add(path_598258, "apkVersionCode", newJInt(apkVersionCode))
  result = call_598257.call(path_598258, query_598259, nil, nil, body_598260)

var androidpublisherEditsApklistingsPatch* = Call_AndroidpublisherEditsApklistingsPatch_598241(
    name: "androidpublisherEditsApklistingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings/{language}",
    validator: validate_AndroidpublisherEditsApklistingsPatch_598242,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsPatch_598243, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsDelete_598223 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsApklistingsDelete_598225(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsApklistingsDelete_598224(path: JsonNode;
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
  var valid_598226 = path.getOrDefault("packageName")
  valid_598226 = validateParameter(valid_598226, JString, required = true,
                                 default = nil)
  if valid_598226 != nil:
    section.add "packageName", valid_598226
  var valid_598227 = path.getOrDefault("editId")
  valid_598227 = validateParameter(valid_598227, JString, required = true,
                                 default = nil)
  if valid_598227 != nil:
    section.add "editId", valid_598227
  var valid_598228 = path.getOrDefault("language")
  valid_598228 = validateParameter(valid_598228, JString, required = true,
                                 default = nil)
  if valid_598228 != nil:
    section.add "language", valid_598228
  var valid_598229 = path.getOrDefault("apkVersionCode")
  valid_598229 = validateParameter(valid_598229, JInt, required = true, default = nil)
  if valid_598229 != nil:
    section.add "apkVersionCode", valid_598229
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
  var valid_598230 = query.getOrDefault("fields")
  valid_598230 = validateParameter(valid_598230, JString, required = false,
                                 default = nil)
  if valid_598230 != nil:
    section.add "fields", valid_598230
  var valid_598231 = query.getOrDefault("quotaUser")
  valid_598231 = validateParameter(valid_598231, JString, required = false,
                                 default = nil)
  if valid_598231 != nil:
    section.add "quotaUser", valid_598231
  var valid_598232 = query.getOrDefault("alt")
  valid_598232 = validateParameter(valid_598232, JString, required = false,
                                 default = newJString("json"))
  if valid_598232 != nil:
    section.add "alt", valid_598232
  var valid_598233 = query.getOrDefault("oauth_token")
  valid_598233 = validateParameter(valid_598233, JString, required = false,
                                 default = nil)
  if valid_598233 != nil:
    section.add "oauth_token", valid_598233
  var valid_598234 = query.getOrDefault("userIp")
  valid_598234 = validateParameter(valid_598234, JString, required = false,
                                 default = nil)
  if valid_598234 != nil:
    section.add "userIp", valid_598234
  var valid_598235 = query.getOrDefault("key")
  valid_598235 = validateParameter(valid_598235, JString, required = false,
                                 default = nil)
  if valid_598235 != nil:
    section.add "key", valid_598235
  var valid_598236 = query.getOrDefault("prettyPrint")
  valid_598236 = validateParameter(valid_598236, JBool, required = false,
                                 default = newJBool(true))
  if valid_598236 != nil:
    section.add "prettyPrint", valid_598236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598237: Call_AndroidpublisherEditsApklistingsDelete_598223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the APK-specific localized listing for a specified APK and language code.
  ## 
  let valid = call_598237.validator(path, query, header, formData, body)
  let scheme = call_598237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598237.url(scheme.get, call_598237.host, call_598237.base,
                         call_598237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598237, url, valid)

proc call*(call_598238: Call_AndroidpublisherEditsApklistingsDelete_598223;
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
  var path_598239 = newJObject()
  var query_598240 = newJObject()
  add(query_598240, "fields", newJString(fields))
  add(path_598239, "packageName", newJString(packageName))
  add(query_598240, "quotaUser", newJString(quotaUser))
  add(query_598240, "alt", newJString(alt))
  add(path_598239, "editId", newJString(editId))
  add(query_598240, "oauth_token", newJString(oauthToken))
  add(path_598239, "language", newJString(language))
  add(query_598240, "userIp", newJString(userIp))
  add(query_598240, "key", newJString(key))
  add(query_598240, "prettyPrint", newJBool(prettyPrint))
  add(path_598239, "apkVersionCode", newJInt(apkVersionCode))
  result = call_598238.call(path_598239, query_598240, nil, nil, nil)

var androidpublisherEditsApklistingsDelete* = Call_AndroidpublisherEditsApklistingsDelete_598223(
    name: "androidpublisherEditsApklistingsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings/{language}",
    validator: validate_AndroidpublisherEditsApklistingsDelete_598224,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsDelete_598225,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsBundlesUpload_598277 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsBundlesUpload_598279(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsBundlesUpload_598278(path: JsonNode;
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
  var valid_598280 = path.getOrDefault("packageName")
  valid_598280 = validateParameter(valid_598280, JString, required = true,
                                 default = nil)
  if valid_598280 != nil:
    section.add "packageName", valid_598280
  var valid_598281 = path.getOrDefault("editId")
  valid_598281 = validateParameter(valid_598281, JString, required = true,
                                 default = nil)
  if valid_598281 != nil:
    section.add "editId", valid_598281
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
  var valid_598282 = query.getOrDefault("fields")
  valid_598282 = validateParameter(valid_598282, JString, required = false,
                                 default = nil)
  if valid_598282 != nil:
    section.add "fields", valid_598282
  var valid_598283 = query.getOrDefault("quotaUser")
  valid_598283 = validateParameter(valid_598283, JString, required = false,
                                 default = nil)
  if valid_598283 != nil:
    section.add "quotaUser", valid_598283
  var valid_598284 = query.getOrDefault("alt")
  valid_598284 = validateParameter(valid_598284, JString, required = false,
                                 default = newJString("json"))
  if valid_598284 != nil:
    section.add "alt", valid_598284
  var valid_598285 = query.getOrDefault("oauth_token")
  valid_598285 = validateParameter(valid_598285, JString, required = false,
                                 default = nil)
  if valid_598285 != nil:
    section.add "oauth_token", valid_598285
  var valid_598286 = query.getOrDefault("userIp")
  valid_598286 = validateParameter(valid_598286, JString, required = false,
                                 default = nil)
  if valid_598286 != nil:
    section.add "userIp", valid_598286
  var valid_598287 = query.getOrDefault("key")
  valid_598287 = validateParameter(valid_598287, JString, required = false,
                                 default = nil)
  if valid_598287 != nil:
    section.add "key", valid_598287
  var valid_598288 = query.getOrDefault("prettyPrint")
  valid_598288 = validateParameter(valid_598288, JBool, required = false,
                                 default = newJBool(true))
  if valid_598288 != nil:
    section.add "prettyPrint", valid_598288
  var valid_598289 = query.getOrDefault("ackBundleInstallationWarning")
  valid_598289 = validateParameter(valid_598289, JBool, required = false, default = nil)
  if valid_598289 != nil:
    section.add "ackBundleInstallationWarning", valid_598289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598290: Call_AndroidpublisherEditsBundlesUpload_598277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a new Android App Bundle to this edit. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  let valid = call_598290.validator(path, query, header, formData, body)
  let scheme = call_598290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598290.url(scheme.get, call_598290.host, call_598290.base,
                         call_598290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598290, url, valid)

proc call*(call_598291: Call_AndroidpublisherEditsBundlesUpload_598277;
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
  var path_598292 = newJObject()
  var query_598293 = newJObject()
  add(query_598293, "fields", newJString(fields))
  add(path_598292, "packageName", newJString(packageName))
  add(query_598293, "quotaUser", newJString(quotaUser))
  add(query_598293, "alt", newJString(alt))
  add(path_598292, "editId", newJString(editId))
  add(query_598293, "oauth_token", newJString(oauthToken))
  add(query_598293, "userIp", newJString(userIp))
  add(query_598293, "key", newJString(key))
  add(query_598293, "prettyPrint", newJBool(prettyPrint))
  add(query_598293, "ackBundleInstallationWarning",
      newJBool(ackBundleInstallationWarning))
  result = call_598291.call(path_598292, query_598293, nil, nil, nil)

var androidpublisherEditsBundlesUpload* = Call_AndroidpublisherEditsBundlesUpload_598277(
    name: "androidpublisherEditsBundlesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/bundles",
    validator: validate_AndroidpublisherEditsBundlesUpload_598278,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsBundlesUpload_598279, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsBundlesList_598261 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsBundlesList_598263(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsBundlesList_598262(path: JsonNode;
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
  var valid_598264 = path.getOrDefault("packageName")
  valid_598264 = validateParameter(valid_598264, JString, required = true,
                                 default = nil)
  if valid_598264 != nil:
    section.add "packageName", valid_598264
  var valid_598265 = path.getOrDefault("editId")
  valid_598265 = validateParameter(valid_598265, JString, required = true,
                                 default = nil)
  if valid_598265 != nil:
    section.add "editId", valid_598265
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
  var valid_598266 = query.getOrDefault("fields")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = nil)
  if valid_598266 != nil:
    section.add "fields", valid_598266
  var valid_598267 = query.getOrDefault("quotaUser")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = nil)
  if valid_598267 != nil:
    section.add "quotaUser", valid_598267
  var valid_598268 = query.getOrDefault("alt")
  valid_598268 = validateParameter(valid_598268, JString, required = false,
                                 default = newJString("json"))
  if valid_598268 != nil:
    section.add "alt", valid_598268
  var valid_598269 = query.getOrDefault("oauth_token")
  valid_598269 = validateParameter(valid_598269, JString, required = false,
                                 default = nil)
  if valid_598269 != nil:
    section.add "oauth_token", valid_598269
  var valid_598270 = query.getOrDefault("userIp")
  valid_598270 = validateParameter(valid_598270, JString, required = false,
                                 default = nil)
  if valid_598270 != nil:
    section.add "userIp", valid_598270
  var valid_598271 = query.getOrDefault("key")
  valid_598271 = validateParameter(valid_598271, JString, required = false,
                                 default = nil)
  if valid_598271 != nil:
    section.add "key", valid_598271
  var valid_598272 = query.getOrDefault("prettyPrint")
  valid_598272 = validateParameter(valid_598272, JBool, required = false,
                                 default = newJBool(true))
  if valid_598272 != nil:
    section.add "prettyPrint", valid_598272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598273: Call_AndroidpublisherEditsBundlesList_598261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_598273.validator(path, query, header, formData, body)
  let scheme = call_598273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598273.url(scheme.get, call_598273.host, call_598273.base,
                         call_598273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598273, url, valid)

proc call*(call_598274: Call_AndroidpublisherEditsBundlesList_598261;
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
  var path_598275 = newJObject()
  var query_598276 = newJObject()
  add(query_598276, "fields", newJString(fields))
  add(path_598275, "packageName", newJString(packageName))
  add(query_598276, "quotaUser", newJString(quotaUser))
  add(query_598276, "alt", newJString(alt))
  add(path_598275, "editId", newJString(editId))
  add(query_598276, "oauth_token", newJString(oauthToken))
  add(query_598276, "userIp", newJString(userIp))
  add(query_598276, "key", newJString(key))
  add(query_598276, "prettyPrint", newJBool(prettyPrint))
  result = call_598274.call(path_598275, query_598276, nil, nil, nil)

var androidpublisherEditsBundlesList* = Call_AndroidpublisherEditsBundlesList_598261(
    name: "androidpublisherEditsBundlesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/bundles",
    validator: validate_AndroidpublisherEditsBundlesList_598262,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsBundlesList_598263, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsUpdate_598310 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsDetailsUpdate_598312(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsDetailsUpdate_598311(path: JsonNode;
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
  var valid_598313 = path.getOrDefault("packageName")
  valid_598313 = validateParameter(valid_598313, JString, required = true,
                                 default = nil)
  if valid_598313 != nil:
    section.add "packageName", valid_598313
  var valid_598314 = path.getOrDefault("editId")
  valid_598314 = validateParameter(valid_598314, JString, required = true,
                                 default = nil)
  if valid_598314 != nil:
    section.add "editId", valid_598314
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
  var valid_598315 = query.getOrDefault("fields")
  valid_598315 = validateParameter(valid_598315, JString, required = false,
                                 default = nil)
  if valid_598315 != nil:
    section.add "fields", valid_598315
  var valid_598316 = query.getOrDefault("quotaUser")
  valid_598316 = validateParameter(valid_598316, JString, required = false,
                                 default = nil)
  if valid_598316 != nil:
    section.add "quotaUser", valid_598316
  var valid_598317 = query.getOrDefault("alt")
  valid_598317 = validateParameter(valid_598317, JString, required = false,
                                 default = newJString("json"))
  if valid_598317 != nil:
    section.add "alt", valid_598317
  var valid_598318 = query.getOrDefault("oauth_token")
  valid_598318 = validateParameter(valid_598318, JString, required = false,
                                 default = nil)
  if valid_598318 != nil:
    section.add "oauth_token", valid_598318
  var valid_598319 = query.getOrDefault("userIp")
  valid_598319 = validateParameter(valid_598319, JString, required = false,
                                 default = nil)
  if valid_598319 != nil:
    section.add "userIp", valid_598319
  var valid_598320 = query.getOrDefault("key")
  valid_598320 = validateParameter(valid_598320, JString, required = false,
                                 default = nil)
  if valid_598320 != nil:
    section.add "key", valid_598320
  var valid_598321 = query.getOrDefault("prettyPrint")
  valid_598321 = validateParameter(valid_598321, JBool, required = false,
                                 default = newJBool(true))
  if valid_598321 != nil:
    section.add "prettyPrint", valid_598321
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

proc call*(call_598323: Call_AndroidpublisherEditsDetailsUpdate_598310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates app details for this edit.
  ## 
  let valid = call_598323.validator(path, query, header, formData, body)
  let scheme = call_598323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598323.url(scheme.get, call_598323.host, call_598323.base,
                         call_598323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598323, url, valid)

proc call*(call_598324: Call_AndroidpublisherEditsDetailsUpdate_598310;
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
  var path_598325 = newJObject()
  var query_598326 = newJObject()
  var body_598327 = newJObject()
  add(query_598326, "fields", newJString(fields))
  add(path_598325, "packageName", newJString(packageName))
  add(query_598326, "quotaUser", newJString(quotaUser))
  add(query_598326, "alt", newJString(alt))
  add(path_598325, "editId", newJString(editId))
  add(query_598326, "oauth_token", newJString(oauthToken))
  add(query_598326, "userIp", newJString(userIp))
  add(query_598326, "key", newJString(key))
  if body != nil:
    body_598327 = body
  add(query_598326, "prettyPrint", newJBool(prettyPrint))
  result = call_598324.call(path_598325, query_598326, nil, nil, body_598327)

var androidpublisherEditsDetailsUpdate* = Call_AndroidpublisherEditsDetailsUpdate_598310(
    name: "androidpublisherEditsDetailsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsUpdate_598311,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDetailsUpdate_598312, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsGet_598294 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsDetailsGet_598296(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsDetailsGet_598295(path: JsonNode;
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
  var valid_598297 = path.getOrDefault("packageName")
  valid_598297 = validateParameter(valid_598297, JString, required = true,
                                 default = nil)
  if valid_598297 != nil:
    section.add "packageName", valid_598297
  var valid_598298 = path.getOrDefault("editId")
  valid_598298 = validateParameter(valid_598298, JString, required = true,
                                 default = nil)
  if valid_598298 != nil:
    section.add "editId", valid_598298
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
  var valid_598299 = query.getOrDefault("fields")
  valid_598299 = validateParameter(valid_598299, JString, required = false,
                                 default = nil)
  if valid_598299 != nil:
    section.add "fields", valid_598299
  var valid_598300 = query.getOrDefault("quotaUser")
  valid_598300 = validateParameter(valid_598300, JString, required = false,
                                 default = nil)
  if valid_598300 != nil:
    section.add "quotaUser", valid_598300
  var valid_598301 = query.getOrDefault("alt")
  valid_598301 = validateParameter(valid_598301, JString, required = false,
                                 default = newJString("json"))
  if valid_598301 != nil:
    section.add "alt", valid_598301
  var valid_598302 = query.getOrDefault("oauth_token")
  valid_598302 = validateParameter(valid_598302, JString, required = false,
                                 default = nil)
  if valid_598302 != nil:
    section.add "oauth_token", valid_598302
  var valid_598303 = query.getOrDefault("userIp")
  valid_598303 = validateParameter(valid_598303, JString, required = false,
                                 default = nil)
  if valid_598303 != nil:
    section.add "userIp", valid_598303
  var valid_598304 = query.getOrDefault("key")
  valid_598304 = validateParameter(valid_598304, JString, required = false,
                                 default = nil)
  if valid_598304 != nil:
    section.add "key", valid_598304
  var valid_598305 = query.getOrDefault("prettyPrint")
  valid_598305 = validateParameter(valid_598305, JBool, required = false,
                                 default = newJBool(true))
  if valid_598305 != nil:
    section.add "prettyPrint", valid_598305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598306: Call_AndroidpublisherEditsDetailsGet_598294;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches app details for this edit. This includes the default language and developer support contact information.
  ## 
  let valid = call_598306.validator(path, query, header, formData, body)
  let scheme = call_598306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598306.url(scheme.get, call_598306.host, call_598306.base,
                         call_598306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598306, url, valid)

proc call*(call_598307: Call_AndroidpublisherEditsDetailsGet_598294;
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
  var path_598308 = newJObject()
  var query_598309 = newJObject()
  add(query_598309, "fields", newJString(fields))
  add(path_598308, "packageName", newJString(packageName))
  add(query_598309, "quotaUser", newJString(quotaUser))
  add(query_598309, "alt", newJString(alt))
  add(path_598308, "editId", newJString(editId))
  add(query_598309, "oauth_token", newJString(oauthToken))
  add(query_598309, "userIp", newJString(userIp))
  add(query_598309, "key", newJString(key))
  add(query_598309, "prettyPrint", newJBool(prettyPrint))
  result = call_598307.call(path_598308, query_598309, nil, nil, nil)

var androidpublisherEditsDetailsGet* = Call_AndroidpublisherEditsDetailsGet_598294(
    name: "androidpublisherEditsDetailsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsGet_598295,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDetailsGet_598296, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsPatch_598328 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsDetailsPatch_598330(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsDetailsPatch_598329(path: JsonNode;
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
  var valid_598331 = path.getOrDefault("packageName")
  valid_598331 = validateParameter(valid_598331, JString, required = true,
                                 default = nil)
  if valid_598331 != nil:
    section.add "packageName", valid_598331
  var valid_598332 = path.getOrDefault("editId")
  valid_598332 = validateParameter(valid_598332, JString, required = true,
                                 default = nil)
  if valid_598332 != nil:
    section.add "editId", valid_598332
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
  var valid_598333 = query.getOrDefault("fields")
  valid_598333 = validateParameter(valid_598333, JString, required = false,
                                 default = nil)
  if valid_598333 != nil:
    section.add "fields", valid_598333
  var valid_598334 = query.getOrDefault("quotaUser")
  valid_598334 = validateParameter(valid_598334, JString, required = false,
                                 default = nil)
  if valid_598334 != nil:
    section.add "quotaUser", valid_598334
  var valid_598335 = query.getOrDefault("alt")
  valid_598335 = validateParameter(valid_598335, JString, required = false,
                                 default = newJString("json"))
  if valid_598335 != nil:
    section.add "alt", valid_598335
  var valid_598336 = query.getOrDefault("oauth_token")
  valid_598336 = validateParameter(valid_598336, JString, required = false,
                                 default = nil)
  if valid_598336 != nil:
    section.add "oauth_token", valid_598336
  var valid_598337 = query.getOrDefault("userIp")
  valid_598337 = validateParameter(valid_598337, JString, required = false,
                                 default = nil)
  if valid_598337 != nil:
    section.add "userIp", valid_598337
  var valid_598338 = query.getOrDefault("key")
  valid_598338 = validateParameter(valid_598338, JString, required = false,
                                 default = nil)
  if valid_598338 != nil:
    section.add "key", valid_598338
  var valid_598339 = query.getOrDefault("prettyPrint")
  valid_598339 = validateParameter(valid_598339, JBool, required = false,
                                 default = newJBool(true))
  if valid_598339 != nil:
    section.add "prettyPrint", valid_598339
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

proc call*(call_598341: Call_AndroidpublisherEditsDetailsPatch_598328;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates app details for this edit. This method supports patch semantics.
  ## 
  let valid = call_598341.validator(path, query, header, formData, body)
  let scheme = call_598341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598341.url(scheme.get, call_598341.host, call_598341.base,
                         call_598341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598341, url, valid)

proc call*(call_598342: Call_AndroidpublisherEditsDetailsPatch_598328;
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
  var path_598343 = newJObject()
  var query_598344 = newJObject()
  var body_598345 = newJObject()
  add(query_598344, "fields", newJString(fields))
  add(path_598343, "packageName", newJString(packageName))
  add(query_598344, "quotaUser", newJString(quotaUser))
  add(query_598344, "alt", newJString(alt))
  add(path_598343, "editId", newJString(editId))
  add(query_598344, "oauth_token", newJString(oauthToken))
  add(query_598344, "userIp", newJString(userIp))
  add(query_598344, "key", newJString(key))
  if body != nil:
    body_598345 = body
  add(query_598344, "prettyPrint", newJBool(prettyPrint))
  result = call_598342.call(path_598343, query_598344, nil, nil, body_598345)

var androidpublisherEditsDetailsPatch* = Call_AndroidpublisherEditsDetailsPatch_598328(
    name: "androidpublisherEditsDetailsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsPatch_598329,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDetailsPatch_598330, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsList_598346 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsListingsList_598348(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsListingsList_598347(path: JsonNode;
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
  var valid_598349 = path.getOrDefault("packageName")
  valid_598349 = validateParameter(valid_598349, JString, required = true,
                                 default = nil)
  if valid_598349 != nil:
    section.add "packageName", valid_598349
  var valid_598350 = path.getOrDefault("editId")
  valid_598350 = validateParameter(valid_598350, JString, required = true,
                                 default = nil)
  if valid_598350 != nil:
    section.add "editId", valid_598350
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
  var valid_598351 = query.getOrDefault("fields")
  valid_598351 = validateParameter(valid_598351, JString, required = false,
                                 default = nil)
  if valid_598351 != nil:
    section.add "fields", valid_598351
  var valid_598352 = query.getOrDefault("quotaUser")
  valid_598352 = validateParameter(valid_598352, JString, required = false,
                                 default = nil)
  if valid_598352 != nil:
    section.add "quotaUser", valid_598352
  var valid_598353 = query.getOrDefault("alt")
  valid_598353 = validateParameter(valid_598353, JString, required = false,
                                 default = newJString("json"))
  if valid_598353 != nil:
    section.add "alt", valid_598353
  var valid_598354 = query.getOrDefault("oauth_token")
  valid_598354 = validateParameter(valid_598354, JString, required = false,
                                 default = nil)
  if valid_598354 != nil:
    section.add "oauth_token", valid_598354
  var valid_598355 = query.getOrDefault("userIp")
  valid_598355 = validateParameter(valid_598355, JString, required = false,
                                 default = nil)
  if valid_598355 != nil:
    section.add "userIp", valid_598355
  var valid_598356 = query.getOrDefault("key")
  valid_598356 = validateParameter(valid_598356, JString, required = false,
                                 default = nil)
  if valid_598356 != nil:
    section.add "key", valid_598356
  var valid_598357 = query.getOrDefault("prettyPrint")
  valid_598357 = validateParameter(valid_598357, JBool, required = false,
                                 default = newJBool(true))
  if valid_598357 != nil:
    section.add "prettyPrint", valid_598357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598358: Call_AndroidpublisherEditsListingsList_598346;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all of the localized store listings attached to this edit.
  ## 
  let valid = call_598358.validator(path, query, header, formData, body)
  let scheme = call_598358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598358.url(scheme.get, call_598358.host, call_598358.base,
                         call_598358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598358, url, valid)

proc call*(call_598359: Call_AndroidpublisherEditsListingsList_598346;
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
  var path_598360 = newJObject()
  var query_598361 = newJObject()
  add(query_598361, "fields", newJString(fields))
  add(path_598360, "packageName", newJString(packageName))
  add(query_598361, "quotaUser", newJString(quotaUser))
  add(query_598361, "alt", newJString(alt))
  add(path_598360, "editId", newJString(editId))
  add(query_598361, "oauth_token", newJString(oauthToken))
  add(query_598361, "userIp", newJString(userIp))
  add(query_598361, "key", newJString(key))
  add(query_598361, "prettyPrint", newJBool(prettyPrint))
  result = call_598359.call(path_598360, query_598361, nil, nil, nil)

var androidpublisherEditsListingsList* = Call_AndroidpublisherEditsListingsList_598346(
    name: "androidpublisherEditsListingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings",
    validator: validate_AndroidpublisherEditsListingsList_598347,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsList_598348, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsDeleteall_598362 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsListingsDeleteall_598364(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsListingsDeleteall_598363(path: JsonNode;
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
  var valid_598365 = path.getOrDefault("packageName")
  valid_598365 = validateParameter(valid_598365, JString, required = true,
                                 default = nil)
  if valid_598365 != nil:
    section.add "packageName", valid_598365
  var valid_598366 = path.getOrDefault("editId")
  valid_598366 = validateParameter(valid_598366, JString, required = true,
                                 default = nil)
  if valid_598366 != nil:
    section.add "editId", valid_598366
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
  var valid_598367 = query.getOrDefault("fields")
  valid_598367 = validateParameter(valid_598367, JString, required = false,
                                 default = nil)
  if valid_598367 != nil:
    section.add "fields", valid_598367
  var valid_598368 = query.getOrDefault("quotaUser")
  valid_598368 = validateParameter(valid_598368, JString, required = false,
                                 default = nil)
  if valid_598368 != nil:
    section.add "quotaUser", valid_598368
  var valid_598369 = query.getOrDefault("alt")
  valid_598369 = validateParameter(valid_598369, JString, required = false,
                                 default = newJString("json"))
  if valid_598369 != nil:
    section.add "alt", valid_598369
  var valid_598370 = query.getOrDefault("oauth_token")
  valid_598370 = validateParameter(valid_598370, JString, required = false,
                                 default = nil)
  if valid_598370 != nil:
    section.add "oauth_token", valid_598370
  var valid_598371 = query.getOrDefault("userIp")
  valid_598371 = validateParameter(valid_598371, JString, required = false,
                                 default = nil)
  if valid_598371 != nil:
    section.add "userIp", valid_598371
  var valid_598372 = query.getOrDefault("key")
  valid_598372 = validateParameter(valid_598372, JString, required = false,
                                 default = nil)
  if valid_598372 != nil:
    section.add "key", valid_598372
  var valid_598373 = query.getOrDefault("prettyPrint")
  valid_598373 = validateParameter(valid_598373, JBool, required = false,
                                 default = newJBool(true))
  if valid_598373 != nil:
    section.add "prettyPrint", valid_598373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598374: Call_AndroidpublisherEditsListingsDeleteall_598362;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all localized listings from an edit.
  ## 
  let valid = call_598374.validator(path, query, header, formData, body)
  let scheme = call_598374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598374.url(scheme.get, call_598374.host, call_598374.base,
                         call_598374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598374, url, valid)

proc call*(call_598375: Call_AndroidpublisherEditsListingsDeleteall_598362;
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
  var path_598376 = newJObject()
  var query_598377 = newJObject()
  add(query_598377, "fields", newJString(fields))
  add(path_598376, "packageName", newJString(packageName))
  add(query_598377, "quotaUser", newJString(quotaUser))
  add(query_598377, "alt", newJString(alt))
  add(path_598376, "editId", newJString(editId))
  add(query_598377, "oauth_token", newJString(oauthToken))
  add(query_598377, "userIp", newJString(userIp))
  add(query_598377, "key", newJString(key))
  add(query_598377, "prettyPrint", newJBool(prettyPrint))
  result = call_598375.call(path_598376, query_598377, nil, nil, nil)

var androidpublisherEditsListingsDeleteall* = Call_AndroidpublisherEditsListingsDeleteall_598362(
    name: "androidpublisherEditsListingsDeleteall", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings",
    validator: validate_AndroidpublisherEditsListingsDeleteall_598363,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsDeleteall_598364,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsUpdate_598395 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsListingsUpdate_598397(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsListingsUpdate_598396(path: JsonNode;
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
  var valid_598398 = path.getOrDefault("packageName")
  valid_598398 = validateParameter(valid_598398, JString, required = true,
                                 default = nil)
  if valid_598398 != nil:
    section.add "packageName", valid_598398
  var valid_598399 = path.getOrDefault("editId")
  valid_598399 = validateParameter(valid_598399, JString, required = true,
                                 default = nil)
  if valid_598399 != nil:
    section.add "editId", valid_598399
  var valid_598400 = path.getOrDefault("language")
  valid_598400 = validateParameter(valid_598400, JString, required = true,
                                 default = nil)
  if valid_598400 != nil:
    section.add "language", valid_598400
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
  var valid_598401 = query.getOrDefault("fields")
  valid_598401 = validateParameter(valid_598401, JString, required = false,
                                 default = nil)
  if valid_598401 != nil:
    section.add "fields", valid_598401
  var valid_598402 = query.getOrDefault("quotaUser")
  valid_598402 = validateParameter(valid_598402, JString, required = false,
                                 default = nil)
  if valid_598402 != nil:
    section.add "quotaUser", valid_598402
  var valid_598403 = query.getOrDefault("alt")
  valid_598403 = validateParameter(valid_598403, JString, required = false,
                                 default = newJString("json"))
  if valid_598403 != nil:
    section.add "alt", valid_598403
  var valid_598404 = query.getOrDefault("oauth_token")
  valid_598404 = validateParameter(valid_598404, JString, required = false,
                                 default = nil)
  if valid_598404 != nil:
    section.add "oauth_token", valid_598404
  var valid_598405 = query.getOrDefault("userIp")
  valid_598405 = validateParameter(valid_598405, JString, required = false,
                                 default = nil)
  if valid_598405 != nil:
    section.add "userIp", valid_598405
  var valid_598406 = query.getOrDefault("key")
  valid_598406 = validateParameter(valid_598406, JString, required = false,
                                 default = nil)
  if valid_598406 != nil:
    section.add "key", valid_598406
  var valid_598407 = query.getOrDefault("prettyPrint")
  valid_598407 = validateParameter(valid_598407, JBool, required = false,
                                 default = newJBool(true))
  if valid_598407 != nil:
    section.add "prettyPrint", valid_598407
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

proc call*(call_598409: Call_AndroidpublisherEditsListingsUpdate_598395;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a localized store listing.
  ## 
  let valid = call_598409.validator(path, query, header, formData, body)
  let scheme = call_598409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598409.url(scheme.get, call_598409.host, call_598409.base,
                         call_598409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598409, url, valid)

proc call*(call_598410: Call_AndroidpublisherEditsListingsUpdate_598395;
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
  var path_598411 = newJObject()
  var query_598412 = newJObject()
  var body_598413 = newJObject()
  add(query_598412, "fields", newJString(fields))
  add(path_598411, "packageName", newJString(packageName))
  add(query_598412, "quotaUser", newJString(quotaUser))
  add(query_598412, "alt", newJString(alt))
  add(path_598411, "editId", newJString(editId))
  add(query_598412, "oauth_token", newJString(oauthToken))
  add(path_598411, "language", newJString(language))
  add(query_598412, "userIp", newJString(userIp))
  add(query_598412, "key", newJString(key))
  if body != nil:
    body_598413 = body
  add(query_598412, "prettyPrint", newJBool(prettyPrint))
  result = call_598410.call(path_598411, query_598412, nil, nil, body_598413)

var androidpublisherEditsListingsUpdate* = Call_AndroidpublisherEditsListingsUpdate_598395(
    name: "androidpublisherEditsListingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsUpdate_598396,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsUpdate_598397, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsGet_598378 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsListingsGet_598380(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsListingsGet_598379(path: JsonNode;
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
  var valid_598381 = path.getOrDefault("packageName")
  valid_598381 = validateParameter(valid_598381, JString, required = true,
                                 default = nil)
  if valid_598381 != nil:
    section.add "packageName", valid_598381
  var valid_598382 = path.getOrDefault("editId")
  valid_598382 = validateParameter(valid_598382, JString, required = true,
                                 default = nil)
  if valid_598382 != nil:
    section.add "editId", valid_598382
  var valid_598383 = path.getOrDefault("language")
  valid_598383 = validateParameter(valid_598383, JString, required = true,
                                 default = nil)
  if valid_598383 != nil:
    section.add "language", valid_598383
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
  var valid_598384 = query.getOrDefault("fields")
  valid_598384 = validateParameter(valid_598384, JString, required = false,
                                 default = nil)
  if valid_598384 != nil:
    section.add "fields", valid_598384
  var valid_598385 = query.getOrDefault("quotaUser")
  valid_598385 = validateParameter(valid_598385, JString, required = false,
                                 default = nil)
  if valid_598385 != nil:
    section.add "quotaUser", valid_598385
  var valid_598386 = query.getOrDefault("alt")
  valid_598386 = validateParameter(valid_598386, JString, required = false,
                                 default = newJString("json"))
  if valid_598386 != nil:
    section.add "alt", valid_598386
  var valid_598387 = query.getOrDefault("oauth_token")
  valid_598387 = validateParameter(valid_598387, JString, required = false,
                                 default = nil)
  if valid_598387 != nil:
    section.add "oauth_token", valid_598387
  var valid_598388 = query.getOrDefault("userIp")
  valid_598388 = validateParameter(valid_598388, JString, required = false,
                                 default = nil)
  if valid_598388 != nil:
    section.add "userIp", valid_598388
  var valid_598389 = query.getOrDefault("key")
  valid_598389 = validateParameter(valid_598389, JString, required = false,
                                 default = nil)
  if valid_598389 != nil:
    section.add "key", valid_598389
  var valid_598390 = query.getOrDefault("prettyPrint")
  valid_598390 = validateParameter(valid_598390, JBool, required = false,
                                 default = newJBool(true))
  if valid_598390 != nil:
    section.add "prettyPrint", valid_598390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598391: Call_AndroidpublisherEditsListingsGet_598378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches information about a localized store listing.
  ## 
  let valid = call_598391.validator(path, query, header, formData, body)
  let scheme = call_598391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598391.url(scheme.get, call_598391.host, call_598391.base,
                         call_598391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598391, url, valid)

proc call*(call_598392: Call_AndroidpublisherEditsListingsGet_598378;
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
  var path_598393 = newJObject()
  var query_598394 = newJObject()
  add(query_598394, "fields", newJString(fields))
  add(path_598393, "packageName", newJString(packageName))
  add(query_598394, "quotaUser", newJString(quotaUser))
  add(query_598394, "alt", newJString(alt))
  add(path_598393, "editId", newJString(editId))
  add(query_598394, "oauth_token", newJString(oauthToken))
  add(path_598393, "language", newJString(language))
  add(query_598394, "userIp", newJString(userIp))
  add(query_598394, "key", newJString(key))
  add(query_598394, "prettyPrint", newJBool(prettyPrint))
  result = call_598392.call(path_598393, query_598394, nil, nil, nil)

var androidpublisherEditsListingsGet* = Call_AndroidpublisherEditsListingsGet_598378(
    name: "androidpublisherEditsListingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsGet_598379,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsGet_598380, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsPatch_598431 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsListingsPatch_598433(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsListingsPatch_598432(path: JsonNode;
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
  var valid_598434 = path.getOrDefault("packageName")
  valid_598434 = validateParameter(valid_598434, JString, required = true,
                                 default = nil)
  if valid_598434 != nil:
    section.add "packageName", valid_598434
  var valid_598435 = path.getOrDefault("editId")
  valid_598435 = validateParameter(valid_598435, JString, required = true,
                                 default = nil)
  if valid_598435 != nil:
    section.add "editId", valid_598435
  var valid_598436 = path.getOrDefault("language")
  valid_598436 = validateParameter(valid_598436, JString, required = true,
                                 default = nil)
  if valid_598436 != nil:
    section.add "language", valid_598436
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
  var valid_598437 = query.getOrDefault("fields")
  valid_598437 = validateParameter(valid_598437, JString, required = false,
                                 default = nil)
  if valid_598437 != nil:
    section.add "fields", valid_598437
  var valid_598438 = query.getOrDefault("quotaUser")
  valid_598438 = validateParameter(valid_598438, JString, required = false,
                                 default = nil)
  if valid_598438 != nil:
    section.add "quotaUser", valid_598438
  var valid_598439 = query.getOrDefault("alt")
  valid_598439 = validateParameter(valid_598439, JString, required = false,
                                 default = newJString("json"))
  if valid_598439 != nil:
    section.add "alt", valid_598439
  var valid_598440 = query.getOrDefault("oauth_token")
  valid_598440 = validateParameter(valid_598440, JString, required = false,
                                 default = nil)
  if valid_598440 != nil:
    section.add "oauth_token", valid_598440
  var valid_598441 = query.getOrDefault("userIp")
  valid_598441 = validateParameter(valid_598441, JString, required = false,
                                 default = nil)
  if valid_598441 != nil:
    section.add "userIp", valid_598441
  var valid_598442 = query.getOrDefault("key")
  valid_598442 = validateParameter(valid_598442, JString, required = false,
                                 default = nil)
  if valid_598442 != nil:
    section.add "key", valid_598442
  var valid_598443 = query.getOrDefault("prettyPrint")
  valid_598443 = validateParameter(valid_598443, JBool, required = false,
                                 default = newJBool(true))
  if valid_598443 != nil:
    section.add "prettyPrint", valid_598443
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

proc call*(call_598445: Call_AndroidpublisherEditsListingsPatch_598431;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a localized store listing. This method supports patch semantics.
  ## 
  let valid = call_598445.validator(path, query, header, formData, body)
  let scheme = call_598445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598445.url(scheme.get, call_598445.host, call_598445.base,
                         call_598445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598445, url, valid)

proc call*(call_598446: Call_AndroidpublisherEditsListingsPatch_598431;
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
  var path_598447 = newJObject()
  var query_598448 = newJObject()
  var body_598449 = newJObject()
  add(query_598448, "fields", newJString(fields))
  add(path_598447, "packageName", newJString(packageName))
  add(query_598448, "quotaUser", newJString(quotaUser))
  add(query_598448, "alt", newJString(alt))
  add(path_598447, "editId", newJString(editId))
  add(query_598448, "oauth_token", newJString(oauthToken))
  add(path_598447, "language", newJString(language))
  add(query_598448, "userIp", newJString(userIp))
  add(query_598448, "key", newJString(key))
  if body != nil:
    body_598449 = body
  add(query_598448, "prettyPrint", newJBool(prettyPrint))
  result = call_598446.call(path_598447, query_598448, nil, nil, body_598449)

var androidpublisherEditsListingsPatch* = Call_AndroidpublisherEditsListingsPatch_598431(
    name: "androidpublisherEditsListingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsPatch_598432,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsPatch_598433, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsDelete_598414 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsListingsDelete_598416(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsListingsDelete_598415(path: JsonNode;
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
  var valid_598417 = path.getOrDefault("packageName")
  valid_598417 = validateParameter(valid_598417, JString, required = true,
                                 default = nil)
  if valid_598417 != nil:
    section.add "packageName", valid_598417
  var valid_598418 = path.getOrDefault("editId")
  valid_598418 = validateParameter(valid_598418, JString, required = true,
                                 default = nil)
  if valid_598418 != nil:
    section.add "editId", valid_598418
  var valid_598419 = path.getOrDefault("language")
  valid_598419 = validateParameter(valid_598419, JString, required = true,
                                 default = nil)
  if valid_598419 != nil:
    section.add "language", valid_598419
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
  var valid_598420 = query.getOrDefault("fields")
  valid_598420 = validateParameter(valid_598420, JString, required = false,
                                 default = nil)
  if valid_598420 != nil:
    section.add "fields", valid_598420
  var valid_598421 = query.getOrDefault("quotaUser")
  valid_598421 = validateParameter(valid_598421, JString, required = false,
                                 default = nil)
  if valid_598421 != nil:
    section.add "quotaUser", valid_598421
  var valid_598422 = query.getOrDefault("alt")
  valid_598422 = validateParameter(valid_598422, JString, required = false,
                                 default = newJString("json"))
  if valid_598422 != nil:
    section.add "alt", valid_598422
  var valid_598423 = query.getOrDefault("oauth_token")
  valid_598423 = validateParameter(valid_598423, JString, required = false,
                                 default = nil)
  if valid_598423 != nil:
    section.add "oauth_token", valid_598423
  var valid_598424 = query.getOrDefault("userIp")
  valid_598424 = validateParameter(valid_598424, JString, required = false,
                                 default = nil)
  if valid_598424 != nil:
    section.add "userIp", valid_598424
  var valid_598425 = query.getOrDefault("key")
  valid_598425 = validateParameter(valid_598425, JString, required = false,
                                 default = nil)
  if valid_598425 != nil:
    section.add "key", valid_598425
  var valid_598426 = query.getOrDefault("prettyPrint")
  valid_598426 = validateParameter(valid_598426, JBool, required = false,
                                 default = newJBool(true))
  if valid_598426 != nil:
    section.add "prettyPrint", valid_598426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598427: Call_AndroidpublisherEditsListingsDelete_598414;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified localized store listing from an edit.
  ## 
  let valid = call_598427.validator(path, query, header, formData, body)
  let scheme = call_598427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598427.url(scheme.get, call_598427.host, call_598427.base,
                         call_598427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598427, url, valid)

proc call*(call_598428: Call_AndroidpublisherEditsListingsDelete_598414;
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
  var path_598429 = newJObject()
  var query_598430 = newJObject()
  add(query_598430, "fields", newJString(fields))
  add(path_598429, "packageName", newJString(packageName))
  add(query_598430, "quotaUser", newJString(quotaUser))
  add(query_598430, "alt", newJString(alt))
  add(path_598429, "editId", newJString(editId))
  add(query_598430, "oauth_token", newJString(oauthToken))
  add(path_598429, "language", newJString(language))
  add(query_598430, "userIp", newJString(userIp))
  add(query_598430, "key", newJString(key))
  add(query_598430, "prettyPrint", newJBool(prettyPrint))
  result = call_598428.call(path_598429, query_598430, nil, nil, nil)

var androidpublisherEditsListingsDelete* = Call_AndroidpublisherEditsListingsDelete_598414(
    name: "androidpublisherEditsListingsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsDelete_598415,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsDelete_598416, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesUpload_598468 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsImagesUpload_598470(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsImagesUpload_598469(path: JsonNode;
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
  var valid_598471 = path.getOrDefault("packageName")
  valid_598471 = validateParameter(valid_598471, JString, required = true,
                                 default = nil)
  if valid_598471 != nil:
    section.add "packageName", valid_598471
  var valid_598472 = path.getOrDefault("editId")
  valid_598472 = validateParameter(valid_598472, JString, required = true,
                                 default = nil)
  if valid_598472 != nil:
    section.add "editId", valid_598472
  var valid_598473 = path.getOrDefault("language")
  valid_598473 = validateParameter(valid_598473, JString, required = true,
                                 default = nil)
  if valid_598473 != nil:
    section.add "language", valid_598473
  var valid_598474 = path.getOrDefault("imageType")
  valid_598474 = validateParameter(valid_598474, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_598474 != nil:
    section.add "imageType", valid_598474
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
  var valid_598475 = query.getOrDefault("fields")
  valid_598475 = validateParameter(valid_598475, JString, required = false,
                                 default = nil)
  if valid_598475 != nil:
    section.add "fields", valid_598475
  var valid_598476 = query.getOrDefault("quotaUser")
  valid_598476 = validateParameter(valid_598476, JString, required = false,
                                 default = nil)
  if valid_598476 != nil:
    section.add "quotaUser", valid_598476
  var valid_598477 = query.getOrDefault("alt")
  valid_598477 = validateParameter(valid_598477, JString, required = false,
                                 default = newJString("json"))
  if valid_598477 != nil:
    section.add "alt", valid_598477
  var valid_598478 = query.getOrDefault("oauth_token")
  valid_598478 = validateParameter(valid_598478, JString, required = false,
                                 default = nil)
  if valid_598478 != nil:
    section.add "oauth_token", valid_598478
  var valid_598479 = query.getOrDefault("userIp")
  valid_598479 = validateParameter(valid_598479, JString, required = false,
                                 default = nil)
  if valid_598479 != nil:
    section.add "userIp", valid_598479
  var valid_598480 = query.getOrDefault("key")
  valid_598480 = validateParameter(valid_598480, JString, required = false,
                                 default = nil)
  if valid_598480 != nil:
    section.add "key", valid_598480
  var valid_598481 = query.getOrDefault("prettyPrint")
  valid_598481 = validateParameter(valid_598481, JBool, required = false,
                                 default = newJBool(true))
  if valid_598481 != nil:
    section.add "prettyPrint", valid_598481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598482: Call_AndroidpublisherEditsImagesUpload_598468;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a new image and adds it to the list of images for the specified language and image type.
  ## 
  let valid = call_598482.validator(path, query, header, formData, body)
  let scheme = call_598482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598482.url(scheme.get, call_598482.host, call_598482.base,
                         call_598482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598482, url, valid)

proc call*(call_598483: Call_AndroidpublisherEditsImagesUpload_598468;
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
  var path_598484 = newJObject()
  var query_598485 = newJObject()
  add(query_598485, "fields", newJString(fields))
  add(path_598484, "packageName", newJString(packageName))
  add(query_598485, "quotaUser", newJString(quotaUser))
  add(query_598485, "alt", newJString(alt))
  add(path_598484, "editId", newJString(editId))
  add(query_598485, "oauth_token", newJString(oauthToken))
  add(path_598484, "language", newJString(language))
  add(query_598485, "userIp", newJString(userIp))
  add(path_598484, "imageType", newJString(imageType))
  add(query_598485, "key", newJString(key))
  add(query_598485, "prettyPrint", newJBool(prettyPrint))
  result = call_598483.call(path_598484, query_598485, nil, nil, nil)

var androidpublisherEditsImagesUpload* = Call_AndroidpublisherEditsImagesUpload_598468(
    name: "androidpublisherEditsImagesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesUpload_598469,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsImagesUpload_598470, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesList_598450 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsImagesList_598452(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsImagesList_598451(path: JsonNode;
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
  var valid_598453 = path.getOrDefault("packageName")
  valid_598453 = validateParameter(valid_598453, JString, required = true,
                                 default = nil)
  if valid_598453 != nil:
    section.add "packageName", valid_598453
  var valid_598454 = path.getOrDefault("editId")
  valid_598454 = validateParameter(valid_598454, JString, required = true,
                                 default = nil)
  if valid_598454 != nil:
    section.add "editId", valid_598454
  var valid_598455 = path.getOrDefault("language")
  valid_598455 = validateParameter(valid_598455, JString, required = true,
                                 default = nil)
  if valid_598455 != nil:
    section.add "language", valid_598455
  var valid_598456 = path.getOrDefault("imageType")
  valid_598456 = validateParameter(valid_598456, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_598456 != nil:
    section.add "imageType", valid_598456
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
  var valid_598457 = query.getOrDefault("fields")
  valid_598457 = validateParameter(valid_598457, JString, required = false,
                                 default = nil)
  if valid_598457 != nil:
    section.add "fields", valid_598457
  var valid_598458 = query.getOrDefault("quotaUser")
  valid_598458 = validateParameter(valid_598458, JString, required = false,
                                 default = nil)
  if valid_598458 != nil:
    section.add "quotaUser", valid_598458
  var valid_598459 = query.getOrDefault("alt")
  valid_598459 = validateParameter(valid_598459, JString, required = false,
                                 default = newJString("json"))
  if valid_598459 != nil:
    section.add "alt", valid_598459
  var valid_598460 = query.getOrDefault("oauth_token")
  valid_598460 = validateParameter(valid_598460, JString, required = false,
                                 default = nil)
  if valid_598460 != nil:
    section.add "oauth_token", valid_598460
  var valid_598461 = query.getOrDefault("userIp")
  valid_598461 = validateParameter(valid_598461, JString, required = false,
                                 default = nil)
  if valid_598461 != nil:
    section.add "userIp", valid_598461
  var valid_598462 = query.getOrDefault("key")
  valid_598462 = validateParameter(valid_598462, JString, required = false,
                                 default = nil)
  if valid_598462 != nil:
    section.add "key", valid_598462
  var valid_598463 = query.getOrDefault("prettyPrint")
  valid_598463 = validateParameter(valid_598463, JBool, required = false,
                                 default = newJBool(true))
  if valid_598463 != nil:
    section.add "prettyPrint", valid_598463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598464: Call_AndroidpublisherEditsImagesList_598450;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all images for the specified language and image type.
  ## 
  let valid = call_598464.validator(path, query, header, formData, body)
  let scheme = call_598464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598464.url(scheme.get, call_598464.host, call_598464.base,
                         call_598464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598464, url, valid)

proc call*(call_598465: Call_AndroidpublisherEditsImagesList_598450;
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
  var path_598466 = newJObject()
  var query_598467 = newJObject()
  add(query_598467, "fields", newJString(fields))
  add(path_598466, "packageName", newJString(packageName))
  add(query_598467, "quotaUser", newJString(quotaUser))
  add(query_598467, "alt", newJString(alt))
  add(path_598466, "editId", newJString(editId))
  add(query_598467, "oauth_token", newJString(oauthToken))
  add(path_598466, "language", newJString(language))
  add(query_598467, "userIp", newJString(userIp))
  add(path_598466, "imageType", newJString(imageType))
  add(query_598467, "key", newJString(key))
  add(query_598467, "prettyPrint", newJBool(prettyPrint))
  result = call_598465.call(path_598466, query_598467, nil, nil, nil)

var androidpublisherEditsImagesList* = Call_AndroidpublisherEditsImagesList_598450(
    name: "androidpublisherEditsImagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesList_598451,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsImagesList_598452, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesDeleteall_598486 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsImagesDeleteall_598488(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsImagesDeleteall_598487(path: JsonNode;
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
  var valid_598489 = path.getOrDefault("packageName")
  valid_598489 = validateParameter(valid_598489, JString, required = true,
                                 default = nil)
  if valid_598489 != nil:
    section.add "packageName", valid_598489
  var valid_598490 = path.getOrDefault("editId")
  valid_598490 = validateParameter(valid_598490, JString, required = true,
                                 default = nil)
  if valid_598490 != nil:
    section.add "editId", valid_598490
  var valid_598491 = path.getOrDefault("language")
  valid_598491 = validateParameter(valid_598491, JString, required = true,
                                 default = nil)
  if valid_598491 != nil:
    section.add "language", valid_598491
  var valid_598492 = path.getOrDefault("imageType")
  valid_598492 = validateParameter(valid_598492, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_598492 != nil:
    section.add "imageType", valid_598492
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
  var valid_598493 = query.getOrDefault("fields")
  valid_598493 = validateParameter(valid_598493, JString, required = false,
                                 default = nil)
  if valid_598493 != nil:
    section.add "fields", valid_598493
  var valid_598494 = query.getOrDefault("quotaUser")
  valid_598494 = validateParameter(valid_598494, JString, required = false,
                                 default = nil)
  if valid_598494 != nil:
    section.add "quotaUser", valid_598494
  var valid_598495 = query.getOrDefault("alt")
  valid_598495 = validateParameter(valid_598495, JString, required = false,
                                 default = newJString("json"))
  if valid_598495 != nil:
    section.add "alt", valid_598495
  var valid_598496 = query.getOrDefault("oauth_token")
  valid_598496 = validateParameter(valid_598496, JString, required = false,
                                 default = nil)
  if valid_598496 != nil:
    section.add "oauth_token", valid_598496
  var valid_598497 = query.getOrDefault("userIp")
  valid_598497 = validateParameter(valid_598497, JString, required = false,
                                 default = nil)
  if valid_598497 != nil:
    section.add "userIp", valid_598497
  var valid_598498 = query.getOrDefault("key")
  valid_598498 = validateParameter(valid_598498, JString, required = false,
                                 default = nil)
  if valid_598498 != nil:
    section.add "key", valid_598498
  var valid_598499 = query.getOrDefault("prettyPrint")
  valid_598499 = validateParameter(valid_598499, JBool, required = false,
                                 default = newJBool(true))
  if valid_598499 != nil:
    section.add "prettyPrint", valid_598499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598500: Call_AndroidpublisherEditsImagesDeleteall_598486;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all images for the specified language and image type.
  ## 
  let valid = call_598500.validator(path, query, header, formData, body)
  let scheme = call_598500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598500.url(scheme.get, call_598500.host, call_598500.base,
                         call_598500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598500, url, valid)

proc call*(call_598501: Call_AndroidpublisherEditsImagesDeleteall_598486;
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
  var path_598502 = newJObject()
  var query_598503 = newJObject()
  add(query_598503, "fields", newJString(fields))
  add(path_598502, "packageName", newJString(packageName))
  add(query_598503, "quotaUser", newJString(quotaUser))
  add(query_598503, "alt", newJString(alt))
  add(path_598502, "editId", newJString(editId))
  add(query_598503, "oauth_token", newJString(oauthToken))
  add(path_598502, "language", newJString(language))
  add(query_598503, "userIp", newJString(userIp))
  add(path_598502, "imageType", newJString(imageType))
  add(query_598503, "key", newJString(key))
  add(query_598503, "prettyPrint", newJBool(prettyPrint))
  result = call_598501.call(path_598502, query_598503, nil, nil, nil)

var androidpublisherEditsImagesDeleteall* = Call_AndroidpublisherEditsImagesDeleteall_598486(
    name: "androidpublisherEditsImagesDeleteall", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesDeleteall_598487,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsImagesDeleteall_598488, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesDelete_598504 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsImagesDelete_598506(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsImagesDelete_598505(path: JsonNode;
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
  var valid_598507 = path.getOrDefault("imageId")
  valid_598507 = validateParameter(valid_598507, JString, required = true,
                                 default = nil)
  if valid_598507 != nil:
    section.add "imageId", valid_598507
  var valid_598508 = path.getOrDefault("packageName")
  valid_598508 = validateParameter(valid_598508, JString, required = true,
                                 default = nil)
  if valid_598508 != nil:
    section.add "packageName", valid_598508
  var valid_598509 = path.getOrDefault("editId")
  valid_598509 = validateParameter(valid_598509, JString, required = true,
                                 default = nil)
  if valid_598509 != nil:
    section.add "editId", valid_598509
  var valid_598510 = path.getOrDefault("language")
  valid_598510 = validateParameter(valid_598510, JString, required = true,
                                 default = nil)
  if valid_598510 != nil:
    section.add "language", valid_598510
  var valid_598511 = path.getOrDefault("imageType")
  valid_598511 = validateParameter(valid_598511, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_598511 != nil:
    section.add "imageType", valid_598511
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
  var valid_598512 = query.getOrDefault("fields")
  valid_598512 = validateParameter(valid_598512, JString, required = false,
                                 default = nil)
  if valid_598512 != nil:
    section.add "fields", valid_598512
  var valid_598513 = query.getOrDefault("quotaUser")
  valid_598513 = validateParameter(valid_598513, JString, required = false,
                                 default = nil)
  if valid_598513 != nil:
    section.add "quotaUser", valid_598513
  var valid_598514 = query.getOrDefault("alt")
  valid_598514 = validateParameter(valid_598514, JString, required = false,
                                 default = newJString("json"))
  if valid_598514 != nil:
    section.add "alt", valid_598514
  var valid_598515 = query.getOrDefault("oauth_token")
  valid_598515 = validateParameter(valid_598515, JString, required = false,
                                 default = nil)
  if valid_598515 != nil:
    section.add "oauth_token", valid_598515
  var valid_598516 = query.getOrDefault("userIp")
  valid_598516 = validateParameter(valid_598516, JString, required = false,
                                 default = nil)
  if valid_598516 != nil:
    section.add "userIp", valid_598516
  var valid_598517 = query.getOrDefault("key")
  valid_598517 = validateParameter(valid_598517, JString, required = false,
                                 default = nil)
  if valid_598517 != nil:
    section.add "key", valid_598517
  var valid_598518 = query.getOrDefault("prettyPrint")
  valid_598518 = validateParameter(valid_598518, JBool, required = false,
                                 default = newJBool(true))
  if valid_598518 != nil:
    section.add "prettyPrint", valid_598518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598519: Call_AndroidpublisherEditsImagesDelete_598504;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the image (specified by id) from the edit.
  ## 
  let valid = call_598519.validator(path, query, header, formData, body)
  let scheme = call_598519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598519.url(scheme.get, call_598519.host, call_598519.base,
                         call_598519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598519, url, valid)

proc call*(call_598520: Call_AndroidpublisherEditsImagesDelete_598504;
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
  var path_598521 = newJObject()
  var query_598522 = newJObject()
  add(path_598521, "imageId", newJString(imageId))
  add(query_598522, "fields", newJString(fields))
  add(path_598521, "packageName", newJString(packageName))
  add(query_598522, "quotaUser", newJString(quotaUser))
  add(query_598522, "alt", newJString(alt))
  add(path_598521, "editId", newJString(editId))
  add(query_598522, "oauth_token", newJString(oauthToken))
  add(path_598521, "language", newJString(language))
  add(query_598522, "userIp", newJString(userIp))
  add(path_598521, "imageType", newJString(imageType))
  add(query_598522, "key", newJString(key))
  add(query_598522, "prettyPrint", newJBool(prettyPrint))
  result = call_598520.call(path_598521, query_598522, nil, nil, nil)

var androidpublisherEditsImagesDelete* = Call_AndroidpublisherEditsImagesDelete_598504(
    name: "androidpublisherEditsImagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}/{imageId}",
    validator: validate_AndroidpublisherEditsImagesDelete_598505,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsImagesDelete_598506, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersUpdate_598540 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsTestersUpdate_598542(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsTestersUpdate_598541(path: JsonNode;
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
  var valid_598543 = path.getOrDefault("packageName")
  valid_598543 = validateParameter(valid_598543, JString, required = true,
                                 default = nil)
  if valid_598543 != nil:
    section.add "packageName", valid_598543
  var valid_598544 = path.getOrDefault("editId")
  valid_598544 = validateParameter(valid_598544, JString, required = true,
                                 default = nil)
  if valid_598544 != nil:
    section.add "editId", valid_598544
  var valid_598545 = path.getOrDefault("track")
  valid_598545 = validateParameter(valid_598545, JString, required = true,
                                 default = nil)
  if valid_598545 != nil:
    section.add "track", valid_598545
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
  var valid_598546 = query.getOrDefault("fields")
  valid_598546 = validateParameter(valid_598546, JString, required = false,
                                 default = nil)
  if valid_598546 != nil:
    section.add "fields", valid_598546
  var valid_598547 = query.getOrDefault("quotaUser")
  valid_598547 = validateParameter(valid_598547, JString, required = false,
                                 default = nil)
  if valid_598547 != nil:
    section.add "quotaUser", valid_598547
  var valid_598548 = query.getOrDefault("alt")
  valid_598548 = validateParameter(valid_598548, JString, required = false,
                                 default = newJString("json"))
  if valid_598548 != nil:
    section.add "alt", valid_598548
  var valid_598549 = query.getOrDefault("oauth_token")
  valid_598549 = validateParameter(valid_598549, JString, required = false,
                                 default = nil)
  if valid_598549 != nil:
    section.add "oauth_token", valid_598549
  var valid_598550 = query.getOrDefault("userIp")
  valid_598550 = validateParameter(valid_598550, JString, required = false,
                                 default = nil)
  if valid_598550 != nil:
    section.add "userIp", valid_598550
  var valid_598551 = query.getOrDefault("key")
  valid_598551 = validateParameter(valid_598551, JString, required = false,
                                 default = nil)
  if valid_598551 != nil:
    section.add "key", valid_598551
  var valid_598552 = query.getOrDefault("prettyPrint")
  valid_598552 = validateParameter(valid_598552, JBool, required = false,
                                 default = newJBool(true))
  if valid_598552 != nil:
    section.add "prettyPrint", valid_598552
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

proc call*(call_598554: Call_AndroidpublisherEditsTestersUpdate_598540;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_598554.validator(path, query, header, formData, body)
  let scheme = call_598554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598554.url(scheme.get, call_598554.host, call_598554.base,
                         call_598554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598554, url, valid)

proc call*(call_598555: Call_AndroidpublisherEditsTestersUpdate_598540;
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
  var path_598556 = newJObject()
  var query_598557 = newJObject()
  var body_598558 = newJObject()
  add(query_598557, "fields", newJString(fields))
  add(path_598556, "packageName", newJString(packageName))
  add(query_598557, "quotaUser", newJString(quotaUser))
  add(query_598557, "alt", newJString(alt))
  add(path_598556, "editId", newJString(editId))
  add(query_598557, "oauth_token", newJString(oauthToken))
  add(query_598557, "userIp", newJString(userIp))
  add(query_598557, "key", newJString(key))
  if body != nil:
    body_598558 = body
  add(query_598557, "prettyPrint", newJBool(prettyPrint))
  add(path_598556, "track", newJString(track))
  result = call_598555.call(path_598556, query_598557, nil, nil, body_598558)

var androidpublisherEditsTestersUpdate* = Call_AndroidpublisherEditsTestersUpdate_598540(
    name: "androidpublisherEditsTestersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersUpdate_598541,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTestersUpdate_598542, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersGet_598523 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsTestersGet_598525(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsTestersGet_598524(path: JsonNode;
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
  var valid_598526 = path.getOrDefault("packageName")
  valid_598526 = validateParameter(valid_598526, JString, required = true,
                                 default = nil)
  if valid_598526 != nil:
    section.add "packageName", valid_598526
  var valid_598527 = path.getOrDefault("editId")
  valid_598527 = validateParameter(valid_598527, JString, required = true,
                                 default = nil)
  if valid_598527 != nil:
    section.add "editId", valid_598527
  var valid_598528 = path.getOrDefault("track")
  valid_598528 = validateParameter(valid_598528, JString, required = true,
                                 default = nil)
  if valid_598528 != nil:
    section.add "track", valid_598528
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
  var valid_598529 = query.getOrDefault("fields")
  valid_598529 = validateParameter(valid_598529, JString, required = false,
                                 default = nil)
  if valid_598529 != nil:
    section.add "fields", valid_598529
  var valid_598530 = query.getOrDefault("quotaUser")
  valid_598530 = validateParameter(valid_598530, JString, required = false,
                                 default = nil)
  if valid_598530 != nil:
    section.add "quotaUser", valid_598530
  var valid_598531 = query.getOrDefault("alt")
  valid_598531 = validateParameter(valid_598531, JString, required = false,
                                 default = newJString("json"))
  if valid_598531 != nil:
    section.add "alt", valid_598531
  var valid_598532 = query.getOrDefault("oauth_token")
  valid_598532 = validateParameter(valid_598532, JString, required = false,
                                 default = nil)
  if valid_598532 != nil:
    section.add "oauth_token", valid_598532
  var valid_598533 = query.getOrDefault("userIp")
  valid_598533 = validateParameter(valid_598533, JString, required = false,
                                 default = nil)
  if valid_598533 != nil:
    section.add "userIp", valid_598533
  var valid_598534 = query.getOrDefault("key")
  valid_598534 = validateParameter(valid_598534, JString, required = false,
                                 default = nil)
  if valid_598534 != nil:
    section.add "key", valid_598534
  var valid_598535 = query.getOrDefault("prettyPrint")
  valid_598535 = validateParameter(valid_598535, JBool, required = false,
                                 default = newJBool(true))
  if valid_598535 != nil:
    section.add "prettyPrint", valid_598535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598536: Call_AndroidpublisherEditsTestersGet_598523;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_598536.validator(path, query, header, formData, body)
  let scheme = call_598536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598536.url(scheme.get, call_598536.host, call_598536.base,
                         call_598536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598536, url, valid)

proc call*(call_598537: Call_AndroidpublisherEditsTestersGet_598523;
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
  var path_598538 = newJObject()
  var query_598539 = newJObject()
  add(query_598539, "fields", newJString(fields))
  add(path_598538, "packageName", newJString(packageName))
  add(query_598539, "quotaUser", newJString(quotaUser))
  add(query_598539, "alt", newJString(alt))
  add(path_598538, "editId", newJString(editId))
  add(query_598539, "oauth_token", newJString(oauthToken))
  add(query_598539, "userIp", newJString(userIp))
  add(query_598539, "key", newJString(key))
  add(query_598539, "prettyPrint", newJBool(prettyPrint))
  add(path_598538, "track", newJString(track))
  result = call_598537.call(path_598538, query_598539, nil, nil, nil)

var androidpublisherEditsTestersGet* = Call_AndroidpublisherEditsTestersGet_598523(
    name: "androidpublisherEditsTestersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersGet_598524,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTestersGet_598525, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersPatch_598559 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsTestersPatch_598561(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsTestersPatch_598560(path: JsonNode;
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
  var valid_598562 = path.getOrDefault("packageName")
  valid_598562 = validateParameter(valid_598562, JString, required = true,
                                 default = nil)
  if valid_598562 != nil:
    section.add "packageName", valid_598562
  var valid_598563 = path.getOrDefault("editId")
  valid_598563 = validateParameter(valid_598563, JString, required = true,
                                 default = nil)
  if valid_598563 != nil:
    section.add "editId", valid_598563
  var valid_598564 = path.getOrDefault("track")
  valid_598564 = validateParameter(valid_598564, JString, required = true,
                                 default = nil)
  if valid_598564 != nil:
    section.add "track", valid_598564
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
  var valid_598565 = query.getOrDefault("fields")
  valid_598565 = validateParameter(valid_598565, JString, required = false,
                                 default = nil)
  if valid_598565 != nil:
    section.add "fields", valid_598565
  var valid_598566 = query.getOrDefault("quotaUser")
  valid_598566 = validateParameter(valid_598566, JString, required = false,
                                 default = nil)
  if valid_598566 != nil:
    section.add "quotaUser", valid_598566
  var valid_598567 = query.getOrDefault("alt")
  valid_598567 = validateParameter(valid_598567, JString, required = false,
                                 default = newJString("json"))
  if valid_598567 != nil:
    section.add "alt", valid_598567
  var valid_598568 = query.getOrDefault("oauth_token")
  valid_598568 = validateParameter(valid_598568, JString, required = false,
                                 default = nil)
  if valid_598568 != nil:
    section.add "oauth_token", valid_598568
  var valid_598569 = query.getOrDefault("userIp")
  valid_598569 = validateParameter(valid_598569, JString, required = false,
                                 default = nil)
  if valid_598569 != nil:
    section.add "userIp", valid_598569
  var valid_598570 = query.getOrDefault("key")
  valid_598570 = validateParameter(valid_598570, JString, required = false,
                                 default = nil)
  if valid_598570 != nil:
    section.add "key", valid_598570
  var valid_598571 = query.getOrDefault("prettyPrint")
  valid_598571 = validateParameter(valid_598571, JBool, required = false,
                                 default = newJBool(true))
  if valid_598571 != nil:
    section.add "prettyPrint", valid_598571
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

proc call*(call_598573: Call_AndroidpublisherEditsTestersPatch_598559;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_598573.validator(path, query, header, formData, body)
  let scheme = call_598573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598573.url(scheme.get, call_598573.host, call_598573.base,
                         call_598573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598573, url, valid)

proc call*(call_598574: Call_AndroidpublisherEditsTestersPatch_598559;
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
  var path_598575 = newJObject()
  var query_598576 = newJObject()
  var body_598577 = newJObject()
  add(query_598576, "fields", newJString(fields))
  add(path_598575, "packageName", newJString(packageName))
  add(query_598576, "quotaUser", newJString(quotaUser))
  add(query_598576, "alt", newJString(alt))
  add(path_598575, "editId", newJString(editId))
  add(query_598576, "oauth_token", newJString(oauthToken))
  add(query_598576, "userIp", newJString(userIp))
  add(query_598576, "key", newJString(key))
  if body != nil:
    body_598577 = body
  add(query_598576, "prettyPrint", newJBool(prettyPrint))
  add(path_598575, "track", newJString(track))
  result = call_598574.call(path_598575, query_598576, nil, nil, body_598577)

var androidpublisherEditsTestersPatch* = Call_AndroidpublisherEditsTestersPatch_598559(
    name: "androidpublisherEditsTestersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersPatch_598560,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTestersPatch_598561, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksList_598578 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsTracksList_598580(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsTracksList_598579(path: JsonNode;
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
  var valid_598581 = path.getOrDefault("packageName")
  valid_598581 = validateParameter(valid_598581, JString, required = true,
                                 default = nil)
  if valid_598581 != nil:
    section.add "packageName", valid_598581
  var valid_598582 = path.getOrDefault("editId")
  valid_598582 = validateParameter(valid_598582, JString, required = true,
                                 default = nil)
  if valid_598582 != nil:
    section.add "editId", valid_598582
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
  var valid_598583 = query.getOrDefault("fields")
  valid_598583 = validateParameter(valid_598583, JString, required = false,
                                 default = nil)
  if valid_598583 != nil:
    section.add "fields", valid_598583
  var valid_598584 = query.getOrDefault("quotaUser")
  valid_598584 = validateParameter(valid_598584, JString, required = false,
                                 default = nil)
  if valid_598584 != nil:
    section.add "quotaUser", valid_598584
  var valid_598585 = query.getOrDefault("alt")
  valid_598585 = validateParameter(valid_598585, JString, required = false,
                                 default = newJString("json"))
  if valid_598585 != nil:
    section.add "alt", valid_598585
  var valid_598586 = query.getOrDefault("oauth_token")
  valid_598586 = validateParameter(valid_598586, JString, required = false,
                                 default = nil)
  if valid_598586 != nil:
    section.add "oauth_token", valid_598586
  var valid_598587 = query.getOrDefault("userIp")
  valid_598587 = validateParameter(valid_598587, JString, required = false,
                                 default = nil)
  if valid_598587 != nil:
    section.add "userIp", valid_598587
  var valid_598588 = query.getOrDefault("key")
  valid_598588 = validateParameter(valid_598588, JString, required = false,
                                 default = nil)
  if valid_598588 != nil:
    section.add "key", valid_598588
  var valid_598589 = query.getOrDefault("prettyPrint")
  valid_598589 = validateParameter(valid_598589, JBool, required = false,
                                 default = newJBool(true))
  if valid_598589 != nil:
    section.add "prettyPrint", valid_598589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598590: Call_AndroidpublisherEditsTracksList_598578;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the track configurations for this edit.
  ## 
  let valid = call_598590.validator(path, query, header, formData, body)
  let scheme = call_598590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598590.url(scheme.get, call_598590.host, call_598590.base,
                         call_598590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598590, url, valid)

proc call*(call_598591: Call_AndroidpublisherEditsTracksList_598578;
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
  var path_598592 = newJObject()
  var query_598593 = newJObject()
  add(query_598593, "fields", newJString(fields))
  add(path_598592, "packageName", newJString(packageName))
  add(query_598593, "quotaUser", newJString(quotaUser))
  add(query_598593, "alt", newJString(alt))
  add(path_598592, "editId", newJString(editId))
  add(query_598593, "oauth_token", newJString(oauthToken))
  add(query_598593, "userIp", newJString(userIp))
  add(query_598593, "key", newJString(key))
  add(query_598593, "prettyPrint", newJBool(prettyPrint))
  result = call_598591.call(path_598592, query_598593, nil, nil, nil)

var androidpublisherEditsTracksList* = Call_AndroidpublisherEditsTracksList_598578(
    name: "androidpublisherEditsTracksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/tracks",
    validator: validate_AndroidpublisherEditsTracksList_598579,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTracksList_598580, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksUpdate_598611 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsTracksUpdate_598613(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsTracksUpdate_598612(path: JsonNode;
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
  var valid_598614 = path.getOrDefault("packageName")
  valid_598614 = validateParameter(valid_598614, JString, required = true,
                                 default = nil)
  if valid_598614 != nil:
    section.add "packageName", valid_598614
  var valid_598615 = path.getOrDefault("editId")
  valid_598615 = validateParameter(valid_598615, JString, required = true,
                                 default = nil)
  if valid_598615 != nil:
    section.add "editId", valid_598615
  var valid_598616 = path.getOrDefault("track")
  valid_598616 = validateParameter(valid_598616, JString, required = true,
                                 default = nil)
  if valid_598616 != nil:
    section.add "track", valid_598616
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
  var valid_598617 = query.getOrDefault("fields")
  valid_598617 = validateParameter(valid_598617, JString, required = false,
                                 default = nil)
  if valid_598617 != nil:
    section.add "fields", valid_598617
  var valid_598618 = query.getOrDefault("quotaUser")
  valid_598618 = validateParameter(valid_598618, JString, required = false,
                                 default = nil)
  if valid_598618 != nil:
    section.add "quotaUser", valid_598618
  var valid_598619 = query.getOrDefault("alt")
  valid_598619 = validateParameter(valid_598619, JString, required = false,
                                 default = newJString("json"))
  if valid_598619 != nil:
    section.add "alt", valid_598619
  var valid_598620 = query.getOrDefault("oauth_token")
  valid_598620 = validateParameter(valid_598620, JString, required = false,
                                 default = nil)
  if valid_598620 != nil:
    section.add "oauth_token", valid_598620
  var valid_598621 = query.getOrDefault("userIp")
  valid_598621 = validateParameter(valid_598621, JString, required = false,
                                 default = nil)
  if valid_598621 != nil:
    section.add "userIp", valid_598621
  var valid_598622 = query.getOrDefault("key")
  valid_598622 = validateParameter(valid_598622, JString, required = false,
                                 default = nil)
  if valid_598622 != nil:
    section.add "key", valid_598622
  var valid_598623 = query.getOrDefault("prettyPrint")
  valid_598623 = validateParameter(valid_598623, JBool, required = false,
                                 default = newJBool(true))
  if valid_598623 != nil:
    section.add "prettyPrint", valid_598623
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

proc call*(call_598625: Call_AndroidpublisherEditsTracksUpdate_598611;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the track configuration for the specified track type.
  ## 
  let valid = call_598625.validator(path, query, header, formData, body)
  let scheme = call_598625.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598625.url(scheme.get, call_598625.host, call_598625.base,
                         call_598625.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598625, url, valid)

proc call*(call_598626: Call_AndroidpublisherEditsTracksUpdate_598611;
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
  var path_598627 = newJObject()
  var query_598628 = newJObject()
  var body_598629 = newJObject()
  add(query_598628, "fields", newJString(fields))
  add(path_598627, "packageName", newJString(packageName))
  add(query_598628, "quotaUser", newJString(quotaUser))
  add(query_598628, "alt", newJString(alt))
  add(path_598627, "editId", newJString(editId))
  add(query_598628, "oauth_token", newJString(oauthToken))
  add(query_598628, "userIp", newJString(userIp))
  add(query_598628, "key", newJString(key))
  if body != nil:
    body_598629 = body
  add(query_598628, "prettyPrint", newJBool(prettyPrint))
  add(path_598627, "track", newJString(track))
  result = call_598626.call(path_598627, query_598628, nil, nil, body_598629)

var androidpublisherEditsTracksUpdate* = Call_AndroidpublisherEditsTracksUpdate_598611(
    name: "androidpublisherEditsTracksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksUpdate_598612,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTracksUpdate_598613, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksGet_598594 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsTracksGet_598596(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsTracksGet_598595(path: JsonNode;
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
  var valid_598597 = path.getOrDefault("packageName")
  valid_598597 = validateParameter(valid_598597, JString, required = true,
                                 default = nil)
  if valid_598597 != nil:
    section.add "packageName", valid_598597
  var valid_598598 = path.getOrDefault("editId")
  valid_598598 = validateParameter(valid_598598, JString, required = true,
                                 default = nil)
  if valid_598598 != nil:
    section.add "editId", valid_598598
  var valid_598599 = path.getOrDefault("track")
  valid_598599 = validateParameter(valid_598599, JString, required = true,
                                 default = nil)
  if valid_598599 != nil:
    section.add "track", valid_598599
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
  var valid_598600 = query.getOrDefault("fields")
  valid_598600 = validateParameter(valid_598600, JString, required = false,
                                 default = nil)
  if valid_598600 != nil:
    section.add "fields", valid_598600
  var valid_598601 = query.getOrDefault("quotaUser")
  valid_598601 = validateParameter(valid_598601, JString, required = false,
                                 default = nil)
  if valid_598601 != nil:
    section.add "quotaUser", valid_598601
  var valid_598602 = query.getOrDefault("alt")
  valid_598602 = validateParameter(valid_598602, JString, required = false,
                                 default = newJString("json"))
  if valid_598602 != nil:
    section.add "alt", valid_598602
  var valid_598603 = query.getOrDefault("oauth_token")
  valid_598603 = validateParameter(valid_598603, JString, required = false,
                                 default = nil)
  if valid_598603 != nil:
    section.add "oauth_token", valid_598603
  var valid_598604 = query.getOrDefault("userIp")
  valid_598604 = validateParameter(valid_598604, JString, required = false,
                                 default = nil)
  if valid_598604 != nil:
    section.add "userIp", valid_598604
  var valid_598605 = query.getOrDefault("key")
  valid_598605 = validateParameter(valid_598605, JString, required = false,
                                 default = nil)
  if valid_598605 != nil:
    section.add "key", valid_598605
  var valid_598606 = query.getOrDefault("prettyPrint")
  valid_598606 = validateParameter(valid_598606, JBool, required = false,
                                 default = newJBool(true))
  if valid_598606 != nil:
    section.add "prettyPrint", valid_598606
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598607: Call_AndroidpublisherEditsTracksGet_598594; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the track configuration for the specified track type. Includes the APK version codes that are in this track.
  ## 
  let valid = call_598607.validator(path, query, header, formData, body)
  let scheme = call_598607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598607.url(scheme.get, call_598607.host, call_598607.base,
                         call_598607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598607, url, valid)

proc call*(call_598608: Call_AndroidpublisherEditsTracksGet_598594;
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
  var path_598609 = newJObject()
  var query_598610 = newJObject()
  add(query_598610, "fields", newJString(fields))
  add(path_598609, "packageName", newJString(packageName))
  add(query_598610, "quotaUser", newJString(quotaUser))
  add(query_598610, "alt", newJString(alt))
  add(path_598609, "editId", newJString(editId))
  add(query_598610, "oauth_token", newJString(oauthToken))
  add(query_598610, "userIp", newJString(userIp))
  add(query_598610, "key", newJString(key))
  add(query_598610, "prettyPrint", newJBool(prettyPrint))
  add(path_598609, "track", newJString(track))
  result = call_598608.call(path_598609, query_598610, nil, nil, nil)

var androidpublisherEditsTracksGet* = Call_AndroidpublisherEditsTracksGet_598594(
    name: "androidpublisherEditsTracksGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksGet_598595,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTracksGet_598596, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksPatch_598630 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsTracksPatch_598632(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsTracksPatch_598631(path: JsonNode;
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
  var valid_598633 = path.getOrDefault("packageName")
  valid_598633 = validateParameter(valid_598633, JString, required = true,
                                 default = nil)
  if valid_598633 != nil:
    section.add "packageName", valid_598633
  var valid_598634 = path.getOrDefault("editId")
  valid_598634 = validateParameter(valid_598634, JString, required = true,
                                 default = nil)
  if valid_598634 != nil:
    section.add "editId", valid_598634
  var valid_598635 = path.getOrDefault("track")
  valid_598635 = validateParameter(valid_598635, JString, required = true,
                                 default = nil)
  if valid_598635 != nil:
    section.add "track", valid_598635
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
  var valid_598636 = query.getOrDefault("fields")
  valid_598636 = validateParameter(valid_598636, JString, required = false,
                                 default = nil)
  if valid_598636 != nil:
    section.add "fields", valid_598636
  var valid_598637 = query.getOrDefault("quotaUser")
  valid_598637 = validateParameter(valid_598637, JString, required = false,
                                 default = nil)
  if valid_598637 != nil:
    section.add "quotaUser", valid_598637
  var valid_598638 = query.getOrDefault("alt")
  valid_598638 = validateParameter(valid_598638, JString, required = false,
                                 default = newJString("json"))
  if valid_598638 != nil:
    section.add "alt", valid_598638
  var valid_598639 = query.getOrDefault("oauth_token")
  valid_598639 = validateParameter(valid_598639, JString, required = false,
                                 default = nil)
  if valid_598639 != nil:
    section.add "oauth_token", valid_598639
  var valid_598640 = query.getOrDefault("userIp")
  valid_598640 = validateParameter(valid_598640, JString, required = false,
                                 default = nil)
  if valid_598640 != nil:
    section.add "userIp", valid_598640
  var valid_598641 = query.getOrDefault("key")
  valid_598641 = validateParameter(valid_598641, JString, required = false,
                                 default = nil)
  if valid_598641 != nil:
    section.add "key", valid_598641
  var valid_598642 = query.getOrDefault("prettyPrint")
  valid_598642 = validateParameter(valid_598642, JBool, required = false,
                                 default = newJBool(true))
  if valid_598642 != nil:
    section.add "prettyPrint", valid_598642
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

proc call*(call_598644: Call_AndroidpublisherEditsTracksPatch_598630;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the track configuration for the specified track type. This method supports patch semantics.
  ## 
  let valid = call_598644.validator(path, query, header, formData, body)
  let scheme = call_598644.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598644.url(scheme.get, call_598644.host, call_598644.base,
                         call_598644.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598644, url, valid)

proc call*(call_598645: Call_AndroidpublisherEditsTracksPatch_598630;
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
  var path_598646 = newJObject()
  var query_598647 = newJObject()
  var body_598648 = newJObject()
  add(query_598647, "fields", newJString(fields))
  add(path_598646, "packageName", newJString(packageName))
  add(query_598647, "quotaUser", newJString(quotaUser))
  add(query_598647, "alt", newJString(alt))
  add(path_598646, "editId", newJString(editId))
  add(query_598647, "oauth_token", newJString(oauthToken))
  add(query_598647, "userIp", newJString(userIp))
  add(query_598647, "key", newJString(key))
  if body != nil:
    body_598648 = body
  add(query_598647, "prettyPrint", newJBool(prettyPrint))
  add(path_598646, "track", newJString(track))
  result = call_598645.call(path_598646, query_598647, nil, nil, body_598648)

var androidpublisherEditsTracksPatch* = Call_AndroidpublisherEditsTracksPatch_598630(
    name: "androidpublisherEditsTracksPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksPatch_598631,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTracksPatch_598632, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsCommit_598649 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsCommit_598651(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsCommit_598650(path: JsonNode; query: JsonNode;
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
  var valid_598652 = path.getOrDefault("packageName")
  valid_598652 = validateParameter(valid_598652, JString, required = true,
                                 default = nil)
  if valid_598652 != nil:
    section.add "packageName", valid_598652
  var valid_598653 = path.getOrDefault("editId")
  valid_598653 = validateParameter(valid_598653, JString, required = true,
                                 default = nil)
  if valid_598653 != nil:
    section.add "editId", valid_598653
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
  var valid_598654 = query.getOrDefault("fields")
  valid_598654 = validateParameter(valid_598654, JString, required = false,
                                 default = nil)
  if valid_598654 != nil:
    section.add "fields", valid_598654
  var valid_598655 = query.getOrDefault("quotaUser")
  valid_598655 = validateParameter(valid_598655, JString, required = false,
                                 default = nil)
  if valid_598655 != nil:
    section.add "quotaUser", valid_598655
  var valid_598656 = query.getOrDefault("alt")
  valid_598656 = validateParameter(valid_598656, JString, required = false,
                                 default = newJString("json"))
  if valid_598656 != nil:
    section.add "alt", valid_598656
  var valid_598657 = query.getOrDefault("oauth_token")
  valid_598657 = validateParameter(valid_598657, JString, required = false,
                                 default = nil)
  if valid_598657 != nil:
    section.add "oauth_token", valid_598657
  var valid_598658 = query.getOrDefault("userIp")
  valid_598658 = validateParameter(valid_598658, JString, required = false,
                                 default = nil)
  if valid_598658 != nil:
    section.add "userIp", valid_598658
  var valid_598659 = query.getOrDefault("key")
  valid_598659 = validateParameter(valid_598659, JString, required = false,
                                 default = nil)
  if valid_598659 != nil:
    section.add "key", valid_598659
  var valid_598660 = query.getOrDefault("prettyPrint")
  valid_598660 = validateParameter(valid_598660, JBool, required = false,
                                 default = newJBool(true))
  if valid_598660 != nil:
    section.add "prettyPrint", valid_598660
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598661: Call_AndroidpublisherEditsCommit_598649; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Commits/applies the changes made in this edit back to the app.
  ## 
  let valid = call_598661.validator(path, query, header, formData, body)
  let scheme = call_598661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598661.url(scheme.get, call_598661.host, call_598661.base,
                         call_598661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598661, url, valid)

proc call*(call_598662: Call_AndroidpublisherEditsCommit_598649;
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
  var path_598663 = newJObject()
  var query_598664 = newJObject()
  add(query_598664, "fields", newJString(fields))
  add(path_598663, "packageName", newJString(packageName))
  add(query_598664, "quotaUser", newJString(quotaUser))
  add(query_598664, "alt", newJString(alt))
  add(path_598663, "editId", newJString(editId))
  add(query_598664, "oauth_token", newJString(oauthToken))
  add(query_598664, "userIp", newJString(userIp))
  add(query_598664, "key", newJString(key))
  add(query_598664, "prettyPrint", newJBool(prettyPrint))
  result = call_598662.call(path_598663, query_598664, nil, nil, nil)

var androidpublisherEditsCommit* = Call_AndroidpublisherEditsCommit_598649(
    name: "androidpublisherEditsCommit", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}:commit",
    validator: validate_AndroidpublisherEditsCommit_598650,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsCommit_598651, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsValidate_598665 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsValidate_598667(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsValidate_598666(path: JsonNode; query: JsonNode;
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
  var valid_598668 = path.getOrDefault("packageName")
  valid_598668 = validateParameter(valid_598668, JString, required = true,
                                 default = nil)
  if valid_598668 != nil:
    section.add "packageName", valid_598668
  var valid_598669 = path.getOrDefault("editId")
  valid_598669 = validateParameter(valid_598669, JString, required = true,
                                 default = nil)
  if valid_598669 != nil:
    section.add "editId", valid_598669
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
  var valid_598670 = query.getOrDefault("fields")
  valid_598670 = validateParameter(valid_598670, JString, required = false,
                                 default = nil)
  if valid_598670 != nil:
    section.add "fields", valid_598670
  var valid_598671 = query.getOrDefault("quotaUser")
  valid_598671 = validateParameter(valid_598671, JString, required = false,
                                 default = nil)
  if valid_598671 != nil:
    section.add "quotaUser", valid_598671
  var valid_598672 = query.getOrDefault("alt")
  valid_598672 = validateParameter(valid_598672, JString, required = false,
                                 default = newJString("json"))
  if valid_598672 != nil:
    section.add "alt", valid_598672
  var valid_598673 = query.getOrDefault("oauth_token")
  valid_598673 = validateParameter(valid_598673, JString, required = false,
                                 default = nil)
  if valid_598673 != nil:
    section.add "oauth_token", valid_598673
  var valid_598674 = query.getOrDefault("userIp")
  valid_598674 = validateParameter(valid_598674, JString, required = false,
                                 default = nil)
  if valid_598674 != nil:
    section.add "userIp", valid_598674
  var valid_598675 = query.getOrDefault("key")
  valid_598675 = validateParameter(valid_598675, JString, required = false,
                                 default = nil)
  if valid_598675 != nil:
    section.add "key", valid_598675
  var valid_598676 = query.getOrDefault("prettyPrint")
  valid_598676 = validateParameter(valid_598676, JBool, required = false,
                                 default = newJBool(true))
  if valid_598676 != nil:
    section.add "prettyPrint", valid_598676
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598677: Call_AndroidpublisherEditsValidate_598665; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that the edit can be successfully committed. The edit's changes are not applied to the live app.
  ## 
  let valid = call_598677.validator(path, query, header, formData, body)
  let scheme = call_598677.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598677.url(scheme.get, call_598677.host, call_598677.base,
                         call_598677.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598677, url, valid)

proc call*(call_598678: Call_AndroidpublisherEditsValidate_598665;
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
  var path_598679 = newJObject()
  var query_598680 = newJObject()
  add(query_598680, "fields", newJString(fields))
  add(path_598679, "packageName", newJString(packageName))
  add(query_598680, "quotaUser", newJString(quotaUser))
  add(query_598680, "alt", newJString(alt))
  add(path_598679, "editId", newJString(editId))
  add(query_598680, "oauth_token", newJString(oauthToken))
  add(query_598680, "userIp", newJString(userIp))
  add(query_598680, "key", newJString(key))
  add(query_598680, "prettyPrint", newJBool(prettyPrint))
  result = call_598678.call(path_598679, query_598680, nil, nil, nil)

var androidpublisherEditsValidate* = Call_AndroidpublisherEditsValidate_598665(
    name: "androidpublisherEditsValidate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}:validate",
    validator: validate_AndroidpublisherEditsValidate_598666,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsValidate_598667, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsInsert_598699 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherInappproductsInsert_598701(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherInappproductsInsert_598700(path: JsonNode;
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
  var valid_598702 = path.getOrDefault("packageName")
  valid_598702 = validateParameter(valid_598702, JString, required = true,
                                 default = nil)
  if valid_598702 != nil:
    section.add "packageName", valid_598702
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
  var valid_598703 = query.getOrDefault("fields")
  valid_598703 = validateParameter(valid_598703, JString, required = false,
                                 default = nil)
  if valid_598703 != nil:
    section.add "fields", valid_598703
  var valid_598704 = query.getOrDefault("quotaUser")
  valid_598704 = validateParameter(valid_598704, JString, required = false,
                                 default = nil)
  if valid_598704 != nil:
    section.add "quotaUser", valid_598704
  var valid_598705 = query.getOrDefault("alt")
  valid_598705 = validateParameter(valid_598705, JString, required = false,
                                 default = newJString("json"))
  if valid_598705 != nil:
    section.add "alt", valid_598705
  var valid_598706 = query.getOrDefault("oauth_token")
  valid_598706 = validateParameter(valid_598706, JString, required = false,
                                 default = nil)
  if valid_598706 != nil:
    section.add "oauth_token", valid_598706
  var valid_598707 = query.getOrDefault("userIp")
  valid_598707 = validateParameter(valid_598707, JString, required = false,
                                 default = nil)
  if valid_598707 != nil:
    section.add "userIp", valid_598707
  var valid_598708 = query.getOrDefault("key")
  valid_598708 = validateParameter(valid_598708, JString, required = false,
                                 default = nil)
  if valid_598708 != nil:
    section.add "key", valid_598708
  var valid_598709 = query.getOrDefault("autoConvertMissingPrices")
  valid_598709 = validateParameter(valid_598709, JBool, required = false, default = nil)
  if valid_598709 != nil:
    section.add "autoConvertMissingPrices", valid_598709
  var valid_598710 = query.getOrDefault("prettyPrint")
  valid_598710 = validateParameter(valid_598710, JBool, required = false,
                                 default = newJBool(true))
  if valid_598710 != nil:
    section.add "prettyPrint", valid_598710
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

proc call*(call_598712: Call_AndroidpublisherInappproductsInsert_598699;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new in-app product for an app.
  ## 
  let valid = call_598712.validator(path, query, header, formData, body)
  let scheme = call_598712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598712.url(scheme.get, call_598712.host, call_598712.base,
                         call_598712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598712, url, valid)

proc call*(call_598713: Call_AndroidpublisherInappproductsInsert_598699;
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
  var path_598714 = newJObject()
  var query_598715 = newJObject()
  var body_598716 = newJObject()
  add(query_598715, "fields", newJString(fields))
  add(path_598714, "packageName", newJString(packageName))
  add(query_598715, "quotaUser", newJString(quotaUser))
  add(query_598715, "alt", newJString(alt))
  add(query_598715, "oauth_token", newJString(oauthToken))
  add(query_598715, "userIp", newJString(userIp))
  add(query_598715, "key", newJString(key))
  add(query_598715, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_598716 = body
  add(query_598715, "prettyPrint", newJBool(prettyPrint))
  result = call_598713.call(path_598714, query_598715, nil, nil, body_598716)

var androidpublisherInappproductsInsert* = Call_AndroidpublisherInappproductsInsert_598699(
    name: "androidpublisherInappproductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts",
    validator: validate_AndroidpublisherInappproductsInsert_598700,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsInsert_598701, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsList_598681 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherInappproductsList_598683(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherInappproductsList_598682(path: JsonNode;
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
  var valid_598684 = path.getOrDefault("packageName")
  valid_598684 = validateParameter(valid_598684, JString, required = true,
                                 default = nil)
  if valid_598684 != nil:
    section.add "packageName", valid_598684
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
  var valid_598685 = query.getOrDefault("token")
  valid_598685 = validateParameter(valid_598685, JString, required = false,
                                 default = nil)
  if valid_598685 != nil:
    section.add "token", valid_598685
  var valid_598686 = query.getOrDefault("fields")
  valid_598686 = validateParameter(valid_598686, JString, required = false,
                                 default = nil)
  if valid_598686 != nil:
    section.add "fields", valid_598686
  var valid_598687 = query.getOrDefault("quotaUser")
  valid_598687 = validateParameter(valid_598687, JString, required = false,
                                 default = nil)
  if valid_598687 != nil:
    section.add "quotaUser", valid_598687
  var valid_598688 = query.getOrDefault("alt")
  valid_598688 = validateParameter(valid_598688, JString, required = false,
                                 default = newJString("json"))
  if valid_598688 != nil:
    section.add "alt", valid_598688
  var valid_598689 = query.getOrDefault("oauth_token")
  valid_598689 = validateParameter(valid_598689, JString, required = false,
                                 default = nil)
  if valid_598689 != nil:
    section.add "oauth_token", valid_598689
  var valid_598690 = query.getOrDefault("userIp")
  valid_598690 = validateParameter(valid_598690, JString, required = false,
                                 default = nil)
  if valid_598690 != nil:
    section.add "userIp", valid_598690
  var valid_598691 = query.getOrDefault("maxResults")
  valid_598691 = validateParameter(valid_598691, JInt, required = false, default = nil)
  if valid_598691 != nil:
    section.add "maxResults", valid_598691
  var valid_598692 = query.getOrDefault("key")
  valid_598692 = validateParameter(valid_598692, JString, required = false,
                                 default = nil)
  if valid_598692 != nil:
    section.add "key", valid_598692
  var valid_598693 = query.getOrDefault("prettyPrint")
  valid_598693 = validateParameter(valid_598693, JBool, required = false,
                                 default = newJBool(true))
  if valid_598693 != nil:
    section.add "prettyPrint", valid_598693
  var valid_598694 = query.getOrDefault("startIndex")
  valid_598694 = validateParameter(valid_598694, JInt, required = false, default = nil)
  if valid_598694 != nil:
    section.add "startIndex", valid_598694
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598695: Call_AndroidpublisherInappproductsList_598681;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the in-app products for an Android app, both subscriptions and managed in-app products..
  ## 
  let valid = call_598695.validator(path, query, header, formData, body)
  let scheme = call_598695.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598695.url(scheme.get, call_598695.host, call_598695.base,
                         call_598695.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598695, url, valid)

proc call*(call_598696: Call_AndroidpublisherInappproductsList_598681;
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
  var path_598697 = newJObject()
  var query_598698 = newJObject()
  add(query_598698, "token", newJString(token))
  add(query_598698, "fields", newJString(fields))
  add(path_598697, "packageName", newJString(packageName))
  add(query_598698, "quotaUser", newJString(quotaUser))
  add(query_598698, "alt", newJString(alt))
  add(query_598698, "oauth_token", newJString(oauthToken))
  add(query_598698, "userIp", newJString(userIp))
  add(query_598698, "maxResults", newJInt(maxResults))
  add(query_598698, "key", newJString(key))
  add(query_598698, "prettyPrint", newJBool(prettyPrint))
  add(query_598698, "startIndex", newJInt(startIndex))
  result = call_598696.call(path_598697, query_598698, nil, nil, nil)

var androidpublisherInappproductsList* = Call_AndroidpublisherInappproductsList_598681(
    name: "androidpublisherInappproductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts",
    validator: validate_AndroidpublisherInappproductsList_598682,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsList_598683, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsUpdate_598733 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherInappproductsUpdate_598735(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherInappproductsUpdate_598734(path: JsonNode;
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
  var valid_598736 = path.getOrDefault("packageName")
  valid_598736 = validateParameter(valid_598736, JString, required = true,
                                 default = nil)
  if valid_598736 != nil:
    section.add "packageName", valid_598736
  var valid_598737 = path.getOrDefault("sku")
  valid_598737 = validateParameter(valid_598737, JString, required = true,
                                 default = nil)
  if valid_598737 != nil:
    section.add "sku", valid_598737
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
  var valid_598738 = query.getOrDefault("fields")
  valid_598738 = validateParameter(valid_598738, JString, required = false,
                                 default = nil)
  if valid_598738 != nil:
    section.add "fields", valid_598738
  var valid_598739 = query.getOrDefault("quotaUser")
  valid_598739 = validateParameter(valid_598739, JString, required = false,
                                 default = nil)
  if valid_598739 != nil:
    section.add "quotaUser", valid_598739
  var valid_598740 = query.getOrDefault("alt")
  valid_598740 = validateParameter(valid_598740, JString, required = false,
                                 default = newJString("json"))
  if valid_598740 != nil:
    section.add "alt", valid_598740
  var valid_598741 = query.getOrDefault("oauth_token")
  valid_598741 = validateParameter(valid_598741, JString, required = false,
                                 default = nil)
  if valid_598741 != nil:
    section.add "oauth_token", valid_598741
  var valid_598742 = query.getOrDefault("userIp")
  valid_598742 = validateParameter(valid_598742, JString, required = false,
                                 default = nil)
  if valid_598742 != nil:
    section.add "userIp", valid_598742
  var valid_598743 = query.getOrDefault("key")
  valid_598743 = validateParameter(valid_598743, JString, required = false,
                                 default = nil)
  if valid_598743 != nil:
    section.add "key", valid_598743
  var valid_598744 = query.getOrDefault("autoConvertMissingPrices")
  valid_598744 = validateParameter(valid_598744, JBool, required = false, default = nil)
  if valid_598744 != nil:
    section.add "autoConvertMissingPrices", valid_598744
  var valid_598745 = query.getOrDefault("prettyPrint")
  valid_598745 = validateParameter(valid_598745, JBool, required = false,
                                 default = newJBool(true))
  if valid_598745 != nil:
    section.add "prettyPrint", valid_598745
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

proc call*(call_598747: Call_AndroidpublisherInappproductsUpdate_598733;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the details of an in-app product.
  ## 
  let valid = call_598747.validator(path, query, header, formData, body)
  let scheme = call_598747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598747.url(scheme.get, call_598747.host, call_598747.base,
                         call_598747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598747, url, valid)

proc call*(call_598748: Call_AndroidpublisherInappproductsUpdate_598733;
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
  var path_598749 = newJObject()
  var query_598750 = newJObject()
  var body_598751 = newJObject()
  add(query_598750, "fields", newJString(fields))
  add(path_598749, "packageName", newJString(packageName))
  add(query_598750, "quotaUser", newJString(quotaUser))
  add(query_598750, "alt", newJString(alt))
  add(query_598750, "oauth_token", newJString(oauthToken))
  add(query_598750, "userIp", newJString(userIp))
  add(path_598749, "sku", newJString(sku))
  add(query_598750, "key", newJString(key))
  add(query_598750, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_598751 = body
  add(query_598750, "prettyPrint", newJBool(prettyPrint))
  result = call_598748.call(path_598749, query_598750, nil, nil, body_598751)

var androidpublisherInappproductsUpdate* = Call_AndroidpublisherInappproductsUpdate_598733(
    name: "androidpublisherInappproductsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsUpdate_598734,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsUpdate_598735, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsGet_598717 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherInappproductsGet_598719(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherInappproductsGet_598718(path: JsonNode;
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
  var valid_598720 = path.getOrDefault("packageName")
  valid_598720 = validateParameter(valid_598720, JString, required = true,
                                 default = nil)
  if valid_598720 != nil:
    section.add "packageName", valid_598720
  var valid_598721 = path.getOrDefault("sku")
  valid_598721 = validateParameter(valid_598721, JString, required = true,
                                 default = nil)
  if valid_598721 != nil:
    section.add "sku", valid_598721
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
  var valid_598722 = query.getOrDefault("fields")
  valid_598722 = validateParameter(valid_598722, JString, required = false,
                                 default = nil)
  if valid_598722 != nil:
    section.add "fields", valid_598722
  var valid_598723 = query.getOrDefault("quotaUser")
  valid_598723 = validateParameter(valid_598723, JString, required = false,
                                 default = nil)
  if valid_598723 != nil:
    section.add "quotaUser", valid_598723
  var valid_598724 = query.getOrDefault("alt")
  valid_598724 = validateParameter(valid_598724, JString, required = false,
                                 default = newJString("json"))
  if valid_598724 != nil:
    section.add "alt", valid_598724
  var valid_598725 = query.getOrDefault("oauth_token")
  valid_598725 = validateParameter(valid_598725, JString, required = false,
                                 default = nil)
  if valid_598725 != nil:
    section.add "oauth_token", valid_598725
  var valid_598726 = query.getOrDefault("userIp")
  valid_598726 = validateParameter(valid_598726, JString, required = false,
                                 default = nil)
  if valid_598726 != nil:
    section.add "userIp", valid_598726
  var valid_598727 = query.getOrDefault("key")
  valid_598727 = validateParameter(valid_598727, JString, required = false,
                                 default = nil)
  if valid_598727 != nil:
    section.add "key", valid_598727
  var valid_598728 = query.getOrDefault("prettyPrint")
  valid_598728 = validateParameter(valid_598728, JBool, required = false,
                                 default = newJBool(true))
  if valid_598728 != nil:
    section.add "prettyPrint", valid_598728
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598729: Call_AndroidpublisherInappproductsGet_598717;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the in-app product specified.
  ## 
  let valid = call_598729.validator(path, query, header, formData, body)
  let scheme = call_598729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598729.url(scheme.get, call_598729.host, call_598729.base,
                         call_598729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598729, url, valid)

proc call*(call_598730: Call_AndroidpublisherInappproductsGet_598717;
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
  var path_598731 = newJObject()
  var query_598732 = newJObject()
  add(query_598732, "fields", newJString(fields))
  add(path_598731, "packageName", newJString(packageName))
  add(query_598732, "quotaUser", newJString(quotaUser))
  add(query_598732, "alt", newJString(alt))
  add(query_598732, "oauth_token", newJString(oauthToken))
  add(query_598732, "userIp", newJString(userIp))
  add(path_598731, "sku", newJString(sku))
  add(query_598732, "key", newJString(key))
  add(query_598732, "prettyPrint", newJBool(prettyPrint))
  result = call_598730.call(path_598731, query_598732, nil, nil, nil)

var androidpublisherInappproductsGet* = Call_AndroidpublisherInappproductsGet_598717(
    name: "androidpublisherInappproductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsGet_598718,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsGet_598719, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsPatch_598768 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherInappproductsPatch_598770(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherInappproductsPatch_598769(path: JsonNode;
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
  var valid_598771 = path.getOrDefault("packageName")
  valid_598771 = validateParameter(valid_598771, JString, required = true,
                                 default = nil)
  if valid_598771 != nil:
    section.add "packageName", valid_598771
  var valid_598772 = path.getOrDefault("sku")
  valid_598772 = validateParameter(valid_598772, JString, required = true,
                                 default = nil)
  if valid_598772 != nil:
    section.add "sku", valid_598772
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
  var valid_598773 = query.getOrDefault("fields")
  valid_598773 = validateParameter(valid_598773, JString, required = false,
                                 default = nil)
  if valid_598773 != nil:
    section.add "fields", valid_598773
  var valid_598774 = query.getOrDefault("quotaUser")
  valid_598774 = validateParameter(valid_598774, JString, required = false,
                                 default = nil)
  if valid_598774 != nil:
    section.add "quotaUser", valid_598774
  var valid_598775 = query.getOrDefault("alt")
  valid_598775 = validateParameter(valid_598775, JString, required = false,
                                 default = newJString("json"))
  if valid_598775 != nil:
    section.add "alt", valid_598775
  var valid_598776 = query.getOrDefault("oauth_token")
  valid_598776 = validateParameter(valid_598776, JString, required = false,
                                 default = nil)
  if valid_598776 != nil:
    section.add "oauth_token", valid_598776
  var valid_598777 = query.getOrDefault("userIp")
  valid_598777 = validateParameter(valid_598777, JString, required = false,
                                 default = nil)
  if valid_598777 != nil:
    section.add "userIp", valid_598777
  var valid_598778 = query.getOrDefault("key")
  valid_598778 = validateParameter(valid_598778, JString, required = false,
                                 default = nil)
  if valid_598778 != nil:
    section.add "key", valid_598778
  var valid_598779 = query.getOrDefault("autoConvertMissingPrices")
  valid_598779 = validateParameter(valid_598779, JBool, required = false, default = nil)
  if valid_598779 != nil:
    section.add "autoConvertMissingPrices", valid_598779
  var valid_598780 = query.getOrDefault("prettyPrint")
  valid_598780 = validateParameter(valid_598780, JBool, required = false,
                                 default = newJBool(true))
  if valid_598780 != nil:
    section.add "prettyPrint", valid_598780
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

proc call*(call_598782: Call_AndroidpublisherInappproductsPatch_598768;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the details of an in-app product. This method supports patch semantics.
  ## 
  let valid = call_598782.validator(path, query, header, formData, body)
  let scheme = call_598782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598782.url(scheme.get, call_598782.host, call_598782.base,
                         call_598782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598782, url, valid)

proc call*(call_598783: Call_AndroidpublisherInappproductsPatch_598768;
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
  var path_598784 = newJObject()
  var query_598785 = newJObject()
  var body_598786 = newJObject()
  add(query_598785, "fields", newJString(fields))
  add(path_598784, "packageName", newJString(packageName))
  add(query_598785, "quotaUser", newJString(quotaUser))
  add(query_598785, "alt", newJString(alt))
  add(query_598785, "oauth_token", newJString(oauthToken))
  add(query_598785, "userIp", newJString(userIp))
  add(path_598784, "sku", newJString(sku))
  add(query_598785, "key", newJString(key))
  add(query_598785, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_598786 = body
  add(query_598785, "prettyPrint", newJBool(prettyPrint))
  result = call_598783.call(path_598784, query_598785, nil, nil, body_598786)

var androidpublisherInappproductsPatch* = Call_AndroidpublisherInappproductsPatch_598768(
    name: "androidpublisherInappproductsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsPatch_598769,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsPatch_598770, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsDelete_598752 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherInappproductsDelete_598754(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherInappproductsDelete_598753(path: JsonNode;
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
  var valid_598755 = path.getOrDefault("packageName")
  valid_598755 = validateParameter(valid_598755, JString, required = true,
                                 default = nil)
  if valid_598755 != nil:
    section.add "packageName", valid_598755
  var valid_598756 = path.getOrDefault("sku")
  valid_598756 = validateParameter(valid_598756, JString, required = true,
                                 default = nil)
  if valid_598756 != nil:
    section.add "sku", valid_598756
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
  var valid_598757 = query.getOrDefault("fields")
  valid_598757 = validateParameter(valid_598757, JString, required = false,
                                 default = nil)
  if valid_598757 != nil:
    section.add "fields", valid_598757
  var valid_598758 = query.getOrDefault("quotaUser")
  valid_598758 = validateParameter(valid_598758, JString, required = false,
                                 default = nil)
  if valid_598758 != nil:
    section.add "quotaUser", valid_598758
  var valid_598759 = query.getOrDefault("alt")
  valid_598759 = validateParameter(valid_598759, JString, required = false,
                                 default = newJString("json"))
  if valid_598759 != nil:
    section.add "alt", valid_598759
  var valid_598760 = query.getOrDefault("oauth_token")
  valid_598760 = validateParameter(valid_598760, JString, required = false,
                                 default = nil)
  if valid_598760 != nil:
    section.add "oauth_token", valid_598760
  var valid_598761 = query.getOrDefault("userIp")
  valid_598761 = validateParameter(valid_598761, JString, required = false,
                                 default = nil)
  if valid_598761 != nil:
    section.add "userIp", valid_598761
  var valid_598762 = query.getOrDefault("key")
  valid_598762 = validateParameter(valid_598762, JString, required = false,
                                 default = nil)
  if valid_598762 != nil:
    section.add "key", valid_598762
  var valid_598763 = query.getOrDefault("prettyPrint")
  valid_598763 = validateParameter(valid_598763, JBool, required = false,
                                 default = newJBool(true))
  if valid_598763 != nil:
    section.add "prettyPrint", valid_598763
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598764: Call_AndroidpublisherInappproductsDelete_598752;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an in-app product for an app.
  ## 
  let valid = call_598764.validator(path, query, header, formData, body)
  let scheme = call_598764.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598764.url(scheme.get, call_598764.host, call_598764.base,
                         call_598764.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598764, url, valid)

proc call*(call_598765: Call_AndroidpublisherInappproductsDelete_598752;
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
  var path_598766 = newJObject()
  var query_598767 = newJObject()
  add(query_598767, "fields", newJString(fields))
  add(path_598766, "packageName", newJString(packageName))
  add(query_598767, "quotaUser", newJString(quotaUser))
  add(query_598767, "alt", newJString(alt))
  add(query_598767, "oauth_token", newJString(oauthToken))
  add(query_598767, "userIp", newJString(userIp))
  add(path_598766, "sku", newJString(sku))
  add(query_598767, "key", newJString(key))
  add(query_598767, "prettyPrint", newJBool(prettyPrint))
  result = call_598765.call(path_598766, query_598767, nil, nil, nil)

var androidpublisherInappproductsDelete* = Call_AndroidpublisherInappproductsDelete_598752(
    name: "androidpublisherInappproductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsDelete_598753,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsDelete_598754, schemes: {Scheme.Https})
type
  Call_AndroidpublisherOrdersRefund_598787 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherOrdersRefund_598789(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherOrdersRefund_598788(path: JsonNode; query: JsonNode;
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
  var valid_598790 = path.getOrDefault("packageName")
  valid_598790 = validateParameter(valid_598790, JString, required = true,
                                 default = nil)
  if valid_598790 != nil:
    section.add "packageName", valid_598790
  var valid_598791 = path.getOrDefault("orderId")
  valid_598791 = validateParameter(valid_598791, JString, required = true,
                                 default = nil)
  if valid_598791 != nil:
    section.add "orderId", valid_598791
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
  var valid_598792 = query.getOrDefault("fields")
  valid_598792 = validateParameter(valid_598792, JString, required = false,
                                 default = nil)
  if valid_598792 != nil:
    section.add "fields", valid_598792
  var valid_598793 = query.getOrDefault("quotaUser")
  valid_598793 = validateParameter(valid_598793, JString, required = false,
                                 default = nil)
  if valid_598793 != nil:
    section.add "quotaUser", valid_598793
  var valid_598794 = query.getOrDefault("alt")
  valid_598794 = validateParameter(valid_598794, JString, required = false,
                                 default = newJString("json"))
  if valid_598794 != nil:
    section.add "alt", valid_598794
  var valid_598795 = query.getOrDefault("oauth_token")
  valid_598795 = validateParameter(valid_598795, JString, required = false,
                                 default = nil)
  if valid_598795 != nil:
    section.add "oauth_token", valid_598795
  var valid_598796 = query.getOrDefault("userIp")
  valid_598796 = validateParameter(valid_598796, JString, required = false,
                                 default = nil)
  if valid_598796 != nil:
    section.add "userIp", valid_598796
  var valid_598797 = query.getOrDefault("key")
  valid_598797 = validateParameter(valid_598797, JString, required = false,
                                 default = nil)
  if valid_598797 != nil:
    section.add "key", valid_598797
  var valid_598798 = query.getOrDefault("revoke")
  valid_598798 = validateParameter(valid_598798, JBool, required = false, default = nil)
  if valid_598798 != nil:
    section.add "revoke", valid_598798
  var valid_598799 = query.getOrDefault("prettyPrint")
  valid_598799 = validateParameter(valid_598799, JBool, required = false,
                                 default = newJBool(true))
  if valid_598799 != nil:
    section.add "prettyPrint", valid_598799
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598800: Call_AndroidpublisherOrdersRefund_598787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Refund a user's subscription or in-app purchase order.
  ## 
  let valid = call_598800.validator(path, query, header, formData, body)
  let scheme = call_598800.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598800.url(scheme.get, call_598800.host, call_598800.base,
                         call_598800.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598800, url, valid)

proc call*(call_598801: Call_AndroidpublisherOrdersRefund_598787;
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
  var path_598802 = newJObject()
  var query_598803 = newJObject()
  add(query_598803, "fields", newJString(fields))
  add(path_598802, "packageName", newJString(packageName))
  add(query_598803, "quotaUser", newJString(quotaUser))
  add(query_598803, "alt", newJString(alt))
  add(query_598803, "oauth_token", newJString(oauthToken))
  add(query_598803, "userIp", newJString(userIp))
  add(path_598802, "orderId", newJString(orderId))
  add(query_598803, "key", newJString(key))
  add(query_598803, "revoke", newJBool(revoke))
  add(query_598803, "prettyPrint", newJBool(prettyPrint))
  result = call_598801.call(path_598802, query_598803, nil, nil, nil)

var androidpublisherOrdersRefund* = Call_AndroidpublisherOrdersRefund_598787(
    name: "androidpublisherOrdersRefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/orders/{orderId}:refund",
    validator: validate_AndroidpublisherOrdersRefund_598788,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherOrdersRefund_598789, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesProductsGet_598804 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherPurchasesProductsGet_598806(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesProductsGet_598805(path: JsonNode;
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
  var valid_598807 = path.getOrDefault("packageName")
  valid_598807 = validateParameter(valid_598807, JString, required = true,
                                 default = nil)
  if valid_598807 != nil:
    section.add "packageName", valid_598807
  var valid_598808 = path.getOrDefault("token")
  valid_598808 = validateParameter(valid_598808, JString, required = true,
                                 default = nil)
  if valid_598808 != nil:
    section.add "token", valid_598808
  var valid_598809 = path.getOrDefault("productId")
  valid_598809 = validateParameter(valid_598809, JString, required = true,
                                 default = nil)
  if valid_598809 != nil:
    section.add "productId", valid_598809
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
  var valid_598810 = query.getOrDefault("fields")
  valid_598810 = validateParameter(valid_598810, JString, required = false,
                                 default = nil)
  if valid_598810 != nil:
    section.add "fields", valid_598810
  var valid_598811 = query.getOrDefault("quotaUser")
  valid_598811 = validateParameter(valid_598811, JString, required = false,
                                 default = nil)
  if valid_598811 != nil:
    section.add "quotaUser", valid_598811
  var valid_598812 = query.getOrDefault("alt")
  valid_598812 = validateParameter(valid_598812, JString, required = false,
                                 default = newJString("json"))
  if valid_598812 != nil:
    section.add "alt", valid_598812
  var valid_598813 = query.getOrDefault("oauth_token")
  valid_598813 = validateParameter(valid_598813, JString, required = false,
                                 default = nil)
  if valid_598813 != nil:
    section.add "oauth_token", valid_598813
  var valid_598814 = query.getOrDefault("userIp")
  valid_598814 = validateParameter(valid_598814, JString, required = false,
                                 default = nil)
  if valid_598814 != nil:
    section.add "userIp", valid_598814
  var valid_598815 = query.getOrDefault("key")
  valid_598815 = validateParameter(valid_598815, JString, required = false,
                                 default = nil)
  if valid_598815 != nil:
    section.add "key", valid_598815
  var valid_598816 = query.getOrDefault("prettyPrint")
  valid_598816 = validateParameter(valid_598816, JBool, required = false,
                                 default = newJBool(true))
  if valid_598816 != nil:
    section.add "prettyPrint", valid_598816
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598817: Call_AndroidpublisherPurchasesProductsGet_598804;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks the purchase and consumption status of an inapp item.
  ## 
  let valid = call_598817.validator(path, query, header, formData, body)
  let scheme = call_598817.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598817.url(scheme.get, call_598817.host, call_598817.base,
                         call_598817.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598817, url, valid)

proc call*(call_598818: Call_AndroidpublisherPurchasesProductsGet_598804;
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
  var path_598819 = newJObject()
  var query_598820 = newJObject()
  add(query_598820, "fields", newJString(fields))
  add(path_598819, "packageName", newJString(packageName))
  add(query_598820, "quotaUser", newJString(quotaUser))
  add(query_598820, "alt", newJString(alt))
  add(query_598820, "oauth_token", newJString(oauthToken))
  add(query_598820, "userIp", newJString(userIp))
  add(query_598820, "key", newJString(key))
  add(path_598819, "token", newJString(token))
  add(path_598819, "productId", newJString(productId))
  add(query_598820, "prettyPrint", newJBool(prettyPrint))
  result = call_598818.call(path_598819, query_598820, nil, nil, nil)

var androidpublisherPurchasesProductsGet* = Call_AndroidpublisherPurchasesProductsGet_598804(
    name: "androidpublisherPurchasesProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/purchases/products/{productId}/tokens/{token}",
    validator: validate_AndroidpublisherPurchasesProductsGet_598805,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesProductsGet_598806, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsGet_598821 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherPurchasesSubscriptionsGet_598823(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesSubscriptionsGet_598822(path: JsonNode;
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
  var valid_598824 = path.getOrDefault("packageName")
  valid_598824 = validateParameter(valid_598824, JString, required = true,
                                 default = nil)
  if valid_598824 != nil:
    section.add "packageName", valid_598824
  var valid_598825 = path.getOrDefault("subscriptionId")
  valid_598825 = validateParameter(valid_598825, JString, required = true,
                                 default = nil)
  if valid_598825 != nil:
    section.add "subscriptionId", valid_598825
  var valid_598826 = path.getOrDefault("token")
  valid_598826 = validateParameter(valid_598826, JString, required = true,
                                 default = nil)
  if valid_598826 != nil:
    section.add "token", valid_598826
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
  var valid_598827 = query.getOrDefault("fields")
  valid_598827 = validateParameter(valid_598827, JString, required = false,
                                 default = nil)
  if valid_598827 != nil:
    section.add "fields", valid_598827
  var valid_598828 = query.getOrDefault("quotaUser")
  valid_598828 = validateParameter(valid_598828, JString, required = false,
                                 default = nil)
  if valid_598828 != nil:
    section.add "quotaUser", valid_598828
  var valid_598829 = query.getOrDefault("alt")
  valid_598829 = validateParameter(valid_598829, JString, required = false,
                                 default = newJString("json"))
  if valid_598829 != nil:
    section.add "alt", valid_598829
  var valid_598830 = query.getOrDefault("oauth_token")
  valid_598830 = validateParameter(valid_598830, JString, required = false,
                                 default = nil)
  if valid_598830 != nil:
    section.add "oauth_token", valid_598830
  var valid_598831 = query.getOrDefault("userIp")
  valid_598831 = validateParameter(valid_598831, JString, required = false,
                                 default = nil)
  if valid_598831 != nil:
    section.add "userIp", valid_598831
  var valid_598832 = query.getOrDefault("key")
  valid_598832 = validateParameter(valid_598832, JString, required = false,
                                 default = nil)
  if valid_598832 != nil:
    section.add "key", valid_598832
  var valid_598833 = query.getOrDefault("prettyPrint")
  valid_598833 = validateParameter(valid_598833, JBool, required = false,
                                 default = newJBool(true))
  if valid_598833 != nil:
    section.add "prettyPrint", valid_598833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598834: Call_AndroidpublisherPurchasesSubscriptionsGet_598821;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ## 
  let valid = call_598834.validator(path, query, header, formData, body)
  let scheme = call_598834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598834.url(scheme.get, call_598834.host, call_598834.base,
                         call_598834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598834, url, valid)

proc call*(call_598835: Call_AndroidpublisherPurchasesSubscriptionsGet_598821;
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
  var path_598836 = newJObject()
  var query_598837 = newJObject()
  add(query_598837, "fields", newJString(fields))
  add(path_598836, "packageName", newJString(packageName))
  add(query_598837, "quotaUser", newJString(quotaUser))
  add(query_598837, "alt", newJString(alt))
  add(path_598836, "subscriptionId", newJString(subscriptionId))
  add(query_598837, "oauth_token", newJString(oauthToken))
  add(query_598837, "userIp", newJString(userIp))
  add(query_598837, "key", newJString(key))
  add(path_598836, "token", newJString(token))
  add(query_598837, "prettyPrint", newJBool(prettyPrint))
  result = call_598835.call(path_598836, query_598837, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsGet* = Call_AndroidpublisherPurchasesSubscriptionsGet_598821(
    name: "androidpublisherPurchasesSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}",
    validator: validate_AndroidpublisherPurchasesSubscriptionsGet_598822,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsGet_598823,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsCancel_598838 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherPurchasesSubscriptionsCancel_598840(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesSubscriptionsCancel_598839(path: JsonNode;
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
  var valid_598841 = path.getOrDefault("packageName")
  valid_598841 = validateParameter(valid_598841, JString, required = true,
                                 default = nil)
  if valid_598841 != nil:
    section.add "packageName", valid_598841
  var valid_598842 = path.getOrDefault("subscriptionId")
  valid_598842 = validateParameter(valid_598842, JString, required = true,
                                 default = nil)
  if valid_598842 != nil:
    section.add "subscriptionId", valid_598842
  var valid_598843 = path.getOrDefault("token")
  valid_598843 = validateParameter(valid_598843, JString, required = true,
                                 default = nil)
  if valid_598843 != nil:
    section.add "token", valid_598843
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
  var valid_598844 = query.getOrDefault("fields")
  valid_598844 = validateParameter(valid_598844, JString, required = false,
                                 default = nil)
  if valid_598844 != nil:
    section.add "fields", valid_598844
  var valid_598845 = query.getOrDefault("quotaUser")
  valid_598845 = validateParameter(valid_598845, JString, required = false,
                                 default = nil)
  if valid_598845 != nil:
    section.add "quotaUser", valid_598845
  var valid_598846 = query.getOrDefault("alt")
  valid_598846 = validateParameter(valid_598846, JString, required = false,
                                 default = newJString("json"))
  if valid_598846 != nil:
    section.add "alt", valid_598846
  var valid_598847 = query.getOrDefault("oauth_token")
  valid_598847 = validateParameter(valid_598847, JString, required = false,
                                 default = nil)
  if valid_598847 != nil:
    section.add "oauth_token", valid_598847
  var valid_598848 = query.getOrDefault("userIp")
  valid_598848 = validateParameter(valid_598848, JString, required = false,
                                 default = nil)
  if valid_598848 != nil:
    section.add "userIp", valid_598848
  var valid_598849 = query.getOrDefault("key")
  valid_598849 = validateParameter(valid_598849, JString, required = false,
                                 default = nil)
  if valid_598849 != nil:
    section.add "key", valid_598849
  var valid_598850 = query.getOrDefault("prettyPrint")
  valid_598850 = validateParameter(valid_598850, JBool, required = false,
                                 default = newJBool(true))
  if valid_598850 != nil:
    section.add "prettyPrint", valid_598850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598851: Call_AndroidpublisherPurchasesSubscriptionsCancel_598838;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ## 
  let valid = call_598851.validator(path, query, header, formData, body)
  let scheme = call_598851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598851.url(scheme.get, call_598851.host, call_598851.base,
                         call_598851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598851, url, valid)

proc call*(call_598852: Call_AndroidpublisherPurchasesSubscriptionsCancel_598838;
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
  var path_598853 = newJObject()
  var query_598854 = newJObject()
  add(query_598854, "fields", newJString(fields))
  add(path_598853, "packageName", newJString(packageName))
  add(query_598854, "quotaUser", newJString(quotaUser))
  add(query_598854, "alt", newJString(alt))
  add(path_598853, "subscriptionId", newJString(subscriptionId))
  add(query_598854, "oauth_token", newJString(oauthToken))
  add(query_598854, "userIp", newJString(userIp))
  add(query_598854, "key", newJString(key))
  add(path_598853, "token", newJString(token))
  add(query_598854, "prettyPrint", newJBool(prettyPrint))
  result = call_598852.call(path_598853, query_598854, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsCancel* = Call_AndroidpublisherPurchasesSubscriptionsCancel_598838(
    name: "androidpublisherPurchasesSubscriptionsCancel",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:cancel",
    validator: validate_AndroidpublisherPurchasesSubscriptionsCancel_598839,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsCancel_598840,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsDefer_598855 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherPurchasesSubscriptionsDefer_598857(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesSubscriptionsDefer_598856(path: JsonNode;
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
  var valid_598858 = path.getOrDefault("packageName")
  valid_598858 = validateParameter(valid_598858, JString, required = true,
                                 default = nil)
  if valid_598858 != nil:
    section.add "packageName", valid_598858
  var valid_598859 = path.getOrDefault("subscriptionId")
  valid_598859 = validateParameter(valid_598859, JString, required = true,
                                 default = nil)
  if valid_598859 != nil:
    section.add "subscriptionId", valid_598859
  var valid_598860 = path.getOrDefault("token")
  valid_598860 = validateParameter(valid_598860, JString, required = true,
                                 default = nil)
  if valid_598860 != nil:
    section.add "token", valid_598860
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
  var valid_598861 = query.getOrDefault("fields")
  valid_598861 = validateParameter(valid_598861, JString, required = false,
                                 default = nil)
  if valid_598861 != nil:
    section.add "fields", valid_598861
  var valid_598862 = query.getOrDefault("quotaUser")
  valid_598862 = validateParameter(valid_598862, JString, required = false,
                                 default = nil)
  if valid_598862 != nil:
    section.add "quotaUser", valid_598862
  var valid_598863 = query.getOrDefault("alt")
  valid_598863 = validateParameter(valid_598863, JString, required = false,
                                 default = newJString("json"))
  if valid_598863 != nil:
    section.add "alt", valid_598863
  var valid_598864 = query.getOrDefault("oauth_token")
  valid_598864 = validateParameter(valid_598864, JString, required = false,
                                 default = nil)
  if valid_598864 != nil:
    section.add "oauth_token", valid_598864
  var valid_598865 = query.getOrDefault("userIp")
  valid_598865 = validateParameter(valid_598865, JString, required = false,
                                 default = nil)
  if valid_598865 != nil:
    section.add "userIp", valid_598865
  var valid_598866 = query.getOrDefault("key")
  valid_598866 = validateParameter(valid_598866, JString, required = false,
                                 default = nil)
  if valid_598866 != nil:
    section.add "key", valid_598866
  var valid_598867 = query.getOrDefault("prettyPrint")
  valid_598867 = validateParameter(valid_598867, JBool, required = false,
                                 default = newJBool(true))
  if valid_598867 != nil:
    section.add "prettyPrint", valid_598867
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

proc call*(call_598869: Call_AndroidpublisherPurchasesSubscriptionsDefer_598855;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Defers a user's subscription purchase until a specified future expiration time.
  ## 
  let valid = call_598869.validator(path, query, header, formData, body)
  let scheme = call_598869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598869.url(scheme.get, call_598869.host, call_598869.base,
                         call_598869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598869, url, valid)

proc call*(call_598870: Call_AndroidpublisherPurchasesSubscriptionsDefer_598855;
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
  var path_598871 = newJObject()
  var query_598872 = newJObject()
  var body_598873 = newJObject()
  add(query_598872, "fields", newJString(fields))
  add(path_598871, "packageName", newJString(packageName))
  add(query_598872, "quotaUser", newJString(quotaUser))
  add(query_598872, "alt", newJString(alt))
  add(path_598871, "subscriptionId", newJString(subscriptionId))
  add(query_598872, "oauth_token", newJString(oauthToken))
  add(query_598872, "userIp", newJString(userIp))
  add(query_598872, "key", newJString(key))
  add(path_598871, "token", newJString(token))
  if body != nil:
    body_598873 = body
  add(query_598872, "prettyPrint", newJBool(prettyPrint))
  result = call_598870.call(path_598871, query_598872, nil, nil, body_598873)

var androidpublisherPurchasesSubscriptionsDefer* = Call_AndroidpublisherPurchasesSubscriptionsDefer_598855(
    name: "androidpublisherPurchasesSubscriptionsDefer",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:defer",
    validator: validate_AndroidpublisherPurchasesSubscriptionsDefer_598856,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsDefer_598857,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsRefund_598874 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherPurchasesSubscriptionsRefund_598876(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesSubscriptionsRefund_598875(path: JsonNode;
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
  var valid_598877 = path.getOrDefault("packageName")
  valid_598877 = validateParameter(valid_598877, JString, required = true,
                                 default = nil)
  if valid_598877 != nil:
    section.add "packageName", valid_598877
  var valid_598878 = path.getOrDefault("subscriptionId")
  valid_598878 = validateParameter(valid_598878, JString, required = true,
                                 default = nil)
  if valid_598878 != nil:
    section.add "subscriptionId", valid_598878
  var valid_598879 = path.getOrDefault("token")
  valid_598879 = validateParameter(valid_598879, JString, required = true,
                                 default = nil)
  if valid_598879 != nil:
    section.add "token", valid_598879
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
  var valid_598880 = query.getOrDefault("fields")
  valid_598880 = validateParameter(valid_598880, JString, required = false,
                                 default = nil)
  if valid_598880 != nil:
    section.add "fields", valid_598880
  var valid_598881 = query.getOrDefault("quotaUser")
  valid_598881 = validateParameter(valid_598881, JString, required = false,
                                 default = nil)
  if valid_598881 != nil:
    section.add "quotaUser", valid_598881
  var valid_598882 = query.getOrDefault("alt")
  valid_598882 = validateParameter(valid_598882, JString, required = false,
                                 default = newJString("json"))
  if valid_598882 != nil:
    section.add "alt", valid_598882
  var valid_598883 = query.getOrDefault("oauth_token")
  valid_598883 = validateParameter(valid_598883, JString, required = false,
                                 default = nil)
  if valid_598883 != nil:
    section.add "oauth_token", valid_598883
  var valid_598884 = query.getOrDefault("userIp")
  valid_598884 = validateParameter(valid_598884, JString, required = false,
                                 default = nil)
  if valid_598884 != nil:
    section.add "userIp", valid_598884
  var valid_598885 = query.getOrDefault("key")
  valid_598885 = validateParameter(valid_598885, JString, required = false,
                                 default = nil)
  if valid_598885 != nil:
    section.add "key", valid_598885
  var valid_598886 = query.getOrDefault("prettyPrint")
  valid_598886 = validateParameter(valid_598886, JBool, required = false,
                                 default = newJBool(true))
  if valid_598886 != nil:
    section.add "prettyPrint", valid_598886
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598887: Call_AndroidpublisherPurchasesSubscriptionsRefund_598874;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refunds a user's subscription purchase, but the subscription remains valid until its expiration time and it will continue to recur.
  ## 
  let valid = call_598887.validator(path, query, header, formData, body)
  let scheme = call_598887.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598887.url(scheme.get, call_598887.host, call_598887.base,
                         call_598887.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598887, url, valid)

proc call*(call_598888: Call_AndroidpublisherPurchasesSubscriptionsRefund_598874;
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
  var path_598889 = newJObject()
  var query_598890 = newJObject()
  add(query_598890, "fields", newJString(fields))
  add(path_598889, "packageName", newJString(packageName))
  add(query_598890, "quotaUser", newJString(quotaUser))
  add(query_598890, "alt", newJString(alt))
  add(path_598889, "subscriptionId", newJString(subscriptionId))
  add(query_598890, "oauth_token", newJString(oauthToken))
  add(query_598890, "userIp", newJString(userIp))
  add(query_598890, "key", newJString(key))
  add(path_598889, "token", newJString(token))
  add(query_598890, "prettyPrint", newJBool(prettyPrint))
  result = call_598888.call(path_598889, query_598890, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsRefund* = Call_AndroidpublisherPurchasesSubscriptionsRefund_598874(
    name: "androidpublisherPurchasesSubscriptionsRefund",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:refund",
    validator: validate_AndroidpublisherPurchasesSubscriptionsRefund_598875,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsRefund_598876,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsRevoke_598891 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherPurchasesSubscriptionsRevoke_598893(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesSubscriptionsRevoke_598892(path: JsonNode;
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
  var valid_598894 = path.getOrDefault("packageName")
  valid_598894 = validateParameter(valid_598894, JString, required = true,
                                 default = nil)
  if valid_598894 != nil:
    section.add "packageName", valid_598894
  var valid_598895 = path.getOrDefault("subscriptionId")
  valid_598895 = validateParameter(valid_598895, JString, required = true,
                                 default = nil)
  if valid_598895 != nil:
    section.add "subscriptionId", valid_598895
  var valid_598896 = path.getOrDefault("token")
  valid_598896 = validateParameter(valid_598896, JString, required = true,
                                 default = nil)
  if valid_598896 != nil:
    section.add "token", valid_598896
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
  var valid_598897 = query.getOrDefault("fields")
  valid_598897 = validateParameter(valid_598897, JString, required = false,
                                 default = nil)
  if valid_598897 != nil:
    section.add "fields", valid_598897
  var valid_598898 = query.getOrDefault("quotaUser")
  valid_598898 = validateParameter(valid_598898, JString, required = false,
                                 default = nil)
  if valid_598898 != nil:
    section.add "quotaUser", valid_598898
  var valid_598899 = query.getOrDefault("alt")
  valid_598899 = validateParameter(valid_598899, JString, required = false,
                                 default = newJString("json"))
  if valid_598899 != nil:
    section.add "alt", valid_598899
  var valid_598900 = query.getOrDefault("oauth_token")
  valid_598900 = validateParameter(valid_598900, JString, required = false,
                                 default = nil)
  if valid_598900 != nil:
    section.add "oauth_token", valid_598900
  var valid_598901 = query.getOrDefault("userIp")
  valid_598901 = validateParameter(valid_598901, JString, required = false,
                                 default = nil)
  if valid_598901 != nil:
    section.add "userIp", valid_598901
  var valid_598902 = query.getOrDefault("key")
  valid_598902 = validateParameter(valid_598902, JString, required = false,
                                 default = nil)
  if valid_598902 != nil:
    section.add "key", valid_598902
  var valid_598903 = query.getOrDefault("prettyPrint")
  valid_598903 = validateParameter(valid_598903, JBool, required = false,
                                 default = newJBool(true))
  if valid_598903 != nil:
    section.add "prettyPrint", valid_598903
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598904: Call_AndroidpublisherPurchasesSubscriptionsRevoke_598891;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refunds and immediately revokes a user's subscription purchase. Access to the subscription will be terminated immediately and it will stop recurring.
  ## 
  let valid = call_598904.validator(path, query, header, formData, body)
  let scheme = call_598904.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598904.url(scheme.get, call_598904.host, call_598904.base,
                         call_598904.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598904, url, valid)

proc call*(call_598905: Call_AndroidpublisherPurchasesSubscriptionsRevoke_598891;
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
  var path_598906 = newJObject()
  var query_598907 = newJObject()
  add(query_598907, "fields", newJString(fields))
  add(path_598906, "packageName", newJString(packageName))
  add(query_598907, "quotaUser", newJString(quotaUser))
  add(query_598907, "alt", newJString(alt))
  add(path_598906, "subscriptionId", newJString(subscriptionId))
  add(query_598907, "oauth_token", newJString(oauthToken))
  add(query_598907, "userIp", newJString(userIp))
  add(query_598907, "key", newJString(key))
  add(path_598906, "token", newJString(token))
  add(query_598907, "prettyPrint", newJBool(prettyPrint))
  result = call_598905.call(path_598906, query_598907, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsRevoke* = Call_AndroidpublisherPurchasesSubscriptionsRevoke_598891(
    name: "androidpublisherPurchasesSubscriptionsRevoke",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:revoke",
    validator: validate_AndroidpublisherPurchasesSubscriptionsRevoke_598892,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsRevoke_598893,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesVoidedpurchasesList_598908 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherPurchasesVoidedpurchasesList_598910(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesVoidedpurchasesList_598909(path: JsonNode;
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
  var valid_598911 = path.getOrDefault("packageName")
  valid_598911 = validateParameter(valid_598911, JString, required = true,
                                 default = nil)
  if valid_598911 != nil:
    section.add "packageName", valid_598911
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
  var valid_598912 = query.getOrDefault("token")
  valid_598912 = validateParameter(valid_598912, JString, required = false,
                                 default = nil)
  if valid_598912 != nil:
    section.add "token", valid_598912
  var valid_598913 = query.getOrDefault("fields")
  valid_598913 = validateParameter(valid_598913, JString, required = false,
                                 default = nil)
  if valid_598913 != nil:
    section.add "fields", valid_598913
  var valid_598914 = query.getOrDefault("quotaUser")
  valid_598914 = validateParameter(valid_598914, JString, required = false,
                                 default = nil)
  if valid_598914 != nil:
    section.add "quotaUser", valid_598914
  var valid_598915 = query.getOrDefault("alt")
  valid_598915 = validateParameter(valid_598915, JString, required = false,
                                 default = newJString("json"))
  if valid_598915 != nil:
    section.add "alt", valid_598915
  var valid_598916 = query.getOrDefault("oauth_token")
  valid_598916 = validateParameter(valid_598916, JString, required = false,
                                 default = nil)
  if valid_598916 != nil:
    section.add "oauth_token", valid_598916
  var valid_598917 = query.getOrDefault("endTime")
  valid_598917 = validateParameter(valid_598917, JString, required = false,
                                 default = nil)
  if valid_598917 != nil:
    section.add "endTime", valid_598917
  var valid_598918 = query.getOrDefault("userIp")
  valid_598918 = validateParameter(valid_598918, JString, required = false,
                                 default = nil)
  if valid_598918 != nil:
    section.add "userIp", valid_598918
  var valid_598919 = query.getOrDefault("maxResults")
  valid_598919 = validateParameter(valid_598919, JInt, required = false, default = nil)
  if valid_598919 != nil:
    section.add "maxResults", valid_598919
  var valid_598920 = query.getOrDefault("key")
  valid_598920 = validateParameter(valid_598920, JString, required = false,
                                 default = nil)
  if valid_598920 != nil:
    section.add "key", valid_598920
  var valid_598921 = query.getOrDefault("prettyPrint")
  valid_598921 = validateParameter(valid_598921, JBool, required = false,
                                 default = newJBool(true))
  if valid_598921 != nil:
    section.add "prettyPrint", valid_598921
  var valid_598922 = query.getOrDefault("startTime")
  valid_598922 = validateParameter(valid_598922, JString, required = false,
                                 default = nil)
  if valid_598922 != nil:
    section.add "startTime", valid_598922
  var valid_598923 = query.getOrDefault("startIndex")
  valid_598923 = validateParameter(valid_598923, JInt, required = false, default = nil)
  if valid_598923 != nil:
    section.add "startIndex", valid_598923
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598924: Call_AndroidpublisherPurchasesVoidedpurchasesList_598908;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the purchases that were canceled, refunded or charged-back.
  ## 
  let valid = call_598924.validator(path, query, header, formData, body)
  let scheme = call_598924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598924.url(scheme.get, call_598924.host, call_598924.base,
                         call_598924.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598924, url, valid)

proc call*(call_598925: Call_AndroidpublisherPurchasesVoidedpurchasesList_598908;
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
  var path_598926 = newJObject()
  var query_598927 = newJObject()
  add(query_598927, "token", newJString(token))
  add(query_598927, "fields", newJString(fields))
  add(path_598926, "packageName", newJString(packageName))
  add(query_598927, "quotaUser", newJString(quotaUser))
  add(query_598927, "alt", newJString(alt))
  add(query_598927, "oauth_token", newJString(oauthToken))
  add(query_598927, "endTime", newJString(endTime))
  add(query_598927, "userIp", newJString(userIp))
  add(query_598927, "maxResults", newJInt(maxResults))
  add(query_598927, "key", newJString(key))
  add(query_598927, "prettyPrint", newJBool(prettyPrint))
  add(query_598927, "startTime", newJString(startTime))
  add(query_598927, "startIndex", newJInt(startIndex))
  result = call_598925.call(path_598926, query_598927, nil, nil, nil)

var androidpublisherPurchasesVoidedpurchasesList* = Call_AndroidpublisherPurchasesVoidedpurchasesList_598908(
    name: "androidpublisherPurchasesVoidedpurchasesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{packageName}/purchases/voidedpurchases",
    validator: validate_AndroidpublisherPurchasesVoidedpurchasesList_598909,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesVoidedpurchasesList_598910,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsList_598928 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherReviewsList_598930(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherReviewsList_598929(path: JsonNode; query: JsonNode;
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
  var valid_598931 = path.getOrDefault("packageName")
  valid_598931 = validateParameter(valid_598931, JString, required = true,
                                 default = nil)
  if valid_598931 != nil:
    section.add "packageName", valid_598931
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
  var valid_598932 = query.getOrDefault("translationLanguage")
  valid_598932 = validateParameter(valid_598932, JString, required = false,
                                 default = nil)
  if valid_598932 != nil:
    section.add "translationLanguage", valid_598932
  var valid_598933 = query.getOrDefault("token")
  valid_598933 = validateParameter(valid_598933, JString, required = false,
                                 default = nil)
  if valid_598933 != nil:
    section.add "token", valid_598933
  var valid_598934 = query.getOrDefault("fields")
  valid_598934 = validateParameter(valid_598934, JString, required = false,
                                 default = nil)
  if valid_598934 != nil:
    section.add "fields", valid_598934
  var valid_598935 = query.getOrDefault("quotaUser")
  valid_598935 = validateParameter(valid_598935, JString, required = false,
                                 default = nil)
  if valid_598935 != nil:
    section.add "quotaUser", valid_598935
  var valid_598936 = query.getOrDefault("alt")
  valid_598936 = validateParameter(valid_598936, JString, required = false,
                                 default = newJString("json"))
  if valid_598936 != nil:
    section.add "alt", valid_598936
  var valid_598937 = query.getOrDefault("oauth_token")
  valid_598937 = validateParameter(valid_598937, JString, required = false,
                                 default = nil)
  if valid_598937 != nil:
    section.add "oauth_token", valid_598937
  var valid_598938 = query.getOrDefault("userIp")
  valid_598938 = validateParameter(valid_598938, JString, required = false,
                                 default = nil)
  if valid_598938 != nil:
    section.add "userIp", valid_598938
  var valid_598939 = query.getOrDefault("maxResults")
  valid_598939 = validateParameter(valid_598939, JInt, required = false, default = nil)
  if valid_598939 != nil:
    section.add "maxResults", valid_598939
  var valid_598940 = query.getOrDefault("key")
  valid_598940 = validateParameter(valid_598940, JString, required = false,
                                 default = nil)
  if valid_598940 != nil:
    section.add "key", valid_598940
  var valid_598941 = query.getOrDefault("prettyPrint")
  valid_598941 = validateParameter(valid_598941, JBool, required = false,
                                 default = newJBool(true))
  if valid_598941 != nil:
    section.add "prettyPrint", valid_598941
  var valid_598942 = query.getOrDefault("startIndex")
  valid_598942 = validateParameter(valid_598942, JInt, required = false, default = nil)
  if valid_598942 != nil:
    section.add "startIndex", valid_598942
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598943: Call_AndroidpublisherReviewsList_598928; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of reviews. Only reviews from last week will be returned.
  ## 
  let valid = call_598943.validator(path, query, header, formData, body)
  let scheme = call_598943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598943.url(scheme.get, call_598943.host, call_598943.base,
                         call_598943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598943, url, valid)

proc call*(call_598944: Call_AndroidpublisherReviewsList_598928;
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
  var path_598945 = newJObject()
  var query_598946 = newJObject()
  add(query_598946, "translationLanguage", newJString(translationLanguage))
  add(query_598946, "token", newJString(token))
  add(query_598946, "fields", newJString(fields))
  add(path_598945, "packageName", newJString(packageName))
  add(query_598946, "quotaUser", newJString(quotaUser))
  add(query_598946, "alt", newJString(alt))
  add(query_598946, "oauth_token", newJString(oauthToken))
  add(query_598946, "userIp", newJString(userIp))
  add(query_598946, "maxResults", newJInt(maxResults))
  add(query_598946, "key", newJString(key))
  add(query_598946, "prettyPrint", newJBool(prettyPrint))
  add(query_598946, "startIndex", newJInt(startIndex))
  result = call_598944.call(path_598945, query_598946, nil, nil, nil)

var androidpublisherReviewsList* = Call_AndroidpublisherReviewsList_598928(
    name: "androidpublisherReviewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/reviews",
    validator: validate_AndroidpublisherReviewsList_598929,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherReviewsList_598930, schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsGet_598947 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherReviewsGet_598949(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherReviewsGet_598948(path: JsonNode; query: JsonNode;
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
  var valid_598950 = path.getOrDefault("packageName")
  valid_598950 = validateParameter(valid_598950, JString, required = true,
                                 default = nil)
  if valid_598950 != nil:
    section.add "packageName", valid_598950
  var valid_598951 = path.getOrDefault("reviewId")
  valid_598951 = validateParameter(valid_598951, JString, required = true,
                                 default = nil)
  if valid_598951 != nil:
    section.add "reviewId", valid_598951
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
  var valid_598952 = query.getOrDefault("translationLanguage")
  valid_598952 = validateParameter(valid_598952, JString, required = false,
                                 default = nil)
  if valid_598952 != nil:
    section.add "translationLanguage", valid_598952
  var valid_598953 = query.getOrDefault("fields")
  valid_598953 = validateParameter(valid_598953, JString, required = false,
                                 default = nil)
  if valid_598953 != nil:
    section.add "fields", valid_598953
  var valid_598954 = query.getOrDefault("quotaUser")
  valid_598954 = validateParameter(valid_598954, JString, required = false,
                                 default = nil)
  if valid_598954 != nil:
    section.add "quotaUser", valid_598954
  var valid_598955 = query.getOrDefault("alt")
  valid_598955 = validateParameter(valid_598955, JString, required = false,
                                 default = newJString("json"))
  if valid_598955 != nil:
    section.add "alt", valid_598955
  var valid_598956 = query.getOrDefault("oauth_token")
  valid_598956 = validateParameter(valid_598956, JString, required = false,
                                 default = nil)
  if valid_598956 != nil:
    section.add "oauth_token", valid_598956
  var valid_598957 = query.getOrDefault("userIp")
  valid_598957 = validateParameter(valid_598957, JString, required = false,
                                 default = nil)
  if valid_598957 != nil:
    section.add "userIp", valid_598957
  var valid_598958 = query.getOrDefault("key")
  valid_598958 = validateParameter(valid_598958, JString, required = false,
                                 default = nil)
  if valid_598958 != nil:
    section.add "key", valid_598958
  var valid_598959 = query.getOrDefault("prettyPrint")
  valid_598959 = validateParameter(valid_598959, JBool, required = false,
                                 default = newJBool(true))
  if valid_598959 != nil:
    section.add "prettyPrint", valid_598959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598960: Call_AndroidpublisherReviewsGet_598947; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a single review.
  ## 
  let valid = call_598960.validator(path, query, header, formData, body)
  let scheme = call_598960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598960.url(scheme.get, call_598960.host, call_598960.base,
                         call_598960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598960, url, valid)

proc call*(call_598961: Call_AndroidpublisherReviewsGet_598947;
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
  var path_598962 = newJObject()
  var query_598963 = newJObject()
  add(query_598963, "translationLanguage", newJString(translationLanguage))
  add(query_598963, "fields", newJString(fields))
  add(path_598962, "packageName", newJString(packageName))
  add(query_598963, "quotaUser", newJString(quotaUser))
  add(query_598963, "alt", newJString(alt))
  add(query_598963, "oauth_token", newJString(oauthToken))
  add(path_598962, "reviewId", newJString(reviewId))
  add(query_598963, "userIp", newJString(userIp))
  add(query_598963, "key", newJString(key))
  add(query_598963, "prettyPrint", newJBool(prettyPrint))
  result = call_598961.call(path_598962, query_598963, nil, nil, nil)

var androidpublisherReviewsGet* = Call_AndroidpublisherReviewsGet_598947(
    name: "androidpublisherReviewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/reviews/{reviewId}",
    validator: validate_AndroidpublisherReviewsGet_598948,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherReviewsGet_598949, schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsReply_598964 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherReviewsReply_598966(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherReviewsReply_598965(path: JsonNode; query: JsonNode;
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
  var valid_598967 = path.getOrDefault("packageName")
  valid_598967 = validateParameter(valid_598967, JString, required = true,
                                 default = nil)
  if valid_598967 != nil:
    section.add "packageName", valid_598967
  var valid_598968 = path.getOrDefault("reviewId")
  valid_598968 = validateParameter(valid_598968, JString, required = true,
                                 default = nil)
  if valid_598968 != nil:
    section.add "reviewId", valid_598968
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
  var valid_598969 = query.getOrDefault("fields")
  valid_598969 = validateParameter(valid_598969, JString, required = false,
                                 default = nil)
  if valid_598969 != nil:
    section.add "fields", valid_598969
  var valid_598970 = query.getOrDefault("quotaUser")
  valid_598970 = validateParameter(valid_598970, JString, required = false,
                                 default = nil)
  if valid_598970 != nil:
    section.add "quotaUser", valid_598970
  var valid_598971 = query.getOrDefault("alt")
  valid_598971 = validateParameter(valid_598971, JString, required = false,
                                 default = newJString("json"))
  if valid_598971 != nil:
    section.add "alt", valid_598971
  var valid_598972 = query.getOrDefault("oauth_token")
  valid_598972 = validateParameter(valid_598972, JString, required = false,
                                 default = nil)
  if valid_598972 != nil:
    section.add "oauth_token", valid_598972
  var valid_598973 = query.getOrDefault("userIp")
  valid_598973 = validateParameter(valid_598973, JString, required = false,
                                 default = nil)
  if valid_598973 != nil:
    section.add "userIp", valid_598973
  var valid_598974 = query.getOrDefault("key")
  valid_598974 = validateParameter(valid_598974, JString, required = false,
                                 default = nil)
  if valid_598974 != nil:
    section.add "key", valid_598974
  var valid_598975 = query.getOrDefault("prettyPrint")
  valid_598975 = validateParameter(valid_598975, JBool, required = false,
                                 default = newJBool(true))
  if valid_598975 != nil:
    section.add "prettyPrint", valid_598975
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

proc call*(call_598977: Call_AndroidpublisherReviewsReply_598964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reply to a single review, or update an existing reply.
  ## 
  let valid = call_598977.validator(path, query, header, formData, body)
  let scheme = call_598977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598977.url(scheme.get, call_598977.host, call_598977.base,
                         call_598977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598977, url, valid)

proc call*(call_598978: Call_AndroidpublisherReviewsReply_598964;
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
  var path_598979 = newJObject()
  var query_598980 = newJObject()
  var body_598981 = newJObject()
  add(query_598980, "fields", newJString(fields))
  add(path_598979, "packageName", newJString(packageName))
  add(query_598980, "quotaUser", newJString(quotaUser))
  add(query_598980, "alt", newJString(alt))
  add(query_598980, "oauth_token", newJString(oauthToken))
  add(path_598979, "reviewId", newJString(reviewId))
  add(query_598980, "userIp", newJString(userIp))
  add(query_598980, "key", newJString(key))
  if body != nil:
    body_598981 = body
  add(query_598980, "prettyPrint", newJBool(prettyPrint))
  result = call_598978.call(path_598979, query_598980, nil, nil, body_598981)

var androidpublisherReviewsReply* = Call_AndroidpublisherReviewsReply_598964(
    name: "androidpublisherReviewsReply", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/reviews/{reviewId}:reply",
    validator: validate_AndroidpublisherReviewsReply_598965,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherReviewsReply_598966, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
