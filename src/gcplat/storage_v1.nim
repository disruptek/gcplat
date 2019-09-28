
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Storage
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Stores and retrieves potentially large, immutable data objects.
## 
## https://developers.google.com/storage/docs/json_api/
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

  OpenApiRestCall_579424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579424): Option[Scheme] {.used.} =
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
  gcpServiceName = "storage"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StorageBucketsInsert_579968 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsInsert_579970(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StorageBucketsInsert_579969(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this bucket.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   project: JString (required)
  ##          : A valid API project identifier.
  ##   predefinedDefaultObjectAcl: JString
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_579971 = query.getOrDefault("fields")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "fields", valid_579971
  var valid_579972 = query.getOrDefault("quotaUser")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "quotaUser", valid_579972
  var valid_579973 = query.getOrDefault("alt")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = newJString("json"))
  if valid_579973 != nil:
    section.add "alt", valid_579973
  var valid_579974 = query.getOrDefault("oauth_token")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "oauth_token", valid_579974
  var valid_579975 = query.getOrDefault("userIp")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "userIp", valid_579975
  var valid_579976 = query.getOrDefault("predefinedAcl")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_579976 != nil:
    section.add "predefinedAcl", valid_579976
  var valid_579977 = query.getOrDefault("userProject")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "userProject", valid_579977
  var valid_579978 = query.getOrDefault("key")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "key", valid_579978
  var valid_579979 = query.getOrDefault("projection")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = newJString("full"))
  if valid_579979 != nil:
    section.add "projection", valid_579979
  var valid_579980 = query.getOrDefault("prettyPrint")
  valid_579980 = validateParameter(valid_579980, JBool, required = false,
                                 default = newJBool(true))
  if valid_579980 != nil:
    section.add "prettyPrint", valid_579980
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_579981 = query.getOrDefault("project")
  valid_579981 = validateParameter(valid_579981, JString, required = true,
                                 default = nil)
  if valid_579981 != nil:
    section.add "project", valid_579981
  var valid_579982 = query.getOrDefault("predefinedDefaultObjectAcl")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_579982 != nil:
    section.add "predefinedDefaultObjectAcl", valid_579982
  var valid_579983 = query.getOrDefault("provisionalUserProject")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "provisionalUserProject", valid_579983
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

proc call*(call_579985: Call_StorageBucketsInsert_579968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new bucket.
  ## 
  let valid = call_579985.validator(path, query, header, formData, body)
  let scheme = call_579985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579985.url(scheme.get, call_579985.host, call_579985.base,
                         call_579985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579985, url, valid)

proc call*(call_579986: Call_StorageBucketsInsert_579968; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = "";
          predefinedAcl: string = "authenticatedRead"; userProject: string = "";
          key: string = ""; projection: string = "full"; body: JsonNode = nil;
          prettyPrint: bool = true;
          predefinedDefaultObjectAcl: string = "authenticatedRead";
          provisionalUserProject: string = ""): Recallable =
  ## storageBucketsInsert
  ## Creates a new bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this bucket.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   project: string (required)
  ##          : A valid API project identifier.
  ##   predefinedDefaultObjectAcl: string
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var query_579987 = newJObject()
  var body_579988 = newJObject()
  add(query_579987, "fields", newJString(fields))
  add(query_579987, "quotaUser", newJString(quotaUser))
  add(query_579987, "alt", newJString(alt))
  add(query_579987, "oauth_token", newJString(oauthToken))
  add(query_579987, "userIp", newJString(userIp))
  add(query_579987, "predefinedAcl", newJString(predefinedAcl))
  add(query_579987, "userProject", newJString(userProject))
  add(query_579987, "key", newJString(key))
  add(query_579987, "projection", newJString(projection))
  if body != nil:
    body_579988 = body
  add(query_579987, "prettyPrint", newJBool(prettyPrint))
  add(query_579987, "project", newJString(project))
  add(query_579987, "predefinedDefaultObjectAcl",
      newJString(predefinedDefaultObjectAcl))
  add(query_579987, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_579986.call(nil, query_579987, nil, nil, body_579988)

var storageBucketsInsert* = Call_StorageBucketsInsert_579968(
    name: "storageBucketsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b",
    validator: validate_StorageBucketsInsert_579969, base: "/storage/v1",
    url: url_StorageBucketsInsert_579970, schemes: {Scheme.Https})
type
  Call_StorageBucketsList_579692 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsList_579694(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StorageBucketsList_579693(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a list of buckets for a given project.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of buckets to return in a single response. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   project: JString (required)
  ##          : A valid API project identifier.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: JString
  ##         : Filter results to buckets whose names begin with this prefix.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_579806 = query.getOrDefault("fields")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "fields", valid_579806
  var valid_579807 = query.getOrDefault("pageToken")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "pageToken", valid_579807
  var valid_579808 = query.getOrDefault("quotaUser")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "quotaUser", valid_579808
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("json"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("oauth_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "oauth_token", valid_579823
  var valid_579824 = query.getOrDefault("userIp")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "userIp", valid_579824
  var valid_579826 = query.getOrDefault("maxResults")
  valid_579826 = validateParameter(valid_579826, JInt, required = false,
                                 default = newJInt(1000))
  if valid_579826 != nil:
    section.add "maxResults", valid_579826
  var valid_579827 = query.getOrDefault("userProject")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "userProject", valid_579827
  var valid_579828 = query.getOrDefault("key")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "key", valid_579828
  var valid_579829 = query.getOrDefault("projection")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = newJString("full"))
  if valid_579829 != nil:
    section.add "projection", valid_579829
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_579830 = query.getOrDefault("project")
  valid_579830 = validateParameter(valid_579830, JString, required = true,
                                 default = nil)
  if valid_579830 != nil:
    section.add "project", valid_579830
  var valid_579831 = query.getOrDefault("prettyPrint")
  valid_579831 = validateParameter(valid_579831, JBool, required = false,
                                 default = newJBool(true))
  if valid_579831 != nil:
    section.add "prettyPrint", valid_579831
  var valid_579832 = query.getOrDefault("prefix")
  valid_579832 = validateParameter(valid_579832, JString, required = false,
                                 default = nil)
  if valid_579832 != nil:
    section.add "prefix", valid_579832
  var valid_579833 = query.getOrDefault("provisionalUserProject")
  valid_579833 = validateParameter(valid_579833, JString, required = false,
                                 default = nil)
  if valid_579833 != nil:
    section.add "provisionalUserProject", valid_579833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579856: Call_StorageBucketsList_579692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of buckets for a given project.
  ## 
  let valid = call_579856.validator(path, query, header, formData, body)
  let scheme = call_579856.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579856.url(scheme.get, call_579856.host, call_579856.base,
                         call_579856.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579856, url, valid)

proc call*(call_579927: Call_StorageBucketsList_579692; project: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 1000; userProject: string = ""; key: string = "";
          projection: string = "full"; prettyPrint: bool = true; prefix: string = "";
          provisionalUserProject: string = ""): Recallable =
  ## storageBucketsList
  ## Retrieves a list of buckets for a given project.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of buckets to return in a single response. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   project: string (required)
  ##          : A valid API project identifier.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: string
  ##         : Filter results to buckets whose names begin with this prefix.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var query_579928 = newJObject()
  add(query_579928, "fields", newJString(fields))
  add(query_579928, "pageToken", newJString(pageToken))
  add(query_579928, "quotaUser", newJString(quotaUser))
  add(query_579928, "alt", newJString(alt))
  add(query_579928, "oauth_token", newJString(oauthToken))
  add(query_579928, "userIp", newJString(userIp))
  add(query_579928, "maxResults", newJInt(maxResults))
  add(query_579928, "userProject", newJString(userProject))
  add(query_579928, "key", newJString(key))
  add(query_579928, "projection", newJString(projection))
  add(query_579928, "project", newJString(project))
  add(query_579928, "prettyPrint", newJBool(prettyPrint))
  add(query_579928, "prefix", newJString(prefix))
  add(query_579928, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_579927.call(nil, query_579928, nil, nil, nil)

var storageBucketsList* = Call_StorageBucketsList_579692(
    name: "storageBucketsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b", validator: validate_StorageBucketsList_579693,
    base: "/storage/v1", url: url_StorageBucketsList_579694, schemes: {Scheme.Https})
type
  Call_StorageBucketsUpdate_580023 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsUpdate_580025(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsUpdate_580024(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580026 = path.getOrDefault("bucket")
  valid_580026 = validateParameter(valid_580026, JString, required = true,
                                 default = nil)
  if valid_580026 != nil:
    section.add "bucket", valid_580026
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
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this bucket.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   predefinedDefaultObjectAcl: JString
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580027 = query.getOrDefault("fields")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "fields", valid_580027
  var valid_580028 = query.getOrDefault("quotaUser")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "quotaUser", valid_580028
  var valid_580029 = query.getOrDefault("alt")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = newJString("json"))
  if valid_580029 != nil:
    section.add "alt", valid_580029
  var valid_580030 = query.getOrDefault("oauth_token")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "oauth_token", valid_580030
  var valid_580031 = query.getOrDefault("userIp")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "userIp", valid_580031
  var valid_580032 = query.getOrDefault("predefinedAcl")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580032 != nil:
    section.add "predefinedAcl", valid_580032
  var valid_580033 = query.getOrDefault("userProject")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "userProject", valid_580033
  var valid_580034 = query.getOrDefault("key")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "key", valid_580034
  var valid_580035 = query.getOrDefault("projection")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("full"))
  if valid_580035 != nil:
    section.add "projection", valid_580035
  var valid_580036 = query.getOrDefault("ifMetagenerationMatch")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "ifMetagenerationMatch", valid_580036
  var valid_580037 = query.getOrDefault("prettyPrint")
  valid_580037 = validateParameter(valid_580037, JBool, required = false,
                                 default = newJBool(true))
  if valid_580037 != nil:
    section.add "prettyPrint", valid_580037
  var valid_580038 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "ifMetagenerationNotMatch", valid_580038
  var valid_580039 = query.getOrDefault("predefinedDefaultObjectAcl")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580039 != nil:
    section.add "predefinedDefaultObjectAcl", valid_580039
  var valid_580040 = query.getOrDefault("provisionalUserProject")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "provisionalUserProject", valid_580040
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

proc call*(call_580042: Call_StorageBucketsUpdate_580023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  let valid = call_580042.validator(path, query, header, formData, body)
  let scheme = call_580042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580042.url(scheme.get, call_580042.host, call_580042.base,
                         call_580042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580042, url, valid)

proc call*(call_580043: Call_StorageBucketsUpdate_580023; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = "";
          predefinedAcl: string = "authenticatedRead"; userProject: string = "";
          key: string = ""; projection: string = "full";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; ifMetagenerationNotMatch: string = "";
          predefinedDefaultObjectAcl: string = "authenticatedRead";
          provisionalUserProject: string = ""): Recallable =
  ## storageBucketsUpdate
  ## Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this bucket.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   predefinedDefaultObjectAcl: string
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580044 = newJObject()
  var query_580045 = newJObject()
  var body_580046 = newJObject()
  add(path_580044, "bucket", newJString(bucket))
  add(query_580045, "fields", newJString(fields))
  add(query_580045, "quotaUser", newJString(quotaUser))
  add(query_580045, "alt", newJString(alt))
  add(query_580045, "oauth_token", newJString(oauthToken))
  add(query_580045, "userIp", newJString(userIp))
  add(query_580045, "predefinedAcl", newJString(predefinedAcl))
  add(query_580045, "userProject", newJString(userProject))
  add(query_580045, "key", newJString(key))
  add(query_580045, "projection", newJString(projection))
  add(query_580045, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_580046 = body
  add(query_580045, "prettyPrint", newJBool(prettyPrint))
  add(query_580045, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580045, "predefinedDefaultObjectAcl",
      newJString(predefinedDefaultObjectAcl))
  add(query_580045, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580043.call(path_580044, query_580045, nil, nil, body_580046)

var storageBucketsUpdate* = Call_StorageBucketsUpdate_580023(
    name: "storageBucketsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsUpdate_580024, base: "/storage/v1",
    url: url_StorageBucketsUpdate_580025, schemes: {Scheme.Https})
type
  Call_StorageBucketsGet_579989 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsGet_579991(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsGet_579990(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns metadata for the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580006 = path.getOrDefault("bucket")
  valid_580006 = validateParameter(valid_580006, JString, required = true,
                                 default = nil)
  if valid_580006 != nil:
    section.add "bucket", valid_580006
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580007 = query.getOrDefault("fields")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "fields", valid_580007
  var valid_580008 = query.getOrDefault("quotaUser")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "quotaUser", valid_580008
  var valid_580009 = query.getOrDefault("alt")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = newJString("json"))
  if valid_580009 != nil:
    section.add "alt", valid_580009
  var valid_580010 = query.getOrDefault("oauth_token")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "oauth_token", valid_580010
  var valid_580011 = query.getOrDefault("userIp")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "userIp", valid_580011
  var valid_580012 = query.getOrDefault("userProject")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "userProject", valid_580012
  var valid_580013 = query.getOrDefault("key")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "key", valid_580013
  var valid_580014 = query.getOrDefault("projection")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("full"))
  if valid_580014 != nil:
    section.add "projection", valid_580014
  var valid_580015 = query.getOrDefault("ifMetagenerationMatch")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "ifMetagenerationMatch", valid_580015
  var valid_580016 = query.getOrDefault("prettyPrint")
  valid_580016 = validateParameter(valid_580016, JBool, required = false,
                                 default = newJBool(true))
  if valid_580016 != nil:
    section.add "prettyPrint", valid_580016
  var valid_580017 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "ifMetagenerationNotMatch", valid_580017
  var valid_580018 = query.getOrDefault("provisionalUserProject")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "provisionalUserProject", valid_580018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580019: Call_StorageBucketsGet_579989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata for the specified bucket.
  ## 
  let valid = call_580019.validator(path, query, header, formData, body)
  let scheme = call_580019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580019.url(scheme.get, call_580019.host, call_580019.base,
                         call_580019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580019, url, valid)

proc call*(call_580020: Call_StorageBucketsGet_579989; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; userProject: string = "";
          key: string = ""; projection: string = "full";
          ifMetagenerationMatch: string = ""; prettyPrint: bool = true;
          ifMetagenerationNotMatch: string = ""; provisionalUserProject: string = ""): Recallable =
  ## storageBucketsGet
  ## Returns metadata for the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580021 = newJObject()
  var query_580022 = newJObject()
  add(path_580021, "bucket", newJString(bucket))
  add(query_580022, "fields", newJString(fields))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(query_580022, "alt", newJString(alt))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "userIp", newJString(userIp))
  add(query_580022, "userProject", newJString(userProject))
  add(query_580022, "key", newJString(key))
  add(query_580022, "projection", newJString(projection))
  add(query_580022, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  add(query_580022, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580022, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580020.call(path_580021, query_580022, nil, nil, nil)

var storageBucketsGet* = Call_StorageBucketsGet_579989(name: "storageBucketsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsGet_579990, base: "/storage/v1",
    url: url_StorageBucketsGet_579991, schemes: {Scheme.Https})
type
  Call_StorageBucketsPatch_580066 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsPatch_580068(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsPatch_580067(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Patches a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580069 = path.getOrDefault("bucket")
  valid_580069 = validateParameter(valid_580069, JString, required = true,
                                 default = nil)
  if valid_580069 != nil:
    section.add "bucket", valid_580069
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
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this bucket.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   predefinedDefaultObjectAcl: JString
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580070 = query.getOrDefault("fields")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "fields", valid_580070
  var valid_580071 = query.getOrDefault("quotaUser")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "quotaUser", valid_580071
  var valid_580072 = query.getOrDefault("alt")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = newJString("json"))
  if valid_580072 != nil:
    section.add "alt", valid_580072
  var valid_580073 = query.getOrDefault("oauth_token")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "oauth_token", valid_580073
  var valid_580074 = query.getOrDefault("userIp")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "userIp", valid_580074
  var valid_580075 = query.getOrDefault("predefinedAcl")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580075 != nil:
    section.add "predefinedAcl", valid_580075
  var valid_580076 = query.getOrDefault("userProject")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "userProject", valid_580076
  var valid_580077 = query.getOrDefault("key")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "key", valid_580077
  var valid_580078 = query.getOrDefault("projection")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = newJString("full"))
  if valid_580078 != nil:
    section.add "projection", valid_580078
  var valid_580079 = query.getOrDefault("ifMetagenerationMatch")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "ifMetagenerationMatch", valid_580079
  var valid_580080 = query.getOrDefault("prettyPrint")
  valid_580080 = validateParameter(valid_580080, JBool, required = false,
                                 default = newJBool(true))
  if valid_580080 != nil:
    section.add "prettyPrint", valid_580080
  var valid_580081 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "ifMetagenerationNotMatch", valid_580081
  var valid_580082 = query.getOrDefault("predefinedDefaultObjectAcl")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580082 != nil:
    section.add "predefinedDefaultObjectAcl", valid_580082
  var valid_580083 = query.getOrDefault("provisionalUserProject")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "provisionalUserProject", valid_580083
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

proc call*(call_580085: Call_StorageBucketsPatch_580066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  let valid = call_580085.validator(path, query, header, formData, body)
  let scheme = call_580085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580085.url(scheme.get, call_580085.host, call_580085.base,
                         call_580085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580085, url, valid)

proc call*(call_580086: Call_StorageBucketsPatch_580066; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = "";
          predefinedAcl: string = "authenticatedRead"; userProject: string = "";
          key: string = ""; projection: string = "full";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; ifMetagenerationNotMatch: string = "";
          predefinedDefaultObjectAcl: string = "authenticatedRead";
          provisionalUserProject: string = ""): Recallable =
  ## storageBucketsPatch
  ## Patches a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this bucket.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   predefinedDefaultObjectAcl: string
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580087 = newJObject()
  var query_580088 = newJObject()
  var body_580089 = newJObject()
  add(path_580087, "bucket", newJString(bucket))
  add(query_580088, "fields", newJString(fields))
  add(query_580088, "quotaUser", newJString(quotaUser))
  add(query_580088, "alt", newJString(alt))
  add(query_580088, "oauth_token", newJString(oauthToken))
  add(query_580088, "userIp", newJString(userIp))
  add(query_580088, "predefinedAcl", newJString(predefinedAcl))
  add(query_580088, "userProject", newJString(userProject))
  add(query_580088, "key", newJString(key))
  add(query_580088, "projection", newJString(projection))
  add(query_580088, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_580089 = body
  add(query_580088, "prettyPrint", newJBool(prettyPrint))
  add(query_580088, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580088, "predefinedDefaultObjectAcl",
      newJString(predefinedDefaultObjectAcl))
  add(query_580088, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580086.call(path_580087, query_580088, nil, nil, body_580089)

var storageBucketsPatch* = Call_StorageBucketsPatch_580066(
    name: "storageBucketsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsPatch_580067, base: "/storage/v1",
    url: url_StorageBucketsPatch_580068, schemes: {Scheme.Https})
type
  Call_StorageBucketsDelete_580047 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsDelete_580049(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsDelete_580048(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes an empty bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580050 = path.getOrDefault("bucket")
  valid_580050 = validateParameter(valid_580050, JString, required = true,
                                 default = nil)
  if valid_580050 != nil:
    section.add "bucket", valid_580050
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifMetagenerationMatch: JString
  ##                        : If set, only deletes the bucket if its metageneration matches this value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : If set, only deletes the bucket if its metageneration does not match this value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580051 = query.getOrDefault("fields")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "fields", valid_580051
  var valid_580052 = query.getOrDefault("quotaUser")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "quotaUser", valid_580052
  var valid_580053 = query.getOrDefault("alt")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = newJString("json"))
  if valid_580053 != nil:
    section.add "alt", valid_580053
  var valid_580054 = query.getOrDefault("oauth_token")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "oauth_token", valid_580054
  var valid_580055 = query.getOrDefault("userIp")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "userIp", valid_580055
  var valid_580056 = query.getOrDefault("userProject")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "userProject", valid_580056
  var valid_580057 = query.getOrDefault("key")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "key", valid_580057
  var valid_580058 = query.getOrDefault("ifMetagenerationMatch")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "ifMetagenerationMatch", valid_580058
  var valid_580059 = query.getOrDefault("prettyPrint")
  valid_580059 = validateParameter(valid_580059, JBool, required = false,
                                 default = newJBool(true))
  if valid_580059 != nil:
    section.add "prettyPrint", valid_580059
  var valid_580060 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "ifMetagenerationNotMatch", valid_580060
  var valid_580061 = query.getOrDefault("provisionalUserProject")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "provisionalUserProject", valid_580061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580062: Call_StorageBucketsDelete_580047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes an empty bucket.
  ## 
  let valid = call_580062.validator(path, query, header, formData, body)
  let scheme = call_580062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580062.url(scheme.get, call_580062.host, call_580062.base,
                         call_580062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580062, url, valid)

proc call*(call_580063: Call_StorageBucketsDelete_580047; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; userProject: string = "";
          key: string = ""; ifMetagenerationMatch: string = "";
          prettyPrint: bool = true; ifMetagenerationNotMatch: string = "";
          provisionalUserProject: string = ""): Recallable =
  ## storageBucketsDelete
  ## Permanently deletes an empty bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifMetagenerationMatch: string
  ##                        : If set, only deletes the bucket if its metageneration matches this value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : If set, only deletes the bucket if its metageneration does not match this value.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580064 = newJObject()
  var query_580065 = newJObject()
  add(path_580064, "bucket", newJString(bucket))
  add(query_580065, "fields", newJString(fields))
  add(query_580065, "quotaUser", newJString(quotaUser))
  add(query_580065, "alt", newJString(alt))
  add(query_580065, "oauth_token", newJString(oauthToken))
  add(query_580065, "userIp", newJString(userIp))
  add(query_580065, "userProject", newJString(userProject))
  add(query_580065, "key", newJString(key))
  add(query_580065, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580065, "prettyPrint", newJBool(prettyPrint))
  add(query_580065, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580065, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580063.call(path_580064, query_580065, nil, nil, nil)

var storageBucketsDelete* = Call_StorageBucketsDelete_580047(
    name: "storageBucketsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsDelete_580048, base: "/storage/v1",
    url: url_StorageBucketsDelete_580049, schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsInsert_580107 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsInsert_580109(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsInsert_580108(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580110 = path.getOrDefault("bucket")
  valid_580110 = validateParameter(valid_580110, JString, required = true,
                                 default = nil)
  if valid_580110 != nil:
    section.add "bucket", valid_580110
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580111 = query.getOrDefault("fields")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "fields", valid_580111
  var valid_580112 = query.getOrDefault("quotaUser")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "quotaUser", valid_580112
  var valid_580113 = query.getOrDefault("alt")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = newJString("json"))
  if valid_580113 != nil:
    section.add "alt", valid_580113
  var valid_580114 = query.getOrDefault("oauth_token")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "oauth_token", valid_580114
  var valid_580115 = query.getOrDefault("userIp")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "userIp", valid_580115
  var valid_580116 = query.getOrDefault("userProject")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "userProject", valid_580116
  var valid_580117 = query.getOrDefault("key")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "key", valid_580117
  var valid_580118 = query.getOrDefault("prettyPrint")
  valid_580118 = validateParameter(valid_580118, JBool, required = false,
                                 default = newJBool(true))
  if valid_580118 != nil:
    section.add "prettyPrint", valid_580118
  var valid_580119 = query.getOrDefault("provisionalUserProject")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "provisionalUserProject", valid_580119
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

proc call*(call_580121: Call_StorageBucketAccessControlsInsert_580107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified bucket.
  ## 
  let valid = call_580121.validator(path, query, header, formData, body)
  let scheme = call_580121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580121.url(scheme.get, call_580121.host, call_580121.base,
                         call_580121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580121, url, valid)

proc call*(call_580122: Call_StorageBucketAccessControlsInsert_580107;
          bucket: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageBucketAccessControlsInsert
  ## Creates a new ACL entry on the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580123 = newJObject()
  var query_580124 = newJObject()
  var body_580125 = newJObject()
  add(path_580123, "bucket", newJString(bucket))
  add(query_580124, "fields", newJString(fields))
  add(query_580124, "quotaUser", newJString(quotaUser))
  add(query_580124, "alt", newJString(alt))
  add(query_580124, "oauth_token", newJString(oauthToken))
  add(query_580124, "userIp", newJString(userIp))
  add(query_580124, "userProject", newJString(userProject))
  add(query_580124, "key", newJString(key))
  if body != nil:
    body_580125 = body
  add(query_580124, "prettyPrint", newJBool(prettyPrint))
  add(query_580124, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580122.call(path_580123, query_580124, nil, nil, body_580125)

var storageBucketAccessControlsInsert* = Call_StorageBucketAccessControlsInsert_580107(
    name: "storageBucketAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsInsert_580108,
    base: "/storage/v1", url: url_StorageBucketAccessControlsInsert_580109,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsList_580090 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsList_580092(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsList_580091(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves ACL entries on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580093 = path.getOrDefault("bucket")
  valid_580093 = validateParameter(valid_580093, JString, required = true,
                                 default = nil)
  if valid_580093 != nil:
    section.add "bucket", valid_580093
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580094 = query.getOrDefault("fields")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "fields", valid_580094
  var valid_580095 = query.getOrDefault("quotaUser")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "quotaUser", valid_580095
  var valid_580096 = query.getOrDefault("alt")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = newJString("json"))
  if valid_580096 != nil:
    section.add "alt", valid_580096
  var valid_580097 = query.getOrDefault("oauth_token")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "oauth_token", valid_580097
  var valid_580098 = query.getOrDefault("userIp")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "userIp", valid_580098
  var valid_580099 = query.getOrDefault("userProject")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "userProject", valid_580099
  var valid_580100 = query.getOrDefault("key")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "key", valid_580100
  var valid_580101 = query.getOrDefault("prettyPrint")
  valid_580101 = validateParameter(valid_580101, JBool, required = false,
                                 default = newJBool(true))
  if valid_580101 != nil:
    section.add "prettyPrint", valid_580101
  var valid_580102 = query.getOrDefault("provisionalUserProject")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "provisionalUserProject", valid_580102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580103: Call_StorageBucketAccessControlsList_580090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified bucket.
  ## 
  let valid = call_580103.validator(path, query, header, formData, body)
  let scheme = call_580103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580103.url(scheme.get, call_580103.host, call_580103.base,
                         call_580103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580103, url, valid)

proc call*(call_580104: Call_StorageBucketAccessControlsList_580090;
          bucket: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageBucketAccessControlsList
  ## Retrieves ACL entries on the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580105 = newJObject()
  var query_580106 = newJObject()
  add(path_580105, "bucket", newJString(bucket))
  add(query_580106, "fields", newJString(fields))
  add(query_580106, "quotaUser", newJString(quotaUser))
  add(query_580106, "alt", newJString(alt))
  add(query_580106, "oauth_token", newJString(oauthToken))
  add(query_580106, "userIp", newJString(userIp))
  add(query_580106, "userProject", newJString(userProject))
  add(query_580106, "key", newJString(key))
  add(query_580106, "prettyPrint", newJBool(prettyPrint))
  add(query_580106, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580104.call(path_580105, query_580106, nil, nil, nil)

var storageBucketAccessControlsList* = Call_StorageBucketAccessControlsList_580090(
    name: "storageBucketAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsList_580091,
    base: "/storage/v1", url: url_StorageBucketAccessControlsList_580092,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsUpdate_580144 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsUpdate_580146(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsUpdate_580145(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580147 = path.getOrDefault("bucket")
  valid_580147 = validateParameter(valid_580147, JString, required = true,
                                 default = nil)
  if valid_580147 != nil:
    section.add "bucket", valid_580147
  var valid_580148 = path.getOrDefault("entity")
  valid_580148 = validateParameter(valid_580148, JString, required = true,
                                 default = nil)
  if valid_580148 != nil:
    section.add "entity", valid_580148
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580149 = query.getOrDefault("fields")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "fields", valid_580149
  var valid_580150 = query.getOrDefault("quotaUser")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "quotaUser", valid_580150
  var valid_580151 = query.getOrDefault("alt")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = newJString("json"))
  if valid_580151 != nil:
    section.add "alt", valid_580151
  var valid_580152 = query.getOrDefault("oauth_token")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "oauth_token", valid_580152
  var valid_580153 = query.getOrDefault("userIp")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "userIp", valid_580153
  var valid_580154 = query.getOrDefault("userProject")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "userProject", valid_580154
  var valid_580155 = query.getOrDefault("key")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "key", valid_580155
  var valid_580156 = query.getOrDefault("prettyPrint")
  valid_580156 = validateParameter(valid_580156, JBool, required = false,
                                 default = newJBool(true))
  if valid_580156 != nil:
    section.add "prettyPrint", valid_580156
  var valid_580157 = query.getOrDefault("provisionalUserProject")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "provisionalUserProject", valid_580157
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

proc call*(call_580159: Call_StorageBucketAccessControlsUpdate_580144;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket.
  ## 
  let valid = call_580159.validator(path, query, header, formData, body)
  let scheme = call_580159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580159.url(scheme.get, call_580159.host, call_580159.base,
                         call_580159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580159, url, valid)

proc call*(call_580160: Call_StorageBucketAccessControlsUpdate_580144;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageBucketAccessControlsUpdate
  ## Updates an ACL entry on the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580161 = newJObject()
  var query_580162 = newJObject()
  var body_580163 = newJObject()
  add(path_580161, "bucket", newJString(bucket))
  add(query_580162, "fields", newJString(fields))
  add(query_580162, "quotaUser", newJString(quotaUser))
  add(query_580162, "alt", newJString(alt))
  add(query_580162, "oauth_token", newJString(oauthToken))
  add(query_580162, "userIp", newJString(userIp))
  add(query_580162, "userProject", newJString(userProject))
  add(query_580162, "key", newJString(key))
  if body != nil:
    body_580163 = body
  add(query_580162, "prettyPrint", newJBool(prettyPrint))
  add(path_580161, "entity", newJString(entity))
  add(query_580162, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580160.call(path_580161, query_580162, nil, nil, body_580163)

var storageBucketAccessControlsUpdate* = Call_StorageBucketAccessControlsUpdate_580144(
    name: "storageBucketAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsUpdate_580145,
    base: "/storage/v1", url: url_StorageBucketAccessControlsUpdate_580146,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsGet_580126 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsGet_580128(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsGet_580127(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580129 = path.getOrDefault("bucket")
  valid_580129 = validateParameter(valid_580129, JString, required = true,
                                 default = nil)
  if valid_580129 != nil:
    section.add "bucket", valid_580129
  var valid_580130 = path.getOrDefault("entity")
  valid_580130 = validateParameter(valid_580130, JString, required = true,
                                 default = nil)
  if valid_580130 != nil:
    section.add "entity", valid_580130
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580131 = query.getOrDefault("fields")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "fields", valid_580131
  var valid_580132 = query.getOrDefault("quotaUser")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "quotaUser", valid_580132
  var valid_580133 = query.getOrDefault("alt")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = newJString("json"))
  if valid_580133 != nil:
    section.add "alt", valid_580133
  var valid_580134 = query.getOrDefault("oauth_token")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "oauth_token", valid_580134
  var valid_580135 = query.getOrDefault("userIp")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "userIp", valid_580135
  var valid_580136 = query.getOrDefault("userProject")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "userProject", valid_580136
  var valid_580137 = query.getOrDefault("key")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "key", valid_580137
  var valid_580138 = query.getOrDefault("prettyPrint")
  valid_580138 = validateParameter(valid_580138, JBool, required = false,
                                 default = newJBool(true))
  if valid_580138 != nil:
    section.add "prettyPrint", valid_580138
  var valid_580139 = query.getOrDefault("provisionalUserProject")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "provisionalUserProject", valid_580139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580140: Call_StorageBucketAccessControlsGet_580126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580140.validator(path, query, header, formData, body)
  let scheme = call_580140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580140.url(scheme.get, call_580140.host, call_580140.base,
                         call_580140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580140, url, valid)

proc call*(call_580141: Call_StorageBucketAccessControlsGet_580126; bucket: string;
          entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageBucketAccessControlsGet
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580142 = newJObject()
  var query_580143 = newJObject()
  add(path_580142, "bucket", newJString(bucket))
  add(query_580143, "fields", newJString(fields))
  add(query_580143, "quotaUser", newJString(quotaUser))
  add(query_580143, "alt", newJString(alt))
  add(query_580143, "oauth_token", newJString(oauthToken))
  add(query_580143, "userIp", newJString(userIp))
  add(query_580143, "userProject", newJString(userProject))
  add(query_580143, "key", newJString(key))
  add(query_580143, "prettyPrint", newJBool(prettyPrint))
  add(path_580142, "entity", newJString(entity))
  add(query_580143, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580141.call(path_580142, query_580143, nil, nil, nil)

var storageBucketAccessControlsGet* = Call_StorageBucketAccessControlsGet_580126(
    name: "storageBucketAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsGet_580127,
    base: "/storage/v1", url: url_StorageBucketAccessControlsGet_580128,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsPatch_580182 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsPatch_580184(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsPatch_580183(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches an ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580185 = path.getOrDefault("bucket")
  valid_580185 = validateParameter(valid_580185, JString, required = true,
                                 default = nil)
  if valid_580185 != nil:
    section.add "bucket", valid_580185
  var valid_580186 = path.getOrDefault("entity")
  valid_580186 = validateParameter(valid_580186, JString, required = true,
                                 default = nil)
  if valid_580186 != nil:
    section.add "entity", valid_580186
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580187 = query.getOrDefault("fields")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "fields", valid_580187
  var valid_580188 = query.getOrDefault("quotaUser")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "quotaUser", valid_580188
  var valid_580189 = query.getOrDefault("alt")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = newJString("json"))
  if valid_580189 != nil:
    section.add "alt", valid_580189
  var valid_580190 = query.getOrDefault("oauth_token")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "oauth_token", valid_580190
  var valid_580191 = query.getOrDefault("userIp")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "userIp", valid_580191
  var valid_580192 = query.getOrDefault("userProject")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "userProject", valid_580192
  var valid_580193 = query.getOrDefault("key")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "key", valid_580193
  var valid_580194 = query.getOrDefault("prettyPrint")
  valid_580194 = validateParameter(valid_580194, JBool, required = false,
                                 default = newJBool(true))
  if valid_580194 != nil:
    section.add "prettyPrint", valid_580194
  var valid_580195 = query.getOrDefault("provisionalUserProject")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "provisionalUserProject", valid_580195
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

proc call*(call_580197: Call_StorageBucketAccessControlsPatch_580182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patches an ACL entry on the specified bucket.
  ## 
  let valid = call_580197.validator(path, query, header, formData, body)
  let scheme = call_580197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580197.url(scheme.get, call_580197.host, call_580197.base,
                         call_580197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580197, url, valid)

proc call*(call_580198: Call_StorageBucketAccessControlsPatch_580182;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageBucketAccessControlsPatch
  ## Patches an ACL entry on the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580199 = newJObject()
  var query_580200 = newJObject()
  var body_580201 = newJObject()
  add(path_580199, "bucket", newJString(bucket))
  add(query_580200, "fields", newJString(fields))
  add(query_580200, "quotaUser", newJString(quotaUser))
  add(query_580200, "alt", newJString(alt))
  add(query_580200, "oauth_token", newJString(oauthToken))
  add(query_580200, "userIp", newJString(userIp))
  add(query_580200, "userProject", newJString(userProject))
  add(query_580200, "key", newJString(key))
  if body != nil:
    body_580201 = body
  add(query_580200, "prettyPrint", newJBool(prettyPrint))
  add(path_580199, "entity", newJString(entity))
  add(query_580200, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580198.call(path_580199, query_580200, nil, nil, body_580201)

var storageBucketAccessControlsPatch* = Call_StorageBucketAccessControlsPatch_580182(
    name: "storageBucketAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsPatch_580183,
    base: "/storage/v1", url: url_StorageBucketAccessControlsPatch_580184,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsDelete_580164 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsDelete_580166(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsDelete_580165(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580167 = path.getOrDefault("bucket")
  valid_580167 = validateParameter(valid_580167, JString, required = true,
                                 default = nil)
  if valid_580167 != nil:
    section.add "bucket", valid_580167
  var valid_580168 = path.getOrDefault("entity")
  valid_580168 = validateParameter(valid_580168, JString, required = true,
                                 default = nil)
  if valid_580168 != nil:
    section.add "entity", valid_580168
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580169 = query.getOrDefault("fields")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "fields", valid_580169
  var valid_580170 = query.getOrDefault("quotaUser")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "quotaUser", valid_580170
  var valid_580171 = query.getOrDefault("alt")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = newJString("json"))
  if valid_580171 != nil:
    section.add "alt", valid_580171
  var valid_580172 = query.getOrDefault("oauth_token")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "oauth_token", valid_580172
  var valid_580173 = query.getOrDefault("userIp")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "userIp", valid_580173
  var valid_580174 = query.getOrDefault("userProject")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "userProject", valid_580174
  var valid_580175 = query.getOrDefault("key")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "key", valid_580175
  var valid_580176 = query.getOrDefault("prettyPrint")
  valid_580176 = validateParameter(valid_580176, JBool, required = false,
                                 default = newJBool(true))
  if valid_580176 != nil:
    section.add "prettyPrint", valid_580176
  var valid_580177 = query.getOrDefault("provisionalUserProject")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "provisionalUserProject", valid_580177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580178: Call_StorageBucketAccessControlsDelete_580164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580178.validator(path, query, header, formData, body)
  let scheme = call_580178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580178.url(scheme.get, call_580178.host, call_580178.base,
                         call_580178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580178, url, valid)

proc call*(call_580179: Call_StorageBucketAccessControlsDelete_580164;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageBucketAccessControlsDelete
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580180 = newJObject()
  var query_580181 = newJObject()
  add(path_580180, "bucket", newJString(bucket))
  add(query_580181, "fields", newJString(fields))
  add(query_580181, "quotaUser", newJString(quotaUser))
  add(query_580181, "alt", newJString(alt))
  add(query_580181, "oauth_token", newJString(oauthToken))
  add(query_580181, "userIp", newJString(userIp))
  add(query_580181, "userProject", newJString(userProject))
  add(query_580181, "key", newJString(key))
  add(query_580181, "prettyPrint", newJBool(prettyPrint))
  add(path_580180, "entity", newJString(entity))
  add(query_580181, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580179.call(path_580180, query_580181, nil, nil, nil)

var storageBucketAccessControlsDelete* = Call_StorageBucketAccessControlsDelete_580164(
    name: "storageBucketAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsDelete_580165,
    base: "/storage/v1", url: url_StorageBucketAccessControlsDelete_580166,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsInsert_580221 = ref object of OpenApiRestCall_579424
proc url_StorageDefaultObjectAccessControlsInsert_580223(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsInsert_580222(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new default object ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580224 = path.getOrDefault("bucket")
  valid_580224 = validateParameter(valid_580224, JString, required = true,
                                 default = nil)
  if valid_580224 != nil:
    section.add "bucket", valid_580224
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580225 = query.getOrDefault("fields")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "fields", valid_580225
  var valid_580226 = query.getOrDefault("quotaUser")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "quotaUser", valid_580226
  var valid_580227 = query.getOrDefault("alt")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = newJString("json"))
  if valid_580227 != nil:
    section.add "alt", valid_580227
  var valid_580228 = query.getOrDefault("oauth_token")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "oauth_token", valid_580228
  var valid_580229 = query.getOrDefault("userIp")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "userIp", valid_580229
  var valid_580230 = query.getOrDefault("userProject")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "userProject", valid_580230
  var valid_580231 = query.getOrDefault("key")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "key", valid_580231
  var valid_580232 = query.getOrDefault("prettyPrint")
  valid_580232 = validateParameter(valid_580232, JBool, required = false,
                                 default = newJBool(true))
  if valid_580232 != nil:
    section.add "prettyPrint", valid_580232
  var valid_580233 = query.getOrDefault("provisionalUserProject")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "provisionalUserProject", valid_580233
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

proc call*(call_580235: Call_StorageDefaultObjectAccessControlsInsert_580221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new default object ACL entry on the specified bucket.
  ## 
  let valid = call_580235.validator(path, query, header, formData, body)
  let scheme = call_580235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580235.url(scheme.get, call_580235.host, call_580235.base,
                         call_580235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580235, url, valid)

proc call*(call_580236: Call_StorageDefaultObjectAccessControlsInsert_580221;
          bucket: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsInsert
  ## Creates a new default object ACL entry on the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580237 = newJObject()
  var query_580238 = newJObject()
  var body_580239 = newJObject()
  add(path_580237, "bucket", newJString(bucket))
  add(query_580238, "fields", newJString(fields))
  add(query_580238, "quotaUser", newJString(quotaUser))
  add(query_580238, "alt", newJString(alt))
  add(query_580238, "oauth_token", newJString(oauthToken))
  add(query_580238, "userIp", newJString(userIp))
  add(query_580238, "userProject", newJString(userProject))
  add(query_580238, "key", newJString(key))
  if body != nil:
    body_580239 = body
  add(query_580238, "prettyPrint", newJBool(prettyPrint))
  add(query_580238, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580236.call(path_580237, query_580238, nil, nil, body_580239)

var storageDefaultObjectAccessControlsInsert* = Call_StorageDefaultObjectAccessControlsInsert_580221(
    name: "storageDefaultObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsInsert_580222,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsInsert_580223,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsList_580202 = ref object of OpenApiRestCall_579424
proc url_StorageDefaultObjectAccessControlsList_580204(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsList_580203(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves default object ACL entries on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580205 = path.getOrDefault("bucket")
  valid_580205 = validateParameter(valid_580205, JString, required = true,
                                 default = nil)
  if valid_580205 != nil:
    section.add "bucket", valid_580205
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifMetagenerationMatch: JString
  ##                        : If present, only return default ACL listing if the bucket's current metageneration matches this value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : If present, only return default ACL listing if the bucket's current metageneration does not match the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580206 = query.getOrDefault("fields")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "fields", valid_580206
  var valid_580207 = query.getOrDefault("quotaUser")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "quotaUser", valid_580207
  var valid_580208 = query.getOrDefault("alt")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = newJString("json"))
  if valid_580208 != nil:
    section.add "alt", valid_580208
  var valid_580209 = query.getOrDefault("oauth_token")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "oauth_token", valid_580209
  var valid_580210 = query.getOrDefault("userIp")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "userIp", valid_580210
  var valid_580211 = query.getOrDefault("userProject")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "userProject", valid_580211
  var valid_580212 = query.getOrDefault("key")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "key", valid_580212
  var valid_580213 = query.getOrDefault("ifMetagenerationMatch")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "ifMetagenerationMatch", valid_580213
  var valid_580214 = query.getOrDefault("prettyPrint")
  valid_580214 = validateParameter(valid_580214, JBool, required = false,
                                 default = newJBool(true))
  if valid_580214 != nil:
    section.add "prettyPrint", valid_580214
  var valid_580215 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "ifMetagenerationNotMatch", valid_580215
  var valid_580216 = query.getOrDefault("provisionalUserProject")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "provisionalUserProject", valid_580216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580217: Call_StorageDefaultObjectAccessControlsList_580202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves default object ACL entries on the specified bucket.
  ## 
  let valid = call_580217.validator(path, query, header, formData, body)
  let scheme = call_580217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580217.url(scheme.get, call_580217.host, call_580217.base,
                         call_580217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580217, url, valid)

proc call*(call_580218: Call_StorageDefaultObjectAccessControlsList_580202;
          bucket: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = "";
          ifMetagenerationMatch: string = ""; prettyPrint: bool = true;
          ifMetagenerationNotMatch: string = ""; provisionalUserProject: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsList
  ## Retrieves default object ACL entries on the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifMetagenerationMatch: string
  ##                        : If present, only return default ACL listing if the bucket's current metageneration matches this value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : If present, only return default ACL listing if the bucket's current metageneration does not match the given value.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580219 = newJObject()
  var query_580220 = newJObject()
  add(path_580219, "bucket", newJString(bucket))
  add(query_580220, "fields", newJString(fields))
  add(query_580220, "quotaUser", newJString(quotaUser))
  add(query_580220, "alt", newJString(alt))
  add(query_580220, "oauth_token", newJString(oauthToken))
  add(query_580220, "userIp", newJString(userIp))
  add(query_580220, "userProject", newJString(userProject))
  add(query_580220, "key", newJString(key))
  add(query_580220, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580220, "prettyPrint", newJBool(prettyPrint))
  add(query_580220, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580220, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580218.call(path_580219, query_580220, nil, nil, nil)

var storageDefaultObjectAccessControlsList* = Call_StorageDefaultObjectAccessControlsList_580202(
    name: "storageDefaultObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsList_580203,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsList_580204,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsUpdate_580258 = ref object of OpenApiRestCall_579424
proc url_StorageDefaultObjectAccessControlsUpdate_580260(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsUpdate_580259(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a default object ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580261 = path.getOrDefault("bucket")
  valid_580261 = validateParameter(valid_580261, JString, required = true,
                                 default = nil)
  if valid_580261 != nil:
    section.add "bucket", valid_580261
  var valid_580262 = path.getOrDefault("entity")
  valid_580262 = validateParameter(valid_580262, JString, required = true,
                                 default = nil)
  if valid_580262 != nil:
    section.add "entity", valid_580262
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580263 = query.getOrDefault("fields")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "fields", valid_580263
  var valid_580264 = query.getOrDefault("quotaUser")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "quotaUser", valid_580264
  var valid_580265 = query.getOrDefault("alt")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = newJString("json"))
  if valid_580265 != nil:
    section.add "alt", valid_580265
  var valid_580266 = query.getOrDefault("oauth_token")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "oauth_token", valid_580266
  var valid_580267 = query.getOrDefault("userIp")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "userIp", valid_580267
  var valid_580268 = query.getOrDefault("userProject")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "userProject", valid_580268
  var valid_580269 = query.getOrDefault("key")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "key", valid_580269
  var valid_580270 = query.getOrDefault("prettyPrint")
  valid_580270 = validateParameter(valid_580270, JBool, required = false,
                                 default = newJBool(true))
  if valid_580270 != nil:
    section.add "prettyPrint", valid_580270
  var valid_580271 = query.getOrDefault("provisionalUserProject")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "provisionalUserProject", valid_580271
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

proc call*(call_580273: Call_StorageDefaultObjectAccessControlsUpdate_580258;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a default object ACL entry on the specified bucket.
  ## 
  let valid = call_580273.validator(path, query, header, formData, body)
  let scheme = call_580273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580273.url(scheme.get, call_580273.host, call_580273.base,
                         call_580273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580273, url, valid)

proc call*(call_580274: Call_StorageDefaultObjectAccessControlsUpdate_580258;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsUpdate
  ## Updates a default object ACL entry on the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580275 = newJObject()
  var query_580276 = newJObject()
  var body_580277 = newJObject()
  add(path_580275, "bucket", newJString(bucket))
  add(query_580276, "fields", newJString(fields))
  add(query_580276, "quotaUser", newJString(quotaUser))
  add(query_580276, "alt", newJString(alt))
  add(query_580276, "oauth_token", newJString(oauthToken))
  add(query_580276, "userIp", newJString(userIp))
  add(query_580276, "userProject", newJString(userProject))
  add(query_580276, "key", newJString(key))
  if body != nil:
    body_580277 = body
  add(query_580276, "prettyPrint", newJBool(prettyPrint))
  add(path_580275, "entity", newJString(entity))
  add(query_580276, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580274.call(path_580275, query_580276, nil, nil, body_580277)

var storageDefaultObjectAccessControlsUpdate* = Call_StorageDefaultObjectAccessControlsUpdate_580258(
    name: "storageDefaultObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsUpdate_580259,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsUpdate_580260,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsGet_580240 = ref object of OpenApiRestCall_579424
proc url_StorageDefaultObjectAccessControlsGet_580242(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsGet_580241(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580243 = path.getOrDefault("bucket")
  valid_580243 = validateParameter(valid_580243, JString, required = true,
                                 default = nil)
  if valid_580243 != nil:
    section.add "bucket", valid_580243
  var valid_580244 = path.getOrDefault("entity")
  valid_580244 = validateParameter(valid_580244, JString, required = true,
                                 default = nil)
  if valid_580244 != nil:
    section.add "entity", valid_580244
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580245 = query.getOrDefault("fields")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "fields", valid_580245
  var valid_580246 = query.getOrDefault("quotaUser")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "quotaUser", valid_580246
  var valid_580247 = query.getOrDefault("alt")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = newJString("json"))
  if valid_580247 != nil:
    section.add "alt", valid_580247
  var valid_580248 = query.getOrDefault("oauth_token")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "oauth_token", valid_580248
  var valid_580249 = query.getOrDefault("userIp")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "userIp", valid_580249
  var valid_580250 = query.getOrDefault("userProject")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "userProject", valid_580250
  var valid_580251 = query.getOrDefault("key")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "key", valid_580251
  var valid_580252 = query.getOrDefault("prettyPrint")
  valid_580252 = validateParameter(valid_580252, JBool, required = false,
                                 default = newJBool(true))
  if valid_580252 != nil:
    section.add "prettyPrint", valid_580252
  var valid_580253 = query.getOrDefault("provisionalUserProject")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "provisionalUserProject", valid_580253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580254: Call_StorageDefaultObjectAccessControlsGet_580240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580254.validator(path, query, header, formData, body)
  let scheme = call_580254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580254.url(scheme.get, call_580254.host, call_580254.base,
                         call_580254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580254, url, valid)

proc call*(call_580255: Call_StorageDefaultObjectAccessControlsGet_580240;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsGet
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580256 = newJObject()
  var query_580257 = newJObject()
  add(path_580256, "bucket", newJString(bucket))
  add(query_580257, "fields", newJString(fields))
  add(query_580257, "quotaUser", newJString(quotaUser))
  add(query_580257, "alt", newJString(alt))
  add(query_580257, "oauth_token", newJString(oauthToken))
  add(query_580257, "userIp", newJString(userIp))
  add(query_580257, "userProject", newJString(userProject))
  add(query_580257, "key", newJString(key))
  add(query_580257, "prettyPrint", newJBool(prettyPrint))
  add(path_580256, "entity", newJString(entity))
  add(query_580257, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580255.call(path_580256, query_580257, nil, nil, nil)

var storageDefaultObjectAccessControlsGet* = Call_StorageDefaultObjectAccessControlsGet_580240(
    name: "storageDefaultObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsGet_580241,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsGet_580242,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsPatch_580296 = ref object of OpenApiRestCall_579424
proc url_StorageDefaultObjectAccessControlsPatch_580298(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsPatch_580297(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches a default object ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580299 = path.getOrDefault("bucket")
  valid_580299 = validateParameter(valid_580299, JString, required = true,
                                 default = nil)
  if valid_580299 != nil:
    section.add "bucket", valid_580299
  var valid_580300 = path.getOrDefault("entity")
  valid_580300 = validateParameter(valid_580300, JString, required = true,
                                 default = nil)
  if valid_580300 != nil:
    section.add "entity", valid_580300
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580301 = query.getOrDefault("fields")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "fields", valid_580301
  var valid_580302 = query.getOrDefault("quotaUser")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "quotaUser", valid_580302
  var valid_580303 = query.getOrDefault("alt")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = newJString("json"))
  if valid_580303 != nil:
    section.add "alt", valid_580303
  var valid_580304 = query.getOrDefault("oauth_token")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "oauth_token", valid_580304
  var valid_580305 = query.getOrDefault("userIp")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "userIp", valid_580305
  var valid_580306 = query.getOrDefault("userProject")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "userProject", valid_580306
  var valid_580307 = query.getOrDefault("key")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "key", valid_580307
  var valid_580308 = query.getOrDefault("prettyPrint")
  valid_580308 = validateParameter(valid_580308, JBool, required = false,
                                 default = newJBool(true))
  if valid_580308 != nil:
    section.add "prettyPrint", valid_580308
  var valid_580309 = query.getOrDefault("provisionalUserProject")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "provisionalUserProject", valid_580309
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

proc call*(call_580311: Call_StorageDefaultObjectAccessControlsPatch_580296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patches a default object ACL entry on the specified bucket.
  ## 
  let valid = call_580311.validator(path, query, header, formData, body)
  let scheme = call_580311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580311.url(scheme.get, call_580311.host, call_580311.base,
                         call_580311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580311, url, valid)

proc call*(call_580312: Call_StorageDefaultObjectAccessControlsPatch_580296;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsPatch
  ## Patches a default object ACL entry on the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580313 = newJObject()
  var query_580314 = newJObject()
  var body_580315 = newJObject()
  add(path_580313, "bucket", newJString(bucket))
  add(query_580314, "fields", newJString(fields))
  add(query_580314, "quotaUser", newJString(quotaUser))
  add(query_580314, "alt", newJString(alt))
  add(query_580314, "oauth_token", newJString(oauthToken))
  add(query_580314, "userIp", newJString(userIp))
  add(query_580314, "userProject", newJString(userProject))
  add(query_580314, "key", newJString(key))
  if body != nil:
    body_580315 = body
  add(query_580314, "prettyPrint", newJBool(prettyPrint))
  add(path_580313, "entity", newJString(entity))
  add(query_580314, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580312.call(path_580313, query_580314, nil, nil, body_580315)

var storageDefaultObjectAccessControlsPatch* = Call_StorageDefaultObjectAccessControlsPatch_580296(
    name: "storageDefaultObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsPatch_580297,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsPatch_580298,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsDelete_580278 = ref object of OpenApiRestCall_579424
proc url_StorageDefaultObjectAccessControlsDelete_580280(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsDelete_580279(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580281 = path.getOrDefault("bucket")
  valid_580281 = validateParameter(valid_580281, JString, required = true,
                                 default = nil)
  if valid_580281 != nil:
    section.add "bucket", valid_580281
  var valid_580282 = path.getOrDefault("entity")
  valid_580282 = validateParameter(valid_580282, JString, required = true,
                                 default = nil)
  if valid_580282 != nil:
    section.add "entity", valid_580282
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580283 = query.getOrDefault("fields")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "fields", valid_580283
  var valid_580284 = query.getOrDefault("quotaUser")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "quotaUser", valid_580284
  var valid_580285 = query.getOrDefault("alt")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = newJString("json"))
  if valid_580285 != nil:
    section.add "alt", valid_580285
  var valid_580286 = query.getOrDefault("oauth_token")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "oauth_token", valid_580286
  var valid_580287 = query.getOrDefault("userIp")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "userIp", valid_580287
  var valid_580288 = query.getOrDefault("userProject")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "userProject", valid_580288
  var valid_580289 = query.getOrDefault("key")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "key", valid_580289
  var valid_580290 = query.getOrDefault("prettyPrint")
  valid_580290 = validateParameter(valid_580290, JBool, required = false,
                                 default = newJBool(true))
  if valid_580290 != nil:
    section.add "prettyPrint", valid_580290
  var valid_580291 = query.getOrDefault("provisionalUserProject")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "provisionalUserProject", valid_580291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580292: Call_StorageDefaultObjectAccessControlsDelete_580278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580292.validator(path, query, header, formData, body)
  let scheme = call_580292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580292.url(scheme.get, call_580292.host, call_580292.base,
                         call_580292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580292, url, valid)

proc call*(call_580293: Call_StorageDefaultObjectAccessControlsDelete_580278;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsDelete
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580294 = newJObject()
  var query_580295 = newJObject()
  add(path_580294, "bucket", newJString(bucket))
  add(query_580295, "fields", newJString(fields))
  add(query_580295, "quotaUser", newJString(quotaUser))
  add(query_580295, "alt", newJString(alt))
  add(query_580295, "oauth_token", newJString(oauthToken))
  add(query_580295, "userIp", newJString(userIp))
  add(query_580295, "userProject", newJString(userProject))
  add(query_580295, "key", newJString(key))
  add(query_580295, "prettyPrint", newJBool(prettyPrint))
  add(path_580294, "entity", newJString(entity))
  add(query_580295, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580293.call(path_580294, query_580295, nil, nil, nil)

var storageDefaultObjectAccessControlsDelete* = Call_StorageDefaultObjectAccessControlsDelete_580278(
    name: "storageDefaultObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsDelete_580279,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsDelete_580280,
    schemes: {Scheme.Https})
type
  Call_StorageBucketsSetIamPolicy_580334 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsSetIamPolicy_580336(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsSetIamPolicy_580335(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an IAM policy for the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580337 = path.getOrDefault("bucket")
  valid_580337 = validateParameter(valid_580337, JString, required = true,
                                 default = nil)
  if valid_580337 != nil:
    section.add "bucket", valid_580337
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580338 = query.getOrDefault("fields")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "fields", valid_580338
  var valid_580339 = query.getOrDefault("quotaUser")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "quotaUser", valid_580339
  var valid_580340 = query.getOrDefault("alt")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = newJString("json"))
  if valid_580340 != nil:
    section.add "alt", valid_580340
  var valid_580341 = query.getOrDefault("oauth_token")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "oauth_token", valid_580341
  var valid_580342 = query.getOrDefault("userIp")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "userIp", valid_580342
  var valid_580343 = query.getOrDefault("userProject")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "userProject", valid_580343
  var valid_580344 = query.getOrDefault("key")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "key", valid_580344
  var valid_580345 = query.getOrDefault("prettyPrint")
  valid_580345 = validateParameter(valid_580345, JBool, required = false,
                                 default = newJBool(true))
  if valid_580345 != nil:
    section.add "prettyPrint", valid_580345
  var valid_580346 = query.getOrDefault("provisionalUserProject")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "provisionalUserProject", valid_580346
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

proc call*(call_580348: Call_StorageBucketsSetIamPolicy_580334; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an IAM policy for the specified bucket.
  ## 
  let valid = call_580348.validator(path, query, header, formData, body)
  let scheme = call_580348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580348.url(scheme.get, call_580348.host, call_580348.base,
                         call_580348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580348, url, valid)

proc call*(call_580349: Call_StorageBucketsSetIamPolicy_580334; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; userProject: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageBucketsSetIamPolicy
  ## Updates an IAM policy for the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580350 = newJObject()
  var query_580351 = newJObject()
  var body_580352 = newJObject()
  add(path_580350, "bucket", newJString(bucket))
  add(query_580351, "fields", newJString(fields))
  add(query_580351, "quotaUser", newJString(quotaUser))
  add(query_580351, "alt", newJString(alt))
  add(query_580351, "oauth_token", newJString(oauthToken))
  add(query_580351, "userIp", newJString(userIp))
  add(query_580351, "userProject", newJString(userProject))
  add(query_580351, "key", newJString(key))
  if body != nil:
    body_580352 = body
  add(query_580351, "prettyPrint", newJBool(prettyPrint))
  add(query_580351, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580349.call(path_580350, query_580351, nil, nil, body_580352)

var storageBucketsSetIamPolicy* = Call_StorageBucketsSetIamPolicy_580334(
    name: "storageBucketsSetIamPolicy", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/iam",
    validator: validate_StorageBucketsSetIamPolicy_580335, base: "/storage/v1",
    url: url_StorageBucketsSetIamPolicy_580336, schemes: {Scheme.Https})
type
  Call_StorageBucketsGetIamPolicy_580316 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsGetIamPolicy_580318(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsGetIamPolicy_580317(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns an IAM policy for the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580319 = path.getOrDefault("bucket")
  valid_580319 = validateParameter(valid_580319, JString, required = true,
                                 default = nil)
  if valid_580319 != nil:
    section.add "bucket", valid_580319
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   optionsRequestedPolicyVersion: JInt
  ##                                : The IAM policy format version to be returned. If the optionsRequestedPolicyVersion is for an older version that doesn't support part of the requested IAM policy, the request fails.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580320 = query.getOrDefault("fields")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "fields", valid_580320
  var valid_580321 = query.getOrDefault("optionsRequestedPolicyVersion")
  valid_580321 = validateParameter(valid_580321, JInt, required = false, default = nil)
  if valid_580321 != nil:
    section.add "optionsRequestedPolicyVersion", valid_580321
  var valid_580322 = query.getOrDefault("quotaUser")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "quotaUser", valid_580322
  var valid_580323 = query.getOrDefault("alt")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = newJString("json"))
  if valid_580323 != nil:
    section.add "alt", valid_580323
  var valid_580324 = query.getOrDefault("oauth_token")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "oauth_token", valid_580324
  var valid_580325 = query.getOrDefault("userIp")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "userIp", valid_580325
  var valid_580326 = query.getOrDefault("userProject")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "userProject", valid_580326
  var valid_580327 = query.getOrDefault("key")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "key", valid_580327
  var valid_580328 = query.getOrDefault("prettyPrint")
  valid_580328 = validateParameter(valid_580328, JBool, required = false,
                                 default = newJBool(true))
  if valid_580328 != nil:
    section.add "prettyPrint", valid_580328
  var valid_580329 = query.getOrDefault("provisionalUserProject")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "provisionalUserProject", valid_580329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580330: Call_StorageBucketsGetIamPolicy_580316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an IAM policy for the specified bucket.
  ## 
  let valid = call_580330.validator(path, query, header, formData, body)
  let scheme = call_580330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580330.url(scheme.get, call_580330.host, call_580330.base,
                         call_580330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580330, url, valid)

proc call*(call_580331: Call_StorageBucketsGetIamPolicy_580316; bucket: string;
          fields: string = ""; optionsRequestedPolicyVersion: int = 0;
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageBucketsGetIamPolicy
  ## Returns an IAM policy for the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   optionsRequestedPolicyVersion: int
  ##                                : The IAM policy format version to be returned. If the optionsRequestedPolicyVersion is for an older version that doesn't support part of the requested IAM policy, the request fails.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580332 = newJObject()
  var query_580333 = newJObject()
  add(path_580332, "bucket", newJString(bucket))
  add(query_580333, "fields", newJString(fields))
  add(query_580333, "optionsRequestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580333, "quotaUser", newJString(quotaUser))
  add(query_580333, "alt", newJString(alt))
  add(query_580333, "oauth_token", newJString(oauthToken))
  add(query_580333, "userIp", newJString(userIp))
  add(query_580333, "userProject", newJString(userProject))
  add(query_580333, "key", newJString(key))
  add(query_580333, "prettyPrint", newJBool(prettyPrint))
  add(query_580333, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580331.call(path_580332, query_580333, nil, nil, nil)

var storageBucketsGetIamPolicy* = Call_StorageBucketsGetIamPolicy_580316(
    name: "storageBucketsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/iam",
    validator: validate_StorageBucketsGetIamPolicy_580317, base: "/storage/v1",
    url: url_StorageBucketsGetIamPolicy_580318, schemes: {Scheme.Https})
type
  Call_StorageBucketsTestIamPermissions_580353 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsTestIamPermissions_580355(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/iam/testPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsTestIamPermissions_580354(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Tests a set of permissions on the given bucket to see which, if any, are held by the caller.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580356 = path.getOrDefault("bucket")
  valid_580356 = validateParameter(valid_580356, JString, required = true,
                                 default = nil)
  if valid_580356 != nil:
    section.add "bucket", valid_580356
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   permissions: JArray (required)
  ##              : Permissions to test.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580357 = query.getOrDefault("fields")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "fields", valid_580357
  var valid_580358 = query.getOrDefault("quotaUser")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "quotaUser", valid_580358
  assert query != nil,
        "query argument is necessary due to required `permissions` field"
  var valid_580359 = query.getOrDefault("permissions")
  valid_580359 = validateParameter(valid_580359, JArray, required = true, default = nil)
  if valid_580359 != nil:
    section.add "permissions", valid_580359
  var valid_580360 = query.getOrDefault("alt")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = newJString("json"))
  if valid_580360 != nil:
    section.add "alt", valid_580360
  var valid_580361 = query.getOrDefault("oauth_token")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "oauth_token", valid_580361
  var valid_580362 = query.getOrDefault("userIp")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "userIp", valid_580362
  var valid_580363 = query.getOrDefault("userProject")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "userProject", valid_580363
  var valid_580364 = query.getOrDefault("key")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "key", valid_580364
  var valid_580365 = query.getOrDefault("prettyPrint")
  valid_580365 = validateParameter(valid_580365, JBool, required = false,
                                 default = newJBool(true))
  if valid_580365 != nil:
    section.add "prettyPrint", valid_580365
  var valid_580366 = query.getOrDefault("provisionalUserProject")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "provisionalUserProject", valid_580366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580367: Call_StorageBucketsTestIamPermissions_580353;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests a set of permissions on the given bucket to see which, if any, are held by the caller.
  ## 
  let valid = call_580367.validator(path, query, header, formData, body)
  let scheme = call_580367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580367.url(scheme.get, call_580367.host, call_580367.base,
                         call_580367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580367, url, valid)

proc call*(call_580368: Call_StorageBucketsTestIamPermissions_580353;
          bucket: string; permissions: JsonNode; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageBucketsTestIamPermissions
  ## Tests a set of permissions on the given bucket to see which, if any, are held by the caller.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   permissions: JArray (required)
  ##              : Permissions to test.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580369 = newJObject()
  var query_580370 = newJObject()
  add(path_580369, "bucket", newJString(bucket))
  add(query_580370, "fields", newJString(fields))
  add(query_580370, "quotaUser", newJString(quotaUser))
  if permissions != nil:
    query_580370.add "permissions", permissions
  add(query_580370, "alt", newJString(alt))
  add(query_580370, "oauth_token", newJString(oauthToken))
  add(query_580370, "userIp", newJString(userIp))
  add(query_580370, "userProject", newJString(userProject))
  add(query_580370, "key", newJString(key))
  add(query_580370, "prettyPrint", newJBool(prettyPrint))
  add(query_580370, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580368.call(path_580369, query_580370, nil, nil, nil)

var storageBucketsTestIamPermissions* = Call_StorageBucketsTestIamPermissions_580353(
    name: "storageBucketsTestIamPermissions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/iam/testPermissions",
    validator: validate_StorageBucketsTestIamPermissions_580354,
    base: "/storage/v1", url: url_StorageBucketsTestIamPermissions_580355,
    schemes: {Scheme.Https})
type
  Call_StorageBucketsLockRetentionPolicy_580371 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsLockRetentionPolicy_580373(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/lockRetentionPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsLockRetentionPolicy_580372(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Locks retention policy on a bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580374 = path.getOrDefault("bucket")
  valid_580374 = validateParameter(valid_580374, JString, required = true,
                                 default = nil)
  if valid_580374 != nil:
    section.add "bucket", valid_580374
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifMetagenerationMatch: JString (required)
  ##                        : Makes the operation conditional on whether bucket's current metageneration matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580375 = query.getOrDefault("fields")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "fields", valid_580375
  var valid_580376 = query.getOrDefault("quotaUser")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "quotaUser", valid_580376
  var valid_580377 = query.getOrDefault("alt")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = newJString("json"))
  if valid_580377 != nil:
    section.add "alt", valid_580377
  var valid_580378 = query.getOrDefault("oauth_token")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "oauth_token", valid_580378
  var valid_580379 = query.getOrDefault("userIp")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "userIp", valid_580379
  var valid_580380 = query.getOrDefault("userProject")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "userProject", valid_580380
  var valid_580381 = query.getOrDefault("key")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "key", valid_580381
  assert query != nil, "query argument is necessary due to required `ifMetagenerationMatch` field"
  var valid_580382 = query.getOrDefault("ifMetagenerationMatch")
  valid_580382 = validateParameter(valid_580382, JString, required = true,
                                 default = nil)
  if valid_580382 != nil:
    section.add "ifMetagenerationMatch", valid_580382
  var valid_580383 = query.getOrDefault("prettyPrint")
  valid_580383 = validateParameter(valid_580383, JBool, required = false,
                                 default = newJBool(true))
  if valid_580383 != nil:
    section.add "prettyPrint", valid_580383
  var valid_580384 = query.getOrDefault("provisionalUserProject")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "provisionalUserProject", valid_580384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580385: Call_StorageBucketsLockRetentionPolicy_580371;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Locks retention policy on a bucket.
  ## 
  let valid = call_580385.validator(path, query, header, formData, body)
  let scheme = call_580385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580385.url(scheme.get, call_580385.host, call_580385.base,
                         call_580385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580385, url, valid)

proc call*(call_580386: Call_StorageBucketsLockRetentionPolicy_580371;
          bucket: string; ifMetagenerationMatch: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageBucketsLockRetentionPolicy
  ## Locks retention policy on a bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifMetagenerationMatch: string (required)
  ##                        : Makes the operation conditional on whether bucket's current metageneration matches the given value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580387 = newJObject()
  var query_580388 = newJObject()
  add(path_580387, "bucket", newJString(bucket))
  add(query_580388, "fields", newJString(fields))
  add(query_580388, "quotaUser", newJString(quotaUser))
  add(query_580388, "alt", newJString(alt))
  add(query_580388, "oauth_token", newJString(oauthToken))
  add(query_580388, "userIp", newJString(userIp))
  add(query_580388, "userProject", newJString(userProject))
  add(query_580388, "key", newJString(key))
  add(query_580388, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580388, "prettyPrint", newJBool(prettyPrint))
  add(query_580388, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580386.call(path_580387, query_580388, nil, nil, nil)

var storageBucketsLockRetentionPolicy* = Call_StorageBucketsLockRetentionPolicy_580371(
    name: "storageBucketsLockRetentionPolicy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/lockRetentionPolicy",
    validator: validate_StorageBucketsLockRetentionPolicy_580372,
    base: "/storage/v1", url: url_StorageBucketsLockRetentionPolicy_580373,
    schemes: {Scheme.Https})
type
  Call_StorageNotificationsInsert_580406 = ref object of OpenApiRestCall_579424
proc url_StorageNotificationsInsert_580408(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/notificationConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageNotificationsInsert_580407(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a notification subscription for a given bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : The parent bucket of the notification.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580409 = path.getOrDefault("bucket")
  valid_580409 = validateParameter(valid_580409, JString, required = true,
                                 default = nil)
  if valid_580409 != nil:
    section.add "bucket", valid_580409
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580410 = query.getOrDefault("fields")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "fields", valid_580410
  var valid_580411 = query.getOrDefault("quotaUser")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "quotaUser", valid_580411
  var valid_580412 = query.getOrDefault("alt")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = newJString("json"))
  if valid_580412 != nil:
    section.add "alt", valid_580412
  var valid_580413 = query.getOrDefault("oauth_token")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "oauth_token", valid_580413
  var valid_580414 = query.getOrDefault("userIp")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "userIp", valid_580414
  var valid_580415 = query.getOrDefault("userProject")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "userProject", valid_580415
  var valid_580416 = query.getOrDefault("key")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "key", valid_580416
  var valid_580417 = query.getOrDefault("prettyPrint")
  valid_580417 = validateParameter(valid_580417, JBool, required = false,
                                 default = newJBool(true))
  if valid_580417 != nil:
    section.add "prettyPrint", valid_580417
  var valid_580418 = query.getOrDefault("provisionalUserProject")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "provisionalUserProject", valid_580418
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

proc call*(call_580420: Call_StorageNotificationsInsert_580406; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a notification subscription for a given bucket.
  ## 
  let valid = call_580420.validator(path, query, header, formData, body)
  let scheme = call_580420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580420.url(scheme.get, call_580420.host, call_580420.base,
                         call_580420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580420, url, valid)

proc call*(call_580421: Call_StorageNotificationsInsert_580406; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; userProject: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageNotificationsInsert
  ## Creates a notification subscription for a given bucket.
  ##   bucket: string (required)
  ##         : The parent bucket of the notification.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580422 = newJObject()
  var query_580423 = newJObject()
  var body_580424 = newJObject()
  add(path_580422, "bucket", newJString(bucket))
  add(query_580423, "fields", newJString(fields))
  add(query_580423, "quotaUser", newJString(quotaUser))
  add(query_580423, "alt", newJString(alt))
  add(query_580423, "oauth_token", newJString(oauthToken))
  add(query_580423, "userIp", newJString(userIp))
  add(query_580423, "userProject", newJString(userProject))
  add(query_580423, "key", newJString(key))
  if body != nil:
    body_580424 = body
  add(query_580423, "prettyPrint", newJBool(prettyPrint))
  add(query_580423, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580421.call(path_580422, query_580423, nil, nil, body_580424)

var storageNotificationsInsert* = Call_StorageNotificationsInsert_580406(
    name: "storageNotificationsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/notificationConfigs",
    validator: validate_StorageNotificationsInsert_580407, base: "/storage/v1",
    url: url_StorageNotificationsInsert_580408, schemes: {Scheme.Https})
type
  Call_StorageNotificationsList_580389 = ref object of OpenApiRestCall_579424
proc url_StorageNotificationsList_580391(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/notificationConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageNotificationsList_580390(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of notification subscriptions for a given bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a Google Cloud Storage bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580392 = path.getOrDefault("bucket")
  valid_580392 = validateParameter(valid_580392, JString, required = true,
                                 default = nil)
  if valid_580392 != nil:
    section.add "bucket", valid_580392
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580393 = query.getOrDefault("fields")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "fields", valid_580393
  var valid_580394 = query.getOrDefault("quotaUser")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "quotaUser", valid_580394
  var valid_580395 = query.getOrDefault("alt")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = newJString("json"))
  if valid_580395 != nil:
    section.add "alt", valid_580395
  var valid_580396 = query.getOrDefault("oauth_token")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "oauth_token", valid_580396
  var valid_580397 = query.getOrDefault("userIp")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "userIp", valid_580397
  var valid_580398 = query.getOrDefault("userProject")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "userProject", valid_580398
  var valid_580399 = query.getOrDefault("key")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "key", valid_580399
  var valid_580400 = query.getOrDefault("prettyPrint")
  valid_580400 = validateParameter(valid_580400, JBool, required = false,
                                 default = newJBool(true))
  if valid_580400 != nil:
    section.add "prettyPrint", valid_580400
  var valid_580401 = query.getOrDefault("provisionalUserProject")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "provisionalUserProject", valid_580401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580402: Call_StorageNotificationsList_580389; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of notification subscriptions for a given bucket.
  ## 
  let valid = call_580402.validator(path, query, header, formData, body)
  let scheme = call_580402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580402.url(scheme.get, call_580402.host, call_580402.base,
                         call_580402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580402, url, valid)

proc call*(call_580403: Call_StorageNotificationsList_580389; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; userProject: string = "";
          key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageNotificationsList
  ## Retrieves a list of notification subscriptions for a given bucket.
  ##   bucket: string (required)
  ##         : Name of a Google Cloud Storage bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580404 = newJObject()
  var query_580405 = newJObject()
  add(path_580404, "bucket", newJString(bucket))
  add(query_580405, "fields", newJString(fields))
  add(query_580405, "quotaUser", newJString(quotaUser))
  add(query_580405, "alt", newJString(alt))
  add(query_580405, "oauth_token", newJString(oauthToken))
  add(query_580405, "userIp", newJString(userIp))
  add(query_580405, "userProject", newJString(userProject))
  add(query_580405, "key", newJString(key))
  add(query_580405, "prettyPrint", newJBool(prettyPrint))
  add(query_580405, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580403.call(path_580404, query_580405, nil, nil, nil)

var storageNotificationsList* = Call_StorageNotificationsList_580389(
    name: "storageNotificationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/notificationConfigs",
    validator: validate_StorageNotificationsList_580390, base: "/storage/v1",
    url: url_StorageNotificationsList_580391, schemes: {Scheme.Https})
type
  Call_StorageNotificationsGet_580425 = ref object of OpenApiRestCall_579424
proc url_StorageNotificationsGet_580427(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "notification" in path, "`notification` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/notificationConfigs/"),
               (kind: VariableSegment, value: "notification")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageNotificationsGet_580426(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## View a notification configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : The parent bucket of the notification.
  ##   notification: JString (required)
  ##               : Notification ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580428 = path.getOrDefault("bucket")
  valid_580428 = validateParameter(valid_580428, JString, required = true,
                                 default = nil)
  if valid_580428 != nil:
    section.add "bucket", valid_580428
  var valid_580429 = path.getOrDefault("notification")
  valid_580429 = validateParameter(valid_580429, JString, required = true,
                                 default = nil)
  if valid_580429 != nil:
    section.add "notification", valid_580429
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580430 = query.getOrDefault("fields")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "fields", valid_580430
  var valid_580431 = query.getOrDefault("quotaUser")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "quotaUser", valid_580431
  var valid_580432 = query.getOrDefault("alt")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = newJString("json"))
  if valid_580432 != nil:
    section.add "alt", valid_580432
  var valid_580433 = query.getOrDefault("oauth_token")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "oauth_token", valid_580433
  var valid_580434 = query.getOrDefault("userIp")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "userIp", valid_580434
  var valid_580435 = query.getOrDefault("userProject")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "userProject", valid_580435
  var valid_580436 = query.getOrDefault("key")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "key", valid_580436
  var valid_580437 = query.getOrDefault("prettyPrint")
  valid_580437 = validateParameter(valid_580437, JBool, required = false,
                                 default = newJBool(true))
  if valid_580437 != nil:
    section.add "prettyPrint", valid_580437
  var valid_580438 = query.getOrDefault("provisionalUserProject")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "provisionalUserProject", valid_580438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580439: Call_StorageNotificationsGet_580425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## View a notification configuration.
  ## 
  let valid = call_580439.validator(path, query, header, formData, body)
  let scheme = call_580439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580439.url(scheme.get, call_580439.host, call_580439.base,
                         call_580439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580439, url, valid)

proc call*(call_580440: Call_StorageNotificationsGet_580425; bucket: string;
          notification: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageNotificationsGet
  ## View a notification configuration.
  ##   bucket: string (required)
  ##         : The parent bucket of the notification.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   notification: string (required)
  ##               : Notification ID
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580441 = newJObject()
  var query_580442 = newJObject()
  add(path_580441, "bucket", newJString(bucket))
  add(query_580442, "fields", newJString(fields))
  add(query_580442, "quotaUser", newJString(quotaUser))
  add(query_580442, "alt", newJString(alt))
  add(path_580441, "notification", newJString(notification))
  add(query_580442, "oauth_token", newJString(oauthToken))
  add(query_580442, "userIp", newJString(userIp))
  add(query_580442, "userProject", newJString(userProject))
  add(query_580442, "key", newJString(key))
  add(query_580442, "prettyPrint", newJBool(prettyPrint))
  add(query_580442, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580440.call(path_580441, query_580442, nil, nil, nil)

var storageNotificationsGet* = Call_StorageNotificationsGet_580425(
    name: "storageNotificationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/b/{bucket}/notificationConfigs/{notification}",
    validator: validate_StorageNotificationsGet_580426, base: "/storage/v1",
    url: url_StorageNotificationsGet_580427, schemes: {Scheme.Https})
type
  Call_StorageNotificationsDelete_580443 = ref object of OpenApiRestCall_579424
proc url_StorageNotificationsDelete_580445(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "notification" in path, "`notification` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/notificationConfigs/"),
               (kind: VariableSegment, value: "notification")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageNotificationsDelete_580444(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes a notification subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : The parent bucket of the notification.
  ##   notification: JString (required)
  ##               : ID of the notification to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580446 = path.getOrDefault("bucket")
  valid_580446 = validateParameter(valid_580446, JString, required = true,
                                 default = nil)
  if valid_580446 != nil:
    section.add "bucket", valid_580446
  var valid_580447 = path.getOrDefault("notification")
  valid_580447 = validateParameter(valid_580447, JString, required = true,
                                 default = nil)
  if valid_580447 != nil:
    section.add "notification", valid_580447
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580448 = query.getOrDefault("fields")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "fields", valid_580448
  var valid_580449 = query.getOrDefault("quotaUser")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "quotaUser", valid_580449
  var valid_580450 = query.getOrDefault("alt")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = newJString("json"))
  if valid_580450 != nil:
    section.add "alt", valid_580450
  var valid_580451 = query.getOrDefault("oauth_token")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "oauth_token", valid_580451
  var valid_580452 = query.getOrDefault("userIp")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "userIp", valid_580452
  var valid_580453 = query.getOrDefault("userProject")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "userProject", valid_580453
  var valid_580454 = query.getOrDefault("key")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "key", valid_580454
  var valid_580455 = query.getOrDefault("prettyPrint")
  valid_580455 = validateParameter(valid_580455, JBool, required = false,
                                 default = newJBool(true))
  if valid_580455 != nil:
    section.add "prettyPrint", valid_580455
  var valid_580456 = query.getOrDefault("provisionalUserProject")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "provisionalUserProject", valid_580456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580457: Call_StorageNotificationsDelete_580443; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a notification subscription.
  ## 
  let valid = call_580457.validator(path, query, header, formData, body)
  let scheme = call_580457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580457.url(scheme.get, call_580457.host, call_580457.base,
                         call_580457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580457, url, valid)

proc call*(call_580458: Call_StorageNotificationsDelete_580443; bucket: string;
          notification: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageNotificationsDelete
  ## Permanently deletes a notification subscription.
  ##   bucket: string (required)
  ##         : The parent bucket of the notification.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   notification: string (required)
  ##               : ID of the notification to delete.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580459 = newJObject()
  var query_580460 = newJObject()
  add(path_580459, "bucket", newJString(bucket))
  add(query_580460, "fields", newJString(fields))
  add(query_580460, "quotaUser", newJString(quotaUser))
  add(query_580460, "alt", newJString(alt))
  add(path_580459, "notification", newJString(notification))
  add(query_580460, "oauth_token", newJString(oauthToken))
  add(query_580460, "userIp", newJString(userIp))
  add(query_580460, "userProject", newJString(userProject))
  add(query_580460, "key", newJString(key))
  add(query_580460, "prettyPrint", newJBool(prettyPrint))
  add(query_580460, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580458.call(path_580459, query_580460, nil, nil, nil)

var storageNotificationsDelete* = Call_StorageNotificationsDelete_580443(
    name: "storageNotificationsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/b/{bucket}/notificationConfigs/{notification}",
    validator: validate_StorageNotificationsDelete_580444, base: "/storage/v1",
    url: url_StorageNotificationsDelete_580445, schemes: {Scheme.Https})
type
  Call_StorageObjectsInsert_580485 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsInsert_580487(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsInsert_580486(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stores a new object and metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580488 = path.getOrDefault("bucket")
  valid_580488 = validateParameter(valid_580488, JString, required = true,
                                 default = nil)
  if valid_580488 != nil:
    section.add "bucket", valid_580488
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   contentEncoding: JString
  ##                  : If set, sets the contentEncoding property of the final object to this value. Setting this parameter is equivalent to setting the contentEncoding metadata property. This can be useful when uploading an object with uploadType=media to indicate the encoding of the content being uploaded.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   kmsKeyName: JString
  ##             : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this object.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : Name of the object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580489 = query.getOrDefault("ifGenerationMatch")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "ifGenerationMatch", valid_580489
  var valid_580490 = query.getOrDefault("fields")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "fields", valid_580490
  var valid_580491 = query.getOrDefault("contentEncoding")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "contentEncoding", valid_580491
  var valid_580492 = query.getOrDefault("quotaUser")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = nil)
  if valid_580492 != nil:
    section.add "quotaUser", valid_580492
  var valid_580493 = query.getOrDefault("kmsKeyName")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = nil)
  if valid_580493 != nil:
    section.add "kmsKeyName", valid_580493
  var valid_580494 = query.getOrDefault("alt")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = newJString("json"))
  if valid_580494 != nil:
    section.add "alt", valid_580494
  var valid_580495 = query.getOrDefault("ifGenerationNotMatch")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "ifGenerationNotMatch", valid_580495
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
  var valid_580498 = query.getOrDefault("predefinedAcl")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580498 != nil:
    section.add "predefinedAcl", valid_580498
  var valid_580499 = query.getOrDefault("userProject")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "userProject", valid_580499
  var valid_580500 = query.getOrDefault("key")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "key", valid_580500
  var valid_580501 = query.getOrDefault("name")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "name", valid_580501
  var valid_580502 = query.getOrDefault("projection")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = newJString("full"))
  if valid_580502 != nil:
    section.add "projection", valid_580502
  var valid_580503 = query.getOrDefault("ifMetagenerationMatch")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "ifMetagenerationMatch", valid_580503
  var valid_580504 = query.getOrDefault("prettyPrint")
  valid_580504 = validateParameter(valid_580504, JBool, required = false,
                                 default = newJBool(true))
  if valid_580504 != nil:
    section.add "prettyPrint", valid_580504
  var valid_580505 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "ifMetagenerationNotMatch", valid_580505
  var valid_580506 = query.getOrDefault("provisionalUserProject")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = nil)
  if valid_580506 != nil:
    section.add "provisionalUserProject", valid_580506
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

proc call*(call_580508: Call_StorageObjectsInsert_580485; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stores a new object and metadata.
  ## 
  let valid = call_580508.validator(path, query, header, formData, body)
  let scheme = call_580508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580508.url(scheme.get, call_580508.host, call_580508.base,
                         call_580508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580508, url, valid)

proc call*(call_580509: Call_StorageObjectsInsert_580485; bucket: string;
          ifGenerationMatch: string = ""; fields: string = "";
          contentEncoding: string = ""; quotaUser: string = ""; kmsKeyName: string = "";
          alt: string = "json"; ifGenerationNotMatch: string = "";
          oauthToken: string = ""; userIp: string = "";
          predefinedAcl: string = "authenticatedRead"; userProject: string = "";
          key: string = ""; name: string = ""; projection: string = "full";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; ifMetagenerationNotMatch: string = "";
          provisionalUserProject: string = ""): Recallable =
  ## storageObjectsInsert
  ## Stores a new object and metadata.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   bucket: string (required)
  ##         : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   contentEncoding: string
  ##                  : If set, sets the contentEncoding property of the final object to this value. Setting this parameter is equivalent to setting the contentEncoding metadata property. This can be useful when uploading an object with uploadType=media to indicate the encoding of the content being uploaded.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   kmsKeyName: string
  ##             : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this object.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : Name of the object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580510 = newJObject()
  var query_580511 = newJObject()
  var body_580512 = newJObject()
  add(query_580511, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_580510, "bucket", newJString(bucket))
  add(query_580511, "fields", newJString(fields))
  add(query_580511, "contentEncoding", newJString(contentEncoding))
  add(query_580511, "quotaUser", newJString(quotaUser))
  add(query_580511, "kmsKeyName", newJString(kmsKeyName))
  add(query_580511, "alt", newJString(alt))
  add(query_580511, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580511, "oauth_token", newJString(oauthToken))
  add(query_580511, "userIp", newJString(userIp))
  add(query_580511, "predefinedAcl", newJString(predefinedAcl))
  add(query_580511, "userProject", newJString(userProject))
  add(query_580511, "key", newJString(key))
  add(query_580511, "name", newJString(name))
  add(query_580511, "projection", newJString(projection))
  add(query_580511, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_580512 = body
  add(query_580511, "prettyPrint", newJBool(prettyPrint))
  add(query_580511, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580511, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580509.call(path_580510, query_580511, nil, nil, body_580512)

var storageObjectsInsert* = Call_StorageObjectsInsert_580485(
    name: "storageObjectsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsInsert_580486, base: "/storage/v1",
    url: url_StorageObjectsInsert_580487, schemes: {Scheme.Https})
type
  Call_StorageObjectsList_580461 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsList_580463(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsList_580462(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a list of objects matching the criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which to look for objects.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580464 = path.getOrDefault("bucket")
  valid_580464 = validateParameter(valid_580464, JString, required = true,
                                 default = nil)
  if valid_580464 != nil:
    section.add "bucket", valid_580464
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeTrailingDelimiter: JBool
  ##                           : If true, objects that end in exactly one instance of delimiter will have their metadata included in items in addition to prefixes.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   versions: JBool
  ##           : If true, lists all versions of an object as distinct results. The default is false. For more information, see Object Versioning.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of items plus prefixes to return in a single page of responses. As duplicate prefixes are omitted, fewer total results may be returned than requested. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   delimiter: JString
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: JString
  ##         : Filter results to objects whose names begin with this prefix.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580465 = query.getOrDefault("fields")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "fields", valid_580465
  var valid_580466 = query.getOrDefault("pageToken")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "pageToken", valid_580466
  var valid_580467 = query.getOrDefault("quotaUser")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "quotaUser", valid_580467
  var valid_580468 = query.getOrDefault("includeTrailingDelimiter")
  valid_580468 = validateParameter(valid_580468, JBool, required = false, default = nil)
  if valid_580468 != nil:
    section.add "includeTrailingDelimiter", valid_580468
  var valid_580469 = query.getOrDefault("alt")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = newJString("json"))
  if valid_580469 != nil:
    section.add "alt", valid_580469
  var valid_580470 = query.getOrDefault("oauth_token")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "oauth_token", valid_580470
  var valid_580471 = query.getOrDefault("versions")
  valid_580471 = validateParameter(valid_580471, JBool, required = false, default = nil)
  if valid_580471 != nil:
    section.add "versions", valid_580471
  var valid_580472 = query.getOrDefault("userIp")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "userIp", valid_580472
  var valid_580473 = query.getOrDefault("maxResults")
  valid_580473 = validateParameter(valid_580473, JInt, required = false,
                                 default = newJInt(1000))
  if valid_580473 != nil:
    section.add "maxResults", valid_580473
  var valid_580474 = query.getOrDefault("userProject")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "userProject", valid_580474
  var valid_580475 = query.getOrDefault("key")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "key", valid_580475
  var valid_580476 = query.getOrDefault("projection")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = newJString("full"))
  if valid_580476 != nil:
    section.add "projection", valid_580476
  var valid_580477 = query.getOrDefault("delimiter")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = nil)
  if valid_580477 != nil:
    section.add "delimiter", valid_580477
  var valid_580478 = query.getOrDefault("prettyPrint")
  valid_580478 = validateParameter(valid_580478, JBool, required = false,
                                 default = newJBool(true))
  if valid_580478 != nil:
    section.add "prettyPrint", valid_580478
  var valid_580479 = query.getOrDefault("prefix")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = nil)
  if valid_580479 != nil:
    section.add "prefix", valid_580479
  var valid_580480 = query.getOrDefault("provisionalUserProject")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "provisionalUserProject", valid_580480
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580481: Call_StorageObjectsList_580461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of objects matching the criteria.
  ## 
  let valid = call_580481.validator(path, query, header, formData, body)
  let scheme = call_580481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580481.url(scheme.get, call_580481.host, call_580481.base,
                         call_580481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580481, url, valid)

proc call*(call_580482: Call_StorageObjectsList_580461; bucket: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          includeTrailingDelimiter: bool = false; alt: string = "json";
          oauthToken: string = ""; versions: bool = false; userIp: string = "";
          maxResults: int = 1000; userProject: string = ""; key: string = "";
          projection: string = "full"; delimiter: string = ""; prettyPrint: bool = true;
          prefix: string = ""; provisionalUserProject: string = ""): Recallable =
  ## storageObjectsList
  ## Retrieves a list of objects matching the criteria.
  ##   bucket: string (required)
  ##         : Name of the bucket in which to look for objects.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeTrailingDelimiter: bool
  ##                           : If true, objects that end in exactly one instance of delimiter will have their metadata included in items in addition to prefixes.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   versions: bool
  ##           : If true, lists all versions of an object as distinct results. The default is false. For more information, see Object Versioning.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of items plus prefixes to return in a single page of responses. As duplicate prefixes are omitted, fewer total results may be returned than requested. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   delimiter: string
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: string
  ##         : Filter results to objects whose names begin with this prefix.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580483 = newJObject()
  var query_580484 = newJObject()
  add(path_580483, "bucket", newJString(bucket))
  add(query_580484, "fields", newJString(fields))
  add(query_580484, "pageToken", newJString(pageToken))
  add(query_580484, "quotaUser", newJString(quotaUser))
  add(query_580484, "includeTrailingDelimiter", newJBool(includeTrailingDelimiter))
  add(query_580484, "alt", newJString(alt))
  add(query_580484, "oauth_token", newJString(oauthToken))
  add(query_580484, "versions", newJBool(versions))
  add(query_580484, "userIp", newJString(userIp))
  add(query_580484, "maxResults", newJInt(maxResults))
  add(query_580484, "userProject", newJString(userProject))
  add(query_580484, "key", newJString(key))
  add(query_580484, "projection", newJString(projection))
  add(query_580484, "delimiter", newJString(delimiter))
  add(query_580484, "prettyPrint", newJBool(prettyPrint))
  add(query_580484, "prefix", newJString(prefix))
  add(query_580484, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580482.call(path_580483, query_580484, nil, nil, nil)

var storageObjectsList* = Call_StorageObjectsList_580461(
    name: "storageObjectsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsList_580462, base: "/storage/v1",
    url: url_StorageObjectsList_580463, schemes: {Scheme.Https})
type
  Call_StorageObjectsWatchAll_580513 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsWatchAll_580515(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/watch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsWatchAll_580514(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Watch for changes on all objects in a bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which to look for objects.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580516 = path.getOrDefault("bucket")
  valid_580516 = validateParameter(valid_580516, JString, required = true,
                                 default = nil)
  if valid_580516 != nil:
    section.add "bucket", valid_580516
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeTrailingDelimiter: JBool
  ##                           : If true, objects that end in exactly one instance of delimiter will have their metadata included in items in addition to prefixes.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   versions: JBool
  ##           : If true, lists all versions of an object as distinct results. The default is false. For more information, see Object Versioning.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of items plus prefixes to return in a single page of responses. As duplicate prefixes are omitted, fewer total results may be returned than requested. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   delimiter: JString
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: JString
  ##         : Filter results to objects whose names begin with this prefix.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580517 = query.getOrDefault("fields")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "fields", valid_580517
  var valid_580518 = query.getOrDefault("pageToken")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "pageToken", valid_580518
  var valid_580519 = query.getOrDefault("quotaUser")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "quotaUser", valid_580519
  var valid_580520 = query.getOrDefault("includeTrailingDelimiter")
  valid_580520 = validateParameter(valid_580520, JBool, required = false, default = nil)
  if valid_580520 != nil:
    section.add "includeTrailingDelimiter", valid_580520
  var valid_580521 = query.getOrDefault("alt")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = newJString("json"))
  if valid_580521 != nil:
    section.add "alt", valid_580521
  var valid_580522 = query.getOrDefault("oauth_token")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = nil)
  if valid_580522 != nil:
    section.add "oauth_token", valid_580522
  var valid_580523 = query.getOrDefault("versions")
  valid_580523 = validateParameter(valid_580523, JBool, required = false, default = nil)
  if valid_580523 != nil:
    section.add "versions", valid_580523
  var valid_580524 = query.getOrDefault("userIp")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "userIp", valid_580524
  var valid_580525 = query.getOrDefault("maxResults")
  valid_580525 = validateParameter(valid_580525, JInt, required = false,
                                 default = newJInt(1000))
  if valid_580525 != nil:
    section.add "maxResults", valid_580525
  var valid_580526 = query.getOrDefault("userProject")
  valid_580526 = validateParameter(valid_580526, JString, required = false,
                                 default = nil)
  if valid_580526 != nil:
    section.add "userProject", valid_580526
  var valid_580527 = query.getOrDefault("key")
  valid_580527 = validateParameter(valid_580527, JString, required = false,
                                 default = nil)
  if valid_580527 != nil:
    section.add "key", valid_580527
  var valid_580528 = query.getOrDefault("projection")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = newJString("full"))
  if valid_580528 != nil:
    section.add "projection", valid_580528
  var valid_580529 = query.getOrDefault("delimiter")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "delimiter", valid_580529
  var valid_580530 = query.getOrDefault("prettyPrint")
  valid_580530 = validateParameter(valid_580530, JBool, required = false,
                                 default = newJBool(true))
  if valid_580530 != nil:
    section.add "prettyPrint", valid_580530
  var valid_580531 = query.getOrDefault("prefix")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "prefix", valid_580531
  var valid_580532 = query.getOrDefault("provisionalUserProject")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "provisionalUserProject", valid_580532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580534: Call_StorageObjectsWatchAll_580513; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes on all objects in a bucket.
  ## 
  let valid = call_580534.validator(path, query, header, formData, body)
  let scheme = call_580534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580534.url(scheme.get, call_580534.host, call_580534.base,
                         call_580534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580534, url, valid)

proc call*(call_580535: Call_StorageObjectsWatchAll_580513; bucket: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          includeTrailingDelimiter: bool = false; alt: string = "json";
          oauthToken: string = ""; versions: bool = false; userIp: string = "";
          maxResults: int = 1000; userProject: string = ""; key: string = "";
          projection: string = "full"; delimiter: string = ""; resource: JsonNode = nil;
          prettyPrint: bool = true; prefix: string = "";
          provisionalUserProject: string = ""): Recallable =
  ## storageObjectsWatchAll
  ## Watch for changes on all objects in a bucket.
  ##   bucket: string (required)
  ##         : Name of the bucket in which to look for objects.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeTrailingDelimiter: bool
  ##                           : If true, objects that end in exactly one instance of delimiter will have their metadata included in items in addition to prefixes.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   versions: bool
  ##           : If true, lists all versions of an object as distinct results. The default is false. For more information, see Object Versioning.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of items plus prefixes to return in a single page of responses. As duplicate prefixes are omitted, fewer total results may be returned than requested. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   delimiter: string
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   resource: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: string
  ##         : Filter results to objects whose names begin with this prefix.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580536 = newJObject()
  var query_580537 = newJObject()
  var body_580538 = newJObject()
  add(path_580536, "bucket", newJString(bucket))
  add(query_580537, "fields", newJString(fields))
  add(query_580537, "pageToken", newJString(pageToken))
  add(query_580537, "quotaUser", newJString(quotaUser))
  add(query_580537, "includeTrailingDelimiter", newJBool(includeTrailingDelimiter))
  add(query_580537, "alt", newJString(alt))
  add(query_580537, "oauth_token", newJString(oauthToken))
  add(query_580537, "versions", newJBool(versions))
  add(query_580537, "userIp", newJString(userIp))
  add(query_580537, "maxResults", newJInt(maxResults))
  add(query_580537, "userProject", newJString(userProject))
  add(query_580537, "key", newJString(key))
  add(query_580537, "projection", newJString(projection))
  add(query_580537, "delimiter", newJString(delimiter))
  if resource != nil:
    body_580538 = resource
  add(query_580537, "prettyPrint", newJBool(prettyPrint))
  add(query_580537, "prefix", newJString(prefix))
  add(query_580537, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580535.call(path_580536, query_580537, nil, nil, body_580538)

var storageObjectsWatchAll* = Call_StorageObjectsWatchAll_580513(
    name: "storageObjectsWatchAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o/watch",
    validator: validate_StorageObjectsWatchAll_580514, base: "/storage/v1",
    url: url_StorageObjectsWatchAll_580515, schemes: {Scheme.Https})
type
  Call_StorageObjectsUpdate_580563 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsUpdate_580565(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsUpdate_580564(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an object's metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580566 = path.getOrDefault("bucket")
  valid_580566 = validateParameter(valid_580566, JString, required = true,
                                 default = nil)
  if valid_580566 != nil:
    section.add "bucket", valid_580566
  var valid_580567 = path.getOrDefault("object")
  valid_580567 = validateParameter(valid_580567, JString, required = true,
                                 default = nil)
  if valid_580567 != nil:
    section.add "object", valid_580567
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this object.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580568 = query.getOrDefault("ifGenerationMatch")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "ifGenerationMatch", valid_580568
  var valid_580569 = query.getOrDefault("fields")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "fields", valid_580569
  var valid_580570 = query.getOrDefault("quotaUser")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "quotaUser", valid_580570
  var valid_580571 = query.getOrDefault("alt")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = newJString("json"))
  if valid_580571 != nil:
    section.add "alt", valid_580571
  var valid_580572 = query.getOrDefault("ifGenerationNotMatch")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = nil)
  if valid_580572 != nil:
    section.add "ifGenerationNotMatch", valid_580572
  var valid_580573 = query.getOrDefault("oauth_token")
  valid_580573 = validateParameter(valid_580573, JString, required = false,
                                 default = nil)
  if valid_580573 != nil:
    section.add "oauth_token", valid_580573
  var valid_580574 = query.getOrDefault("userIp")
  valid_580574 = validateParameter(valid_580574, JString, required = false,
                                 default = nil)
  if valid_580574 != nil:
    section.add "userIp", valid_580574
  var valid_580575 = query.getOrDefault("predefinedAcl")
  valid_580575 = validateParameter(valid_580575, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580575 != nil:
    section.add "predefinedAcl", valid_580575
  var valid_580576 = query.getOrDefault("userProject")
  valid_580576 = validateParameter(valid_580576, JString, required = false,
                                 default = nil)
  if valid_580576 != nil:
    section.add "userProject", valid_580576
  var valid_580577 = query.getOrDefault("key")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "key", valid_580577
  var valid_580578 = query.getOrDefault("projection")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = newJString("full"))
  if valid_580578 != nil:
    section.add "projection", valid_580578
  var valid_580579 = query.getOrDefault("ifMetagenerationMatch")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = nil)
  if valid_580579 != nil:
    section.add "ifMetagenerationMatch", valid_580579
  var valid_580580 = query.getOrDefault("generation")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = nil)
  if valid_580580 != nil:
    section.add "generation", valid_580580
  var valid_580581 = query.getOrDefault("prettyPrint")
  valid_580581 = validateParameter(valid_580581, JBool, required = false,
                                 default = newJBool(true))
  if valid_580581 != nil:
    section.add "prettyPrint", valid_580581
  var valid_580582 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "ifMetagenerationNotMatch", valid_580582
  var valid_580583 = query.getOrDefault("provisionalUserProject")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "provisionalUserProject", valid_580583
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

proc call*(call_580585: Call_StorageObjectsUpdate_580563; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an object's metadata.
  ## 
  let valid = call_580585.validator(path, query, header, formData, body)
  let scheme = call_580585.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580585.url(scheme.get, call_580585.host, call_580585.base,
                         call_580585.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580585, url, valid)

proc call*(call_580586: Call_StorageObjectsUpdate_580563; bucket: string;
          `object`: string; ifGenerationMatch: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          ifGenerationNotMatch: string = ""; oauthToken: string = "";
          userIp: string = ""; predefinedAcl: string = "authenticatedRead";
          userProject: string = ""; key: string = ""; projection: string = "full";
          ifMetagenerationMatch: string = ""; generation: string = "";
          body: JsonNode = nil; prettyPrint: bool = true;
          ifMetagenerationNotMatch: string = ""; provisionalUserProject: string = ""): Recallable =
  ## storageObjectsUpdate
  ## Updates an object's metadata.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this object.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580587 = newJObject()
  var query_580588 = newJObject()
  var body_580589 = newJObject()
  add(query_580588, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_580587, "bucket", newJString(bucket))
  add(query_580588, "fields", newJString(fields))
  add(query_580588, "quotaUser", newJString(quotaUser))
  add(query_580588, "alt", newJString(alt))
  add(query_580588, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580588, "oauth_token", newJString(oauthToken))
  add(query_580588, "userIp", newJString(userIp))
  add(query_580588, "predefinedAcl", newJString(predefinedAcl))
  add(query_580588, "userProject", newJString(userProject))
  add(query_580588, "key", newJString(key))
  add(query_580588, "projection", newJString(projection))
  add(query_580588, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580588, "generation", newJString(generation))
  if body != nil:
    body_580589 = body
  add(query_580588, "prettyPrint", newJBool(prettyPrint))
  add(query_580588, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_580587, "object", newJString(`object`))
  add(query_580588, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580586.call(path_580587, query_580588, nil, nil, body_580589)

var storageObjectsUpdate* = Call_StorageObjectsUpdate_580563(
    name: "storageObjectsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsUpdate_580564, base: "/storage/v1",
    url: url_StorageObjectsUpdate_580565, schemes: {Scheme.Https})
type
  Call_StorageObjectsGet_580539 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsGet_580541(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsGet_580540(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves an object or its metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580542 = path.getOrDefault("bucket")
  valid_580542 = validateParameter(valid_580542, JString, required = true,
                                 default = nil)
  if valid_580542 != nil:
    section.add "bucket", valid_580542
  var valid_580543 = path.getOrDefault("object")
  valid_580543 = validateParameter(valid_580543, JString, required = true,
                                 default = nil)
  if valid_580543 != nil:
    section.add "object", valid_580543
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580544 = query.getOrDefault("ifGenerationMatch")
  valid_580544 = validateParameter(valid_580544, JString, required = false,
                                 default = nil)
  if valid_580544 != nil:
    section.add "ifGenerationMatch", valid_580544
  var valid_580545 = query.getOrDefault("fields")
  valid_580545 = validateParameter(valid_580545, JString, required = false,
                                 default = nil)
  if valid_580545 != nil:
    section.add "fields", valid_580545
  var valid_580546 = query.getOrDefault("quotaUser")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "quotaUser", valid_580546
  var valid_580547 = query.getOrDefault("alt")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = newJString("json"))
  if valid_580547 != nil:
    section.add "alt", valid_580547
  var valid_580548 = query.getOrDefault("ifGenerationNotMatch")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = nil)
  if valid_580548 != nil:
    section.add "ifGenerationNotMatch", valid_580548
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
  var valid_580551 = query.getOrDefault("userProject")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "userProject", valid_580551
  var valid_580552 = query.getOrDefault("key")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "key", valid_580552
  var valid_580553 = query.getOrDefault("projection")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = newJString("full"))
  if valid_580553 != nil:
    section.add "projection", valid_580553
  var valid_580554 = query.getOrDefault("ifMetagenerationMatch")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = nil)
  if valid_580554 != nil:
    section.add "ifMetagenerationMatch", valid_580554
  var valid_580555 = query.getOrDefault("generation")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "generation", valid_580555
  var valid_580556 = query.getOrDefault("prettyPrint")
  valid_580556 = validateParameter(valid_580556, JBool, required = false,
                                 default = newJBool(true))
  if valid_580556 != nil:
    section.add "prettyPrint", valid_580556
  var valid_580557 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = nil)
  if valid_580557 != nil:
    section.add "ifMetagenerationNotMatch", valid_580557
  var valid_580558 = query.getOrDefault("provisionalUserProject")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = nil)
  if valid_580558 != nil:
    section.add "provisionalUserProject", valid_580558
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580559: Call_StorageObjectsGet_580539; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an object or its metadata.
  ## 
  let valid = call_580559.validator(path, query, header, formData, body)
  let scheme = call_580559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580559.url(scheme.get, call_580559.host, call_580559.base,
                         call_580559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580559, url, valid)

proc call*(call_580560: Call_StorageObjectsGet_580539; bucket: string;
          `object`: string; ifGenerationMatch: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          ifGenerationNotMatch: string = ""; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          projection: string = "full"; ifMetagenerationMatch: string = "";
          generation: string = ""; prettyPrint: bool = true;
          ifMetagenerationNotMatch: string = ""; provisionalUserProject: string = ""): Recallable =
  ## storageObjectsGet
  ## Retrieves an object or its metadata.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580561 = newJObject()
  var query_580562 = newJObject()
  add(query_580562, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_580561, "bucket", newJString(bucket))
  add(query_580562, "fields", newJString(fields))
  add(query_580562, "quotaUser", newJString(quotaUser))
  add(query_580562, "alt", newJString(alt))
  add(query_580562, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580562, "oauth_token", newJString(oauthToken))
  add(query_580562, "userIp", newJString(userIp))
  add(query_580562, "userProject", newJString(userProject))
  add(query_580562, "key", newJString(key))
  add(query_580562, "projection", newJString(projection))
  add(query_580562, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580562, "generation", newJString(generation))
  add(query_580562, "prettyPrint", newJBool(prettyPrint))
  add(query_580562, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_580561, "object", newJString(`object`))
  add(query_580562, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580560.call(path_580561, query_580562, nil, nil, nil)

var storageObjectsGet* = Call_StorageObjectsGet_580539(name: "storageObjectsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/b/{bucket}/o/{object}", validator: validate_StorageObjectsGet_580540,
    base: "/storage/v1", url: url_StorageObjectsGet_580541, schemes: {Scheme.Https})
type
  Call_StorageObjectsPatch_580613 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsPatch_580615(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsPatch_580614(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Patches an object's metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580616 = path.getOrDefault("bucket")
  valid_580616 = validateParameter(valid_580616, JString, required = true,
                                 default = nil)
  if valid_580616 != nil:
    section.add "bucket", valid_580616
  var valid_580617 = path.getOrDefault("object")
  valid_580617 = validateParameter(valid_580617, JString, required = true,
                                 default = nil)
  if valid_580617 != nil:
    section.add "object", valid_580617
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this object.
  ##   userProject: JString
  ##              : The project to be billed for this request, for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580618 = query.getOrDefault("ifGenerationMatch")
  valid_580618 = validateParameter(valid_580618, JString, required = false,
                                 default = nil)
  if valid_580618 != nil:
    section.add "ifGenerationMatch", valid_580618
  var valid_580619 = query.getOrDefault("fields")
  valid_580619 = validateParameter(valid_580619, JString, required = false,
                                 default = nil)
  if valid_580619 != nil:
    section.add "fields", valid_580619
  var valid_580620 = query.getOrDefault("quotaUser")
  valid_580620 = validateParameter(valid_580620, JString, required = false,
                                 default = nil)
  if valid_580620 != nil:
    section.add "quotaUser", valid_580620
  var valid_580621 = query.getOrDefault("alt")
  valid_580621 = validateParameter(valid_580621, JString, required = false,
                                 default = newJString("json"))
  if valid_580621 != nil:
    section.add "alt", valid_580621
  var valid_580622 = query.getOrDefault("ifGenerationNotMatch")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = nil)
  if valid_580622 != nil:
    section.add "ifGenerationNotMatch", valid_580622
  var valid_580623 = query.getOrDefault("oauth_token")
  valid_580623 = validateParameter(valid_580623, JString, required = false,
                                 default = nil)
  if valid_580623 != nil:
    section.add "oauth_token", valid_580623
  var valid_580624 = query.getOrDefault("userIp")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = nil)
  if valid_580624 != nil:
    section.add "userIp", valid_580624
  var valid_580625 = query.getOrDefault("predefinedAcl")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580625 != nil:
    section.add "predefinedAcl", valid_580625
  var valid_580626 = query.getOrDefault("userProject")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = nil)
  if valid_580626 != nil:
    section.add "userProject", valid_580626
  var valid_580627 = query.getOrDefault("key")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "key", valid_580627
  var valid_580628 = query.getOrDefault("projection")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = newJString("full"))
  if valid_580628 != nil:
    section.add "projection", valid_580628
  var valid_580629 = query.getOrDefault("ifMetagenerationMatch")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "ifMetagenerationMatch", valid_580629
  var valid_580630 = query.getOrDefault("generation")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = nil)
  if valid_580630 != nil:
    section.add "generation", valid_580630
  var valid_580631 = query.getOrDefault("prettyPrint")
  valid_580631 = validateParameter(valid_580631, JBool, required = false,
                                 default = newJBool(true))
  if valid_580631 != nil:
    section.add "prettyPrint", valid_580631
  var valid_580632 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = nil)
  if valid_580632 != nil:
    section.add "ifMetagenerationNotMatch", valid_580632
  var valid_580633 = query.getOrDefault("provisionalUserProject")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "provisionalUserProject", valid_580633
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

proc call*(call_580635: Call_StorageObjectsPatch_580613; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches an object's metadata.
  ## 
  let valid = call_580635.validator(path, query, header, formData, body)
  let scheme = call_580635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580635.url(scheme.get, call_580635.host, call_580635.base,
                         call_580635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580635, url, valid)

proc call*(call_580636: Call_StorageObjectsPatch_580613; bucket: string;
          `object`: string; ifGenerationMatch: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          ifGenerationNotMatch: string = ""; oauthToken: string = "";
          userIp: string = ""; predefinedAcl: string = "authenticatedRead";
          userProject: string = ""; key: string = ""; projection: string = "full";
          ifMetagenerationMatch: string = ""; generation: string = "";
          body: JsonNode = nil; prettyPrint: bool = true;
          ifMetagenerationNotMatch: string = ""; provisionalUserProject: string = ""): Recallable =
  ## storageObjectsPatch
  ## Patches an object's metadata.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this object.
  ##   userProject: string
  ##              : The project to be billed for this request, for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580637 = newJObject()
  var query_580638 = newJObject()
  var body_580639 = newJObject()
  add(query_580638, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_580637, "bucket", newJString(bucket))
  add(query_580638, "fields", newJString(fields))
  add(query_580638, "quotaUser", newJString(quotaUser))
  add(query_580638, "alt", newJString(alt))
  add(query_580638, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580638, "oauth_token", newJString(oauthToken))
  add(query_580638, "userIp", newJString(userIp))
  add(query_580638, "predefinedAcl", newJString(predefinedAcl))
  add(query_580638, "userProject", newJString(userProject))
  add(query_580638, "key", newJString(key))
  add(query_580638, "projection", newJString(projection))
  add(query_580638, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580638, "generation", newJString(generation))
  if body != nil:
    body_580639 = body
  add(query_580638, "prettyPrint", newJBool(prettyPrint))
  add(query_580638, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_580637, "object", newJString(`object`))
  add(query_580638, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580636.call(path_580637, query_580638, nil, nil, body_580639)

var storageObjectsPatch* = Call_StorageObjectsPatch_580613(
    name: "storageObjectsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsPatch_580614, base: "/storage/v1",
    url: url_StorageObjectsPatch_580615, schemes: {Scheme.Https})
type
  Call_StorageObjectsDelete_580590 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsDelete_580592(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsDelete_580591(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an object and its metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580593 = path.getOrDefault("bucket")
  valid_580593 = validateParameter(valid_580593, JString, required = true,
                                 default = nil)
  if valid_580593 != nil:
    section.add "bucket", valid_580593
  var valid_580594 = path.getOrDefault("object")
  valid_580594 = validateParameter(valid_580594, JString, required = true,
                                 default = nil)
  if valid_580594 != nil:
    section.add "object", valid_580594
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   generation: JString
  ##             : If present, permanently deletes a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580595 = query.getOrDefault("ifGenerationMatch")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "ifGenerationMatch", valid_580595
  var valid_580596 = query.getOrDefault("fields")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "fields", valid_580596
  var valid_580597 = query.getOrDefault("quotaUser")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = nil)
  if valid_580597 != nil:
    section.add "quotaUser", valid_580597
  var valid_580598 = query.getOrDefault("alt")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = newJString("json"))
  if valid_580598 != nil:
    section.add "alt", valid_580598
  var valid_580599 = query.getOrDefault("ifGenerationNotMatch")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = nil)
  if valid_580599 != nil:
    section.add "ifGenerationNotMatch", valid_580599
  var valid_580600 = query.getOrDefault("oauth_token")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = nil)
  if valid_580600 != nil:
    section.add "oauth_token", valid_580600
  var valid_580601 = query.getOrDefault("userIp")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = nil)
  if valid_580601 != nil:
    section.add "userIp", valid_580601
  var valid_580602 = query.getOrDefault("userProject")
  valid_580602 = validateParameter(valid_580602, JString, required = false,
                                 default = nil)
  if valid_580602 != nil:
    section.add "userProject", valid_580602
  var valid_580603 = query.getOrDefault("key")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = nil)
  if valid_580603 != nil:
    section.add "key", valid_580603
  var valid_580604 = query.getOrDefault("ifMetagenerationMatch")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = nil)
  if valid_580604 != nil:
    section.add "ifMetagenerationMatch", valid_580604
  var valid_580605 = query.getOrDefault("generation")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "generation", valid_580605
  var valid_580606 = query.getOrDefault("prettyPrint")
  valid_580606 = validateParameter(valid_580606, JBool, required = false,
                                 default = newJBool(true))
  if valid_580606 != nil:
    section.add "prettyPrint", valid_580606
  var valid_580607 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "ifMetagenerationNotMatch", valid_580607
  var valid_580608 = query.getOrDefault("provisionalUserProject")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = nil)
  if valid_580608 != nil:
    section.add "provisionalUserProject", valid_580608
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580609: Call_StorageObjectsDelete_580590; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an object and its metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ## 
  let valid = call_580609.validator(path, query, header, formData, body)
  let scheme = call_580609.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580609.url(scheme.get, call_580609.host, call_580609.base,
                         call_580609.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580609, url, valid)

proc call*(call_580610: Call_StorageObjectsDelete_580590; bucket: string;
          `object`: string; ifGenerationMatch: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          ifGenerationNotMatch: string = ""; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          ifMetagenerationMatch: string = ""; generation: string = "";
          prettyPrint: bool = true; ifMetagenerationNotMatch: string = "";
          provisionalUserProject: string = ""): Recallable =
  ## storageObjectsDelete
  ## Deletes an object and its metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   generation: string
  ##             : If present, permanently deletes a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580611 = newJObject()
  var query_580612 = newJObject()
  add(query_580612, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_580611, "bucket", newJString(bucket))
  add(query_580612, "fields", newJString(fields))
  add(query_580612, "quotaUser", newJString(quotaUser))
  add(query_580612, "alt", newJString(alt))
  add(query_580612, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580612, "oauth_token", newJString(oauthToken))
  add(query_580612, "userIp", newJString(userIp))
  add(query_580612, "userProject", newJString(userProject))
  add(query_580612, "key", newJString(key))
  add(query_580612, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580612, "generation", newJString(generation))
  add(query_580612, "prettyPrint", newJBool(prettyPrint))
  add(query_580612, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_580611, "object", newJString(`object`))
  add(query_580612, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580610.call(path_580611, query_580612, nil, nil, nil)

var storageObjectsDelete* = Call_StorageObjectsDelete_580590(
    name: "storageObjectsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsDelete_580591, base: "/storage/v1",
    url: url_StorageObjectsDelete_580592, schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsInsert_580659 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsInsert_580661(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsInsert_580660(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new ACL entry on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580662 = path.getOrDefault("bucket")
  valid_580662 = validateParameter(valid_580662, JString, required = true,
                                 default = nil)
  if valid_580662 != nil:
    section.add "bucket", valid_580662
  var valid_580663 = path.getOrDefault("object")
  valid_580663 = validateParameter(valid_580663, JString, required = true,
                                 default = nil)
  if valid_580663 != nil:
    section.add "object", valid_580663
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580664 = query.getOrDefault("fields")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "fields", valid_580664
  var valid_580665 = query.getOrDefault("quotaUser")
  valid_580665 = validateParameter(valid_580665, JString, required = false,
                                 default = nil)
  if valid_580665 != nil:
    section.add "quotaUser", valid_580665
  var valid_580666 = query.getOrDefault("alt")
  valid_580666 = validateParameter(valid_580666, JString, required = false,
                                 default = newJString("json"))
  if valid_580666 != nil:
    section.add "alt", valid_580666
  var valid_580667 = query.getOrDefault("oauth_token")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "oauth_token", valid_580667
  var valid_580668 = query.getOrDefault("userIp")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "userIp", valid_580668
  var valid_580669 = query.getOrDefault("userProject")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = nil)
  if valid_580669 != nil:
    section.add "userProject", valid_580669
  var valid_580670 = query.getOrDefault("key")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = nil)
  if valid_580670 != nil:
    section.add "key", valid_580670
  var valid_580671 = query.getOrDefault("generation")
  valid_580671 = validateParameter(valid_580671, JString, required = false,
                                 default = nil)
  if valid_580671 != nil:
    section.add "generation", valid_580671
  var valid_580672 = query.getOrDefault("prettyPrint")
  valid_580672 = validateParameter(valid_580672, JBool, required = false,
                                 default = newJBool(true))
  if valid_580672 != nil:
    section.add "prettyPrint", valid_580672
  var valid_580673 = query.getOrDefault("provisionalUserProject")
  valid_580673 = validateParameter(valid_580673, JString, required = false,
                                 default = nil)
  if valid_580673 != nil:
    section.add "provisionalUserProject", valid_580673
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

proc call*(call_580675: Call_StorageObjectAccessControlsInsert_580659;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified object.
  ## 
  let valid = call_580675.validator(path, query, header, formData, body)
  let scheme = call_580675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580675.url(scheme.get, call_580675.host, call_580675.base,
                         call_580675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580675, url, valid)

proc call*(call_580676: Call_StorageObjectAccessControlsInsert_580659;
          bucket: string; `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; generation: string = "";
          body: JsonNode = nil; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageObjectAccessControlsInsert
  ## Creates a new ACL entry on the specified object.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580677 = newJObject()
  var query_580678 = newJObject()
  var body_580679 = newJObject()
  add(path_580677, "bucket", newJString(bucket))
  add(query_580678, "fields", newJString(fields))
  add(query_580678, "quotaUser", newJString(quotaUser))
  add(query_580678, "alt", newJString(alt))
  add(query_580678, "oauth_token", newJString(oauthToken))
  add(query_580678, "userIp", newJString(userIp))
  add(query_580678, "userProject", newJString(userProject))
  add(query_580678, "key", newJString(key))
  add(query_580678, "generation", newJString(generation))
  if body != nil:
    body_580679 = body
  add(query_580678, "prettyPrint", newJBool(prettyPrint))
  add(path_580677, "object", newJString(`object`))
  add(query_580678, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580676.call(path_580677, query_580678, nil, nil, body_580679)

var storageObjectAccessControlsInsert* = Call_StorageObjectAccessControlsInsert_580659(
    name: "storageObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsInsert_580660,
    base: "/storage/v1", url: url_StorageObjectAccessControlsInsert_580661,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsList_580640 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsList_580642(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsList_580641(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves ACL entries on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580643 = path.getOrDefault("bucket")
  valid_580643 = validateParameter(valid_580643, JString, required = true,
                                 default = nil)
  if valid_580643 != nil:
    section.add "bucket", valid_580643
  var valid_580644 = path.getOrDefault("object")
  valid_580644 = validateParameter(valid_580644, JString, required = true,
                                 default = nil)
  if valid_580644 != nil:
    section.add "object", valid_580644
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580645 = query.getOrDefault("fields")
  valid_580645 = validateParameter(valid_580645, JString, required = false,
                                 default = nil)
  if valid_580645 != nil:
    section.add "fields", valid_580645
  var valid_580646 = query.getOrDefault("quotaUser")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = nil)
  if valid_580646 != nil:
    section.add "quotaUser", valid_580646
  var valid_580647 = query.getOrDefault("alt")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = newJString("json"))
  if valid_580647 != nil:
    section.add "alt", valid_580647
  var valid_580648 = query.getOrDefault("oauth_token")
  valid_580648 = validateParameter(valid_580648, JString, required = false,
                                 default = nil)
  if valid_580648 != nil:
    section.add "oauth_token", valid_580648
  var valid_580649 = query.getOrDefault("userIp")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = nil)
  if valid_580649 != nil:
    section.add "userIp", valid_580649
  var valid_580650 = query.getOrDefault("userProject")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = nil)
  if valid_580650 != nil:
    section.add "userProject", valid_580650
  var valid_580651 = query.getOrDefault("key")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "key", valid_580651
  var valid_580652 = query.getOrDefault("generation")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "generation", valid_580652
  var valid_580653 = query.getOrDefault("prettyPrint")
  valid_580653 = validateParameter(valid_580653, JBool, required = false,
                                 default = newJBool(true))
  if valid_580653 != nil:
    section.add "prettyPrint", valid_580653
  var valid_580654 = query.getOrDefault("provisionalUserProject")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = nil)
  if valid_580654 != nil:
    section.add "provisionalUserProject", valid_580654
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580655: Call_StorageObjectAccessControlsList_580640;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified object.
  ## 
  let valid = call_580655.validator(path, query, header, formData, body)
  let scheme = call_580655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580655.url(scheme.get, call_580655.host, call_580655.base,
                         call_580655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580655, url, valid)

proc call*(call_580656: Call_StorageObjectAccessControlsList_580640;
          bucket: string; `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; generation: string = "";
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageObjectAccessControlsList
  ## Retrieves ACL entries on the specified object.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580657 = newJObject()
  var query_580658 = newJObject()
  add(path_580657, "bucket", newJString(bucket))
  add(query_580658, "fields", newJString(fields))
  add(query_580658, "quotaUser", newJString(quotaUser))
  add(query_580658, "alt", newJString(alt))
  add(query_580658, "oauth_token", newJString(oauthToken))
  add(query_580658, "userIp", newJString(userIp))
  add(query_580658, "userProject", newJString(userProject))
  add(query_580658, "key", newJString(key))
  add(query_580658, "generation", newJString(generation))
  add(query_580658, "prettyPrint", newJBool(prettyPrint))
  add(path_580657, "object", newJString(`object`))
  add(query_580658, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580656.call(path_580657, query_580658, nil, nil, nil)

var storageObjectAccessControlsList* = Call_StorageObjectAccessControlsList_580640(
    name: "storageObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsList_580641,
    base: "/storage/v1", url: url_StorageObjectAccessControlsList_580642,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsUpdate_580700 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsUpdate_580702(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsUpdate_580701(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an ACL entry on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580703 = path.getOrDefault("bucket")
  valid_580703 = validateParameter(valid_580703, JString, required = true,
                                 default = nil)
  if valid_580703 != nil:
    section.add "bucket", valid_580703
  var valid_580704 = path.getOrDefault("entity")
  valid_580704 = validateParameter(valid_580704, JString, required = true,
                                 default = nil)
  if valid_580704 != nil:
    section.add "entity", valid_580704
  var valid_580705 = path.getOrDefault("object")
  valid_580705 = validateParameter(valid_580705, JString, required = true,
                                 default = nil)
  if valid_580705 != nil:
    section.add "object", valid_580705
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580706 = query.getOrDefault("fields")
  valid_580706 = validateParameter(valid_580706, JString, required = false,
                                 default = nil)
  if valid_580706 != nil:
    section.add "fields", valid_580706
  var valid_580707 = query.getOrDefault("quotaUser")
  valid_580707 = validateParameter(valid_580707, JString, required = false,
                                 default = nil)
  if valid_580707 != nil:
    section.add "quotaUser", valid_580707
  var valid_580708 = query.getOrDefault("alt")
  valid_580708 = validateParameter(valid_580708, JString, required = false,
                                 default = newJString("json"))
  if valid_580708 != nil:
    section.add "alt", valid_580708
  var valid_580709 = query.getOrDefault("oauth_token")
  valid_580709 = validateParameter(valid_580709, JString, required = false,
                                 default = nil)
  if valid_580709 != nil:
    section.add "oauth_token", valid_580709
  var valid_580710 = query.getOrDefault("userIp")
  valid_580710 = validateParameter(valid_580710, JString, required = false,
                                 default = nil)
  if valid_580710 != nil:
    section.add "userIp", valid_580710
  var valid_580711 = query.getOrDefault("userProject")
  valid_580711 = validateParameter(valid_580711, JString, required = false,
                                 default = nil)
  if valid_580711 != nil:
    section.add "userProject", valid_580711
  var valid_580712 = query.getOrDefault("key")
  valid_580712 = validateParameter(valid_580712, JString, required = false,
                                 default = nil)
  if valid_580712 != nil:
    section.add "key", valid_580712
  var valid_580713 = query.getOrDefault("generation")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = nil)
  if valid_580713 != nil:
    section.add "generation", valid_580713
  var valid_580714 = query.getOrDefault("prettyPrint")
  valid_580714 = validateParameter(valid_580714, JBool, required = false,
                                 default = newJBool(true))
  if valid_580714 != nil:
    section.add "prettyPrint", valid_580714
  var valid_580715 = query.getOrDefault("provisionalUserProject")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "provisionalUserProject", valid_580715
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

proc call*(call_580717: Call_StorageObjectAccessControlsUpdate_580700;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object.
  ## 
  let valid = call_580717.validator(path, query, header, formData, body)
  let scheme = call_580717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580717.url(scheme.get, call_580717.host, call_580717.base,
                         call_580717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580717, url, valid)

proc call*(call_580718: Call_StorageObjectAccessControlsUpdate_580700;
          bucket: string; entity: string; `object`: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          generation: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageObjectAccessControlsUpdate
  ## Updates an ACL entry on the specified object.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580719 = newJObject()
  var query_580720 = newJObject()
  var body_580721 = newJObject()
  add(path_580719, "bucket", newJString(bucket))
  add(query_580720, "fields", newJString(fields))
  add(query_580720, "quotaUser", newJString(quotaUser))
  add(query_580720, "alt", newJString(alt))
  add(query_580720, "oauth_token", newJString(oauthToken))
  add(query_580720, "userIp", newJString(userIp))
  add(query_580720, "userProject", newJString(userProject))
  add(query_580720, "key", newJString(key))
  add(query_580720, "generation", newJString(generation))
  if body != nil:
    body_580721 = body
  add(query_580720, "prettyPrint", newJBool(prettyPrint))
  add(path_580719, "entity", newJString(entity))
  add(path_580719, "object", newJString(`object`))
  add(query_580720, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580718.call(path_580719, query_580720, nil, nil, body_580721)

var storageObjectAccessControlsUpdate* = Call_StorageObjectAccessControlsUpdate_580700(
    name: "storageObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsUpdate_580701,
    base: "/storage/v1", url: url_StorageObjectAccessControlsUpdate_580702,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsGet_580680 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsGet_580682(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsGet_580681(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the ACL entry for the specified entity on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580683 = path.getOrDefault("bucket")
  valid_580683 = validateParameter(valid_580683, JString, required = true,
                                 default = nil)
  if valid_580683 != nil:
    section.add "bucket", valid_580683
  var valid_580684 = path.getOrDefault("entity")
  valid_580684 = validateParameter(valid_580684, JString, required = true,
                                 default = nil)
  if valid_580684 != nil:
    section.add "entity", valid_580684
  var valid_580685 = path.getOrDefault("object")
  valid_580685 = validateParameter(valid_580685, JString, required = true,
                                 default = nil)
  if valid_580685 != nil:
    section.add "object", valid_580685
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
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
  var valid_580691 = query.getOrDefault("userProject")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = nil)
  if valid_580691 != nil:
    section.add "userProject", valid_580691
  var valid_580692 = query.getOrDefault("key")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = nil)
  if valid_580692 != nil:
    section.add "key", valid_580692
  var valid_580693 = query.getOrDefault("generation")
  valid_580693 = validateParameter(valid_580693, JString, required = false,
                                 default = nil)
  if valid_580693 != nil:
    section.add "generation", valid_580693
  var valid_580694 = query.getOrDefault("prettyPrint")
  valid_580694 = validateParameter(valid_580694, JBool, required = false,
                                 default = newJBool(true))
  if valid_580694 != nil:
    section.add "prettyPrint", valid_580694
  var valid_580695 = query.getOrDefault("provisionalUserProject")
  valid_580695 = validateParameter(valid_580695, JString, required = false,
                                 default = nil)
  if valid_580695 != nil:
    section.add "provisionalUserProject", valid_580695
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580696: Call_StorageObjectAccessControlsGet_580680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_580696.validator(path, query, header, formData, body)
  let scheme = call_580696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580696.url(scheme.get, call_580696.host, call_580696.base,
                         call_580696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580696, url, valid)

proc call*(call_580697: Call_StorageObjectAccessControlsGet_580680; bucket: string;
          entity: string; `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; generation: string = "";
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageObjectAccessControlsGet
  ## Returns the ACL entry for the specified entity on the specified object.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580698 = newJObject()
  var query_580699 = newJObject()
  add(path_580698, "bucket", newJString(bucket))
  add(query_580699, "fields", newJString(fields))
  add(query_580699, "quotaUser", newJString(quotaUser))
  add(query_580699, "alt", newJString(alt))
  add(query_580699, "oauth_token", newJString(oauthToken))
  add(query_580699, "userIp", newJString(userIp))
  add(query_580699, "userProject", newJString(userProject))
  add(query_580699, "key", newJString(key))
  add(query_580699, "generation", newJString(generation))
  add(query_580699, "prettyPrint", newJBool(prettyPrint))
  add(path_580698, "entity", newJString(entity))
  add(path_580698, "object", newJString(`object`))
  add(query_580699, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580697.call(path_580698, query_580699, nil, nil, nil)

var storageObjectAccessControlsGet* = Call_StorageObjectAccessControlsGet_580680(
    name: "storageObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsGet_580681,
    base: "/storage/v1", url: url_StorageObjectAccessControlsGet_580682,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsPatch_580742 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsPatch_580744(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsPatch_580743(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches an ACL entry on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580745 = path.getOrDefault("bucket")
  valid_580745 = validateParameter(valid_580745, JString, required = true,
                                 default = nil)
  if valid_580745 != nil:
    section.add "bucket", valid_580745
  var valid_580746 = path.getOrDefault("entity")
  valid_580746 = validateParameter(valid_580746, JString, required = true,
                                 default = nil)
  if valid_580746 != nil:
    section.add "entity", valid_580746
  var valid_580747 = path.getOrDefault("object")
  valid_580747 = validateParameter(valid_580747, JString, required = true,
                                 default = nil)
  if valid_580747 != nil:
    section.add "object", valid_580747
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580748 = query.getOrDefault("fields")
  valid_580748 = validateParameter(valid_580748, JString, required = false,
                                 default = nil)
  if valid_580748 != nil:
    section.add "fields", valid_580748
  var valid_580749 = query.getOrDefault("quotaUser")
  valid_580749 = validateParameter(valid_580749, JString, required = false,
                                 default = nil)
  if valid_580749 != nil:
    section.add "quotaUser", valid_580749
  var valid_580750 = query.getOrDefault("alt")
  valid_580750 = validateParameter(valid_580750, JString, required = false,
                                 default = newJString("json"))
  if valid_580750 != nil:
    section.add "alt", valid_580750
  var valid_580751 = query.getOrDefault("oauth_token")
  valid_580751 = validateParameter(valid_580751, JString, required = false,
                                 default = nil)
  if valid_580751 != nil:
    section.add "oauth_token", valid_580751
  var valid_580752 = query.getOrDefault("userIp")
  valid_580752 = validateParameter(valid_580752, JString, required = false,
                                 default = nil)
  if valid_580752 != nil:
    section.add "userIp", valid_580752
  var valid_580753 = query.getOrDefault("userProject")
  valid_580753 = validateParameter(valid_580753, JString, required = false,
                                 default = nil)
  if valid_580753 != nil:
    section.add "userProject", valid_580753
  var valid_580754 = query.getOrDefault("key")
  valid_580754 = validateParameter(valid_580754, JString, required = false,
                                 default = nil)
  if valid_580754 != nil:
    section.add "key", valid_580754
  var valid_580755 = query.getOrDefault("generation")
  valid_580755 = validateParameter(valid_580755, JString, required = false,
                                 default = nil)
  if valid_580755 != nil:
    section.add "generation", valid_580755
  var valid_580756 = query.getOrDefault("prettyPrint")
  valid_580756 = validateParameter(valid_580756, JBool, required = false,
                                 default = newJBool(true))
  if valid_580756 != nil:
    section.add "prettyPrint", valid_580756
  var valid_580757 = query.getOrDefault("provisionalUserProject")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = nil)
  if valid_580757 != nil:
    section.add "provisionalUserProject", valid_580757
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

proc call*(call_580759: Call_StorageObjectAccessControlsPatch_580742;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patches an ACL entry on the specified object.
  ## 
  let valid = call_580759.validator(path, query, header, formData, body)
  let scheme = call_580759.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580759.url(scheme.get, call_580759.host, call_580759.base,
                         call_580759.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580759, url, valid)

proc call*(call_580760: Call_StorageObjectAccessControlsPatch_580742;
          bucket: string; entity: string; `object`: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          generation: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageObjectAccessControlsPatch
  ## Patches an ACL entry on the specified object.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580761 = newJObject()
  var query_580762 = newJObject()
  var body_580763 = newJObject()
  add(path_580761, "bucket", newJString(bucket))
  add(query_580762, "fields", newJString(fields))
  add(query_580762, "quotaUser", newJString(quotaUser))
  add(query_580762, "alt", newJString(alt))
  add(query_580762, "oauth_token", newJString(oauthToken))
  add(query_580762, "userIp", newJString(userIp))
  add(query_580762, "userProject", newJString(userProject))
  add(query_580762, "key", newJString(key))
  add(query_580762, "generation", newJString(generation))
  if body != nil:
    body_580763 = body
  add(query_580762, "prettyPrint", newJBool(prettyPrint))
  add(path_580761, "entity", newJString(entity))
  add(path_580761, "object", newJString(`object`))
  add(query_580762, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580760.call(path_580761, query_580762, nil, nil, body_580763)

var storageObjectAccessControlsPatch* = Call_StorageObjectAccessControlsPatch_580742(
    name: "storageObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsPatch_580743,
    base: "/storage/v1", url: url_StorageObjectAccessControlsPatch_580744,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsDelete_580722 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsDelete_580724(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsDelete_580723(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580725 = path.getOrDefault("bucket")
  valid_580725 = validateParameter(valid_580725, JString, required = true,
                                 default = nil)
  if valid_580725 != nil:
    section.add "bucket", valid_580725
  var valid_580726 = path.getOrDefault("entity")
  valid_580726 = validateParameter(valid_580726, JString, required = true,
                                 default = nil)
  if valid_580726 != nil:
    section.add "entity", valid_580726
  var valid_580727 = path.getOrDefault("object")
  valid_580727 = validateParameter(valid_580727, JString, required = true,
                                 default = nil)
  if valid_580727 != nil:
    section.add "object", valid_580727
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580728 = query.getOrDefault("fields")
  valid_580728 = validateParameter(valid_580728, JString, required = false,
                                 default = nil)
  if valid_580728 != nil:
    section.add "fields", valid_580728
  var valid_580729 = query.getOrDefault("quotaUser")
  valid_580729 = validateParameter(valid_580729, JString, required = false,
                                 default = nil)
  if valid_580729 != nil:
    section.add "quotaUser", valid_580729
  var valid_580730 = query.getOrDefault("alt")
  valid_580730 = validateParameter(valid_580730, JString, required = false,
                                 default = newJString("json"))
  if valid_580730 != nil:
    section.add "alt", valid_580730
  var valid_580731 = query.getOrDefault("oauth_token")
  valid_580731 = validateParameter(valid_580731, JString, required = false,
                                 default = nil)
  if valid_580731 != nil:
    section.add "oauth_token", valid_580731
  var valid_580732 = query.getOrDefault("userIp")
  valid_580732 = validateParameter(valid_580732, JString, required = false,
                                 default = nil)
  if valid_580732 != nil:
    section.add "userIp", valid_580732
  var valid_580733 = query.getOrDefault("userProject")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = nil)
  if valid_580733 != nil:
    section.add "userProject", valid_580733
  var valid_580734 = query.getOrDefault("key")
  valid_580734 = validateParameter(valid_580734, JString, required = false,
                                 default = nil)
  if valid_580734 != nil:
    section.add "key", valid_580734
  var valid_580735 = query.getOrDefault("generation")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = nil)
  if valid_580735 != nil:
    section.add "generation", valid_580735
  var valid_580736 = query.getOrDefault("prettyPrint")
  valid_580736 = validateParameter(valid_580736, JBool, required = false,
                                 default = newJBool(true))
  if valid_580736 != nil:
    section.add "prettyPrint", valid_580736
  var valid_580737 = query.getOrDefault("provisionalUserProject")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "provisionalUserProject", valid_580737
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580738: Call_StorageObjectAccessControlsDelete_580722;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_580738.validator(path, query, header, formData, body)
  let scheme = call_580738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580738.url(scheme.get, call_580738.host, call_580738.base,
                         call_580738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580738, url, valid)

proc call*(call_580739: Call_StorageObjectAccessControlsDelete_580722;
          bucket: string; entity: string; `object`: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          generation: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageObjectAccessControlsDelete
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580740 = newJObject()
  var query_580741 = newJObject()
  add(path_580740, "bucket", newJString(bucket))
  add(query_580741, "fields", newJString(fields))
  add(query_580741, "quotaUser", newJString(quotaUser))
  add(query_580741, "alt", newJString(alt))
  add(query_580741, "oauth_token", newJString(oauthToken))
  add(query_580741, "userIp", newJString(userIp))
  add(query_580741, "userProject", newJString(userProject))
  add(query_580741, "key", newJString(key))
  add(query_580741, "generation", newJString(generation))
  add(query_580741, "prettyPrint", newJBool(prettyPrint))
  add(path_580740, "entity", newJString(entity))
  add(path_580740, "object", newJString(`object`))
  add(query_580741, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580739.call(path_580740, query_580741, nil, nil, nil)

var storageObjectAccessControlsDelete* = Call_StorageObjectAccessControlsDelete_580722(
    name: "storageObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsDelete_580723,
    base: "/storage/v1", url: url_StorageObjectAccessControlsDelete_580724,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsSetIamPolicy_580783 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsSetIamPolicy_580785(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsSetIamPolicy_580784(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an IAM policy for the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580786 = path.getOrDefault("bucket")
  valid_580786 = validateParameter(valid_580786, JString, required = true,
                                 default = nil)
  if valid_580786 != nil:
    section.add "bucket", valid_580786
  var valid_580787 = path.getOrDefault("object")
  valid_580787 = validateParameter(valid_580787, JString, required = true,
                                 default = nil)
  if valid_580787 != nil:
    section.add "object", valid_580787
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580788 = query.getOrDefault("fields")
  valid_580788 = validateParameter(valid_580788, JString, required = false,
                                 default = nil)
  if valid_580788 != nil:
    section.add "fields", valid_580788
  var valid_580789 = query.getOrDefault("quotaUser")
  valid_580789 = validateParameter(valid_580789, JString, required = false,
                                 default = nil)
  if valid_580789 != nil:
    section.add "quotaUser", valid_580789
  var valid_580790 = query.getOrDefault("alt")
  valid_580790 = validateParameter(valid_580790, JString, required = false,
                                 default = newJString("json"))
  if valid_580790 != nil:
    section.add "alt", valid_580790
  var valid_580791 = query.getOrDefault("oauth_token")
  valid_580791 = validateParameter(valid_580791, JString, required = false,
                                 default = nil)
  if valid_580791 != nil:
    section.add "oauth_token", valid_580791
  var valid_580792 = query.getOrDefault("userIp")
  valid_580792 = validateParameter(valid_580792, JString, required = false,
                                 default = nil)
  if valid_580792 != nil:
    section.add "userIp", valid_580792
  var valid_580793 = query.getOrDefault("userProject")
  valid_580793 = validateParameter(valid_580793, JString, required = false,
                                 default = nil)
  if valid_580793 != nil:
    section.add "userProject", valid_580793
  var valid_580794 = query.getOrDefault("key")
  valid_580794 = validateParameter(valid_580794, JString, required = false,
                                 default = nil)
  if valid_580794 != nil:
    section.add "key", valid_580794
  var valid_580795 = query.getOrDefault("generation")
  valid_580795 = validateParameter(valid_580795, JString, required = false,
                                 default = nil)
  if valid_580795 != nil:
    section.add "generation", valid_580795
  var valid_580796 = query.getOrDefault("prettyPrint")
  valid_580796 = validateParameter(valid_580796, JBool, required = false,
                                 default = newJBool(true))
  if valid_580796 != nil:
    section.add "prettyPrint", valid_580796
  var valid_580797 = query.getOrDefault("provisionalUserProject")
  valid_580797 = validateParameter(valid_580797, JString, required = false,
                                 default = nil)
  if valid_580797 != nil:
    section.add "provisionalUserProject", valid_580797
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

proc call*(call_580799: Call_StorageObjectsSetIamPolicy_580783; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an IAM policy for the specified object.
  ## 
  let valid = call_580799.validator(path, query, header, formData, body)
  let scheme = call_580799.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580799.url(scheme.get, call_580799.host, call_580799.base,
                         call_580799.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580799, url, valid)

proc call*(call_580800: Call_StorageObjectsSetIamPolicy_580783; bucket: string;
          `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; generation: string = "";
          body: JsonNode = nil; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageObjectsSetIamPolicy
  ## Updates an IAM policy for the specified object.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580801 = newJObject()
  var query_580802 = newJObject()
  var body_580803 = newJObject()
  add(path_580801, "bucket", newJString(bucket))
  add(query_580802, "fields", newJString(fields))
  add(query_580802, "quotaUser", newJString(quotaUser))
  add(query_580802, "alt", newJString(alt))
  add(query_580802, "oauth_token", newJString(oauthToken))
  add(query_580802, "userIp", newJString(userIp))
  add(query_580802, "userProject", newJString(userProject))
  add(query_580802, "key", newJString(key))
  add(query_580802, "generation", newJString(generation))
  if body != nil:
    body_580803 = body
  add(query_580802, "prettyPrint", newJBool(prettyPrint))
  add(path_580801, "object", newJString(`object`))
  add(query_580802, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580800.call(path_580801, query_580802, nil, nil, body_580803)

var storageObjectsSetIamPolicy* = Call_StorageObjectsSetIamPolicy_580783(
    name: "storageObjectsSetIamPolicy", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/iam",
    validator: validate_StorageObjectsSetIamPolicy_580784, base: "/storage/v1",
    url: url_StorageObjectsSetIamPolicy_580785, schemes: {Scheme.Https})
type
  Call_StorageObjectsGetIamPolicy_580764 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsGetIamPolicy_580766(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsGetIamPolicy_580765(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns an IAM policy for the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580767 = path.getOrDefault("bucket")
  valid_580767 = validateParameter(valid_580767, JString, required = true,
                                 default = nil)
  if valid_580767 != nil:
    section.add "bucket", valid_580767
  var valid_580768 = path.getOrDefault("object")
  valid_580768 = validateParameter(valid_580768, JString, required = true,
                                 default = nil)
  if valid_580768 != nil:
    section.add "object", valid_580768
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580769 = query.getOrDefault("fields")
  valid_580769 = validateParameter(valid_580769, JString, required = false,
                                 default = nil)
  if valid_580769 != nil:
    section.add "fields", valid_580769
  var valid_580770 = query.getOrDefault("quotaUser")
  valid_580770 = validateParameter(valid_580770, JString, required = false,
                                 default = nil)
  if valid_580770 != nil:
    section.add "quotaUser", valid_580770
  var valid_580771 = query.getOrDefault("alt")
  valid_580771 = validateParameter(valid_580771, JString, required = false,
                                 default = newJString("json"))
  if valid_580771 != nil:
    section.add "alt", valid_580771
  var valid_580772 = query.getOrDefault("oauth_token")
  valid_580772 = validateParameter(valid_580772, JString, required = false,
                                 default = nil)
  if valid_580772 != nil:
    section.add "oauth_token", valid_580772
  var valid_580773 = query.getOrDefault("userIp")
  valid_580773 = validateParameter(valid_580773, JString, required = false,
                                 default = nil)
  if valid_580773 != nil:
    section.add "userIp", valid_580773
  var valid_580774 = query.getOrDefault("userProject")
  valid_580774 = validateParameter(valid_580774, JString, required = false,
                                 default = nil)
  if valid_580774 != nil:
    section.add "userProject", valid_580774
  var valid_580775 = query.getOrDefault("key")
  valid_580775 = validateParameter(valid_580775, JString, required = false,
                                 default = nil)
  if valid_580775 != nil:
    section.add "key", valid_580775
  var valid_580776 = query.getOrDefault("generation")
  valid_580776 = validateParameter(valid_580776, JString, required = false,
                                 default = nil)
  if valid_580776 != nil:
    section.add "generation", valid_580776
  var valid_580777 = query.getOrDefault("prettyPrint")
  valid_580777 = validateParameter(valid_580777, JBool, required = false,
                                 default = newJBool(true))
  if valid_580777 != nil:
    section.add "prettyPrint", valid_580777
  var valid_580778 = query.getOrDefault("provisionalUserProject")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = nil)
  if valid_580778 != nil:
    section.add "provisionalUserProject", valid_580778
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580779: Call_StorageObjectsGetIamPolicy_580764; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an IAM policy for the specified object.
  ## 
  let valid = call_580779.validator(path, query, header, formData, body)
  let scheme = call_580779.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580779.url(scheme.get, call_580779.host, call_580779.base,
                         call_580779.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580779, url, valid)

proc call*(call_580780: Call_StorageObjectsGetIamPolicy_580764; bucket: string;
          `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; generation: string = "";
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageObjectsGetIamPolicy
  ## Returns an IAM policy for the specified object.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580781 = newJObject()
  var query_580782 = newJObject()
  add(path_580781, "bucket", newJString(bucket))
  add(query_580782, "fields", newJString(fields))
  add(query_580782, "quotaUser", newJString(quotaUser))
  add(query_580782, "alt", newJString(alt))
  add(query_580782, "oauth_token", newJString(oauthToken))
  add(query_580782, "userIp", newJString(userIp))
  add(query_580782, "userProject", newJString(userProject))
  add(query_580782, "key", newJString(key))
  add(query_580782, "generation", newJString(generation))
  add(query_580782, "prettyPrint", newJBool(prettyPrint))
  add(path_580781, "object", newJString(`object`))
  add(query_580782, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580780.call(path_580781, query_580782, nil, nil, nil)

var storageObjectsGetIamPolicy* = Call_StorageObjectsGetIamPolicy_580764(
    name: "storageObjectsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/iam",
    validator: validate_StorageObjectsGetIamPolicy_580765, base: "/storage/v1",
    url: url_StorageObjectsGetIamPolicy_580766, schemes: {Scheme.Https})
type
  Call_StorageObjectsTestIamPermissions_580804 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsTestIamPermissions_580806(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/iam/testPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsTestIamPermissions_580805(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Tests a set of permissions on the given object to see which, if any, are held by the caller.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580807 = path.getOrDefault("bucket")
  valid_580807 = validateParameter(valid_580807, JString, required = true,
                                 default = nil)
  if valid_580807 != nil:
    section.add "bucket", valid_580807
  var valid_580808 = path.getOrDefault("object")
  valid_580808 = validateParameter(valid_580808, JString, required = true,
                                 default = nil)
  if valid_580808 != nil:
    section.add "object", valid_580808
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   permissions: JArray (required)
  ##              : Permissions to test.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580809 = query.getOrDefault("fields")
  valid_580809 = validateParameter(valid_580809, JString, required = false,
                                 default = nil)
  if valid_580809 != nil:
    section.add "fields", valid_580809
  var valid_580810 = query.getOrDefault("quotaUser")
  valid_580810 = validateParameter(valid_580810, JString, required = false,
                                 default = nil)
  if valid_580810 != nil:
    section.add "quotaUser", valid_580810
  assert query != nil,
        "query argument is necessary due to required `permissions` field"
  var valid_580811 = query.getOrDefault("permissions")
  valid_580811 = validateParameter(valid_580811, JArray, required = true, default = nil)
  if valid_580811 != nil:
    section.add "permissions", valid_580811
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
  var valid_580815 = query.getOrDefault("userProject")
  valid_580815 = validateParameter(valid_580815, JString, required = false,
                                 default = nil)
  if valid_580815 != nil:
    section.add "userProject", valid_580815
  var valid_580816 = query.getOrDefault("key")
  valid_580816 = validateParameter(valid_580816, JString, required = false,
                                 default = nil)
  if valid_580816 != nil:
    section.add "key", valid_580816
  var valid_580817 = query.getOrDefault("generation")
  valid_580817 = validateParameter(valid_580817, JString, required = false,
                                 default = nil)
  if valid_580817 != nil:
    section.add "generation", valid_580817
  var valid_580818 = query.getOrDefault("prettyPrint")
  valid_580818 = validateParameter(valid_580818, JBool, required = false,
                                 default = newJBool(true))
  if valid_580818 != nil:
    section.add "prettyPrint", valid_580818
  var valid_580819 = query.getOrDefault("provisionalUserProject")
  valid_580819 = validateParameter(valid_580819, JString, required = false,
                                 default = nil)
  if valid_580819 != nil:
    section.add "provisionalUserProject", valid_580819
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580820: Call_StorageObjectsTestIamPermissions_580804;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests a set of permissions on the given object to see which, if any, are held by the caller.
  ## 
  let valid = call_580820.validator(path, query, header, formData, body)
  let scheme = call_580820.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580820.url(scheme.get, call_580820.host, call_580820.base,
                         call_580820.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580820, url, valid)

proc call*(call_580821: Call_StorageObjectsTestIamPermissions_580804;
          bucket: string; permissions: JsonNode; `object`: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; userProject: string = "";
          key: string = ""; generation: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageObjectsTestIamPermissions
  ## Tests a set of permissions on the given object to see which, if any, are held by the caller.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   permissions: JArray (required)
  ##              : Permissions to test.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580822 = newJObject()
  var query_580823 = newJObject()
  add(path_580822, "bucket", newJString(bucket))
  add(query_580823, "fields", newJString(fields))
  add(query_580823, "quotaUser", newJString(quotaUser))
  if permissions != nil:
    query_580823.add "permissions", permissions
  add(query_580823, "alt", newJString(alt))
  add(query_580823, "oauth_token", newJString(oauthToken))
  add(query_580823, "userIp", newJString(userIp))
  add(query_580823, "userProject", newJString(userProject))
  add(query_580823, "key", newJString(key))
  add(query_580823, "generation", newJString(generation))
  add(query_580823, "prettyPrint", newJBool(prettyPrint))
  add(path_580822, "object", newJString(`object`))
  add(query_580823, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580821.call(path_580822, query_580823, nil, nil, nil)

var storageObjectsTestIamPermissions* = Call_StorageObjectsTestIamPermissions_580804(
    name: "storageObjectsTestIamPermissions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/b/{bucket}/o/{object}/iam/testPermissions",
    validator: validate_StorageObjectsTestIamPermissions_580805,
    base: "/storage/v1", url: url_StorageObjectsTestIamPermissions_580806,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsCompose_580824 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsCompose_580826(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "destinationBucket" in path,
        "`destinationBucket` is a required path parameter"
  assert "destinationObject" in path,
        "`destinationObject` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "destinationBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "destinationObject"),
               (kind: ConstantSegment, value: "/compose")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsCompose_580825(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket containing the source objects. The destination object is stored in this bucket.
  ##   destinationObject: JString (required)
  ##                    : Name of the new object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationBucket` field"
  var valid_580827 = path.getOrDefault("destinationBucket")
  valid_580827 = validateParameter(valid_580827, JString, required = true,
                                 default = nil)
  if valid_580827 != nil:
    section.add "destinationBucket", valid_580827
  var valid_580828 = path.getOrDefault("destinationObject")
  valid_580828 = validateParameter(valid_580828, JString, required = true,
                                 default = nil)
  if valid_580828 != nil:
    section.add "destinationObject", valid_580828
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   kmsKeyName: JString
  ##             : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   destinationPredefinedAcl: JString
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580829 = query.getOrDefault("ifGenerationMatch")
  valid_580829 = validateParameter(valid_580829, JString, required = false,
                                 default = nil)
  if valid_580829 != nil:
    section.add "ifGenerationMatch", valid_580829
  var valid_580830 = query.getOrDefault("kmsKeyName")
  valid_580830 = validateParameter(valid_580830, JString, required = false,
                                 default = nil)
  if valid_580830 != nil:
    section.add "kmsKeyName", valid_580830
  var valid_580831 = query.getOrDefault("fields")
  valid_580831 = validateParameter(valid_580831, JString, required = false,
                                 default = nil)
  if valid_580831 != nil:
    section.add "fields", valid_580831
  var valid_580832 = query.getOrDefault("quotaUser")
  valid_580832 = validateParameter(valid_580832, JString, required = false,
                                 default = nil)
  if valid_580832 != nil:
    section.add "quotaUser", valid_580832
  var valid_580833 = query.getOrDefault("alt")
  valid_580833 = validateParameter(valid_580833, JString, required = false,
                                 default = newJString("json"))
  if valid_580833 != nil:
    section.add "alt", valid_580833
  var valid_580834 = query.getOrDefault("oauth_token")
  valid_580834 = validateParameter(valid_580834, JString, required = false,
                                 default = nil)
  if valid_580834 != nil:
    section.add "oauth_token", valid_580834
  var valid_580835 = query.getOrDefault("userIp")
  valid_580835 = validateParameter(valid_580835, JString, required = false,
                                 default = nil)
  if valid_580835 != nil:
    section.add "userIp", valid_580835
  var valid_580836 = query.getOrDefault("userProject")
  valid_580836 = validateParameter(valid_580836, JString, required = false,
                                 default = nil)
  if valid_580836 != nil:
    section.add "userProject", valid_580836
  var valid_580837 = query.getOrDefault("key")
  valid_580837 = validateParameter(valid_580837, JString, required = false,
                                 default = nil)
  if valid_580837 != nil:
    section.add "key", valid_580837
  var valid_580838 = query.getOrDefault("destinationPredefinedAcl")
  valid_580838 = validateParameter(valid_580838, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580838 != nil:
    section.add "destinationPredefinedAcl", valid_580838
  var valid_580839 = query.getOrDefault("ifMetagenerationMatch")
  valid_580839 = validateParameter(valid_580839, JString, required = false,
                                 default = nil)
  if valid_580839 != nil:
    section.add "ifMetagenerationMatch", valid_580839
  var valid_580840 = query.getOrDefault("prettyPrint")
  valid_580840 = validateParameter(valid_580840, JBool, required = false,
                                 default = newJBool(true))
  if valid_580840 != nil:
    section.add "prettyPrint", valid_580840
  var valid_580841 = query.getOrDefault("provisionalUserProject")
  valid_580841 = validateParameter(valid_580841, JString, required = false,
                                 default = nil)
  if valid_580841 != nil:
    section.add "provisionalUserProject", valid_580841
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

proc call*(call_580843: Call_StorageObjectsCompose_580824; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ## 
  let valid = call_580843.validator(path, query, header, formData, body)
  let scheme = call_580843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580843.url(scheme.get, call_580843.host, call_580843.base,
                         call_580843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580843, url, valid)

proc call*(call_580844: Call_StorageObjectsCompose_580824;
          destinationBucket: string; destinationObject: string;
          ifGenerationMatch: string = ""; kmsKeyName: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          destinationPredefinedAcl: string = "authenticatedRead";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageObjectsCompose
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   kmsKeyName: string
  ##             : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   destinationBucket: string (required)
  ##                    : Name of the bucket containing the source objects. The destination object is stored in this bucket.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   destinationObject: string (required)
  ##                    : Name of the new object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   destinationPredefinedAcl: string
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580845 = newJObject()
  var query_580846 = newJObject()
  var body_580847 = newJObject()
  add(query_580846, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580846, "kmsKeyName", newJString(kmsKeyName))
  add(query_580846, "fields", newJString(fields))
  add(query_580846, "quotaUser", newJString(quotaUser))
  add(query_580846, "alt", newJString(alt))
  add(query_580846, "oauth_token", newJString(oauthToken))
  add(path_580845, "destinationBucket", newJString(destinationBucket))
  add(query_580846, "userIp", newJString(userIp))
  add(path_580845, "destinationObject", newJString(destinationObject))
  add(query_580846, "userProject", newJString(userProject))
  add(query_580846, "key", newJString(key))
  add(query_580846, "destinationPredefinedAcl",
      newJString(destinationPredefinedAcl))
  add(query_580846, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_580847 = body
  add(query_580846, "prettyPrint", newJBool(prettyPrint))
  add(query_580846, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580844.call(path_580845, query_580846, nil, nil, body_580847)

var storageObjectsCompose* = Call_StorageObjectsCompose_580824(
    name: "storageObjectsCompose", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/b/{destinationBucket}/o/{destinationObject}/compose",
    validator: validate_StorageObjectsCompose_580825, base: "/storage/v1",
    url: url_StorageObjectsCompose_580826, schemes: {Scheme.Https})
type
  Call_StorageObjectsCopy_580848 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsCopy_580850(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "sourceBucket" in path, "`sourceBucket` is a required path parameter"
  assert "sourceObject" in path, "`sourceObject` is a required path parameter"
  assert "destinationBucket" in path,
        "`destinationBucket` is a required path parameter"
  assert "destinationObject" in path,
        "`destinationObject` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "sourceBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "sourceObject"),
               (kind: ConstantSegment, value: "/copyTo/b/"),
               (kind: VariableSegment, value: "destinationBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "destinationObject")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsCopy_580849(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Copies a source object to a destination object. Optionally overrides metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   destinationObject: JString (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   sourceBucket: JString (required)
  ##               : Name of the bucket in which to find the source object.
  ##   sourceObject: JString (required)
  ##               : Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationBucket` field"
  var valid_580851 = path.getOrDefault("destinationBucket")
  valid_580851 = validateParameter(valid_580851, JString, required = true,
                                 default = nil)
  if valid_580851 != nil:
    section.add "destinationBucket", valid_580851
  var valid_580852 = path.getOrDefault("destinationObject")
  valid_580852 = validateParameter(valid_580852, JString, required = true,
                                 default = nil)
  if valid_580852 != nil:
    section.add "destinationObject", valid_580852
  var valid_580853 = path.getOrDefault("sourceBucket")
  valid_580853 = validateParameter(valid_580853, JString, required = true,
                                 default = nil)
  if valid_580853 != nil:
    section.add "sourceBucket", valid_580853
  var valid_580854 = path.getOrDefault("sourceObject")
  valid_580854 = validateParameter(valid_580854, JString, required = true,
                                 default = nil)
  if valid_580854 != nil:
    section.add "sourceObject", valid_580854
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the destination object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifSourceGenerationMatch: JString
  ##                          : Makes the operation conditional on whether the source object's current generation matches the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifSourceMetagenerationNotMatch: JString
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the destination object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   ifSourceMetagenerationMatch: JString
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sourceGeneration: JString
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   destinationPredefinedAcl: JString
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   ifSourceGenerationNotMatch: JString
  ##                             : Makes the operation conditional on whether the source object's current generation does not match the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580855 = query.getOrDefault("ifGenerationMatch")
  valid_580855 = validateParameter(valid_580855, JString, required = false,
                                 default = nil)
  if valid_580855 != nil:
    section.add "ifGenerationMatch", valid_580855
  var valid_580856 = query.getOrDefault("ifSourceGenerationMatch")
  valid_580856 = validateParameter(valid_580856, JString, required = false,
                                 default = nil)
  if valid_580856 != nil:
    section.add "ifSourceGenerationMatch", valid_580856
  var valid_580857 = query.getOrDefault("fields")
  valid_580857 = validateParameter(valid_580857, JString, required = false,
                                 default = nil)
  if valid_580857 != nil:
    section.add "fields", valid_580857
  var valid_580858 = query.getOrDefault("quotaUser")
  valid_580858 = validateParameter(valid_580858, JString, required = false,
                                 default = nil)
  if valid_580858 != nil:
    section.add "quotaUser", valid_580858
  var valid_580859 = query.getOrDefault("alt")
  valid_580859 = validateParameter(valid_580859, JString, required = false,
                                 default = newJString("json"))
  if valid_580859 != nil:
    section.add "alt", valid_580859
  var valid_580860 = query.getOrDefault("ifSourceMetagenerationNotMatch")
  valid_580860 = validateParameter(valid_580860, JString, required = false,
                                 default = nil)
  if valid_580860 != nil:
    section.add "ifSourceMetagenerationNotMatch", valid_580860
  var valid_580861 = query.getOrDefault("ifGenerationNotMatch")
  valid_580861 = validateParameter(valid_580861, JString, required = false,
                                 default = nil)
  if valid_580861 != nil:
    section.add "ifGenerationNotMatch", valid_580861
  var valid_580862 = query.getOrDefault("ifSourceMetagenerationMatch")
  valid_580862 = validateParameter(valid_580862, JString, required = false,
                                 default = nil)
  if valid_580862 != nil:
    section.add "ifSourceMetagenerationMatch", valid_580862
  var valid_580863 = query.getOrDefault("oauth_token")
  valid_580863 = validateParameter(valid_580863, JString, required = false,
                                 default = nil)
  if valid_580863 != nil:
    section.add "oauth_token", valid_580863
  var valid_580864 = query.getOrDefault("sourceGeneration")
  valid_580864 = validateParameter(valid_580864, JString, required = false,
                                 default = nil)
  if valid_580864 != nil:
    section.add "sourceGeneration", valid_580864
  var valid_580865 = query.getOrDefault("userIp")
  valid_580865 = validateParameter(valid_580865, JString, required = false,
                                 default = nil)
  if valid_580865 != nil:
    section.add "userIp", valid_580865
  var valid_580866 = query.getOrDefault("userProject")
  valid_580866 = validateParameter(valid_580866, JString, required = false,
                                 default = nil)
  if valid_580866 != nil:
    section.add "userProject", valid_580866
  var valid_580867 = query.getOrDefault("key")
  valid_580867 = validateParameter(valid_580867, JString, required = false,
                                 default = nil)
  if valid_580867 != nil:
    section.add "key", valid_580867
  var valid_580868 = query.getOrDefault("projection")
  valid_580868 = validateParameter(valid_580868, JString, required = false,
                                 default = newJString("full"))
  if valid_580868 != nil:
    section.add "projection", valid_580868
  var valid_580869 = query.getOrDefault("destinationPredefinedAcl")
  valid_580869 = validateParameter(valid_580869, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580869 != nil:
    section.add "destinationPredefinedAcl", valid_580869
  var valid_580870 = query.getOrDefault("ifMetagenerationMatch")
  valid_580870 = validateParameter(valid_580870, JString, required = false,
                                 default = nil)
  if valid_580870 != nil:
    section.add "ifMetagenerationMatch", valid_580870
  var valid_580871 = query.getOrDefault("ifSourceGenerationNotMatch")
  valid_580871 = validateParameter(valid_580871, JString, required = false,
                                 default = nil)
  if valid_580871 != nil:
    section.add "ifSourceGenerationNotMatch", valid_580871
  var valid_580872 = query.getOrDefault("prettyPrint")
  valid_580872 = validateParameter(valid_580872, JBool, required = false,
                                 default = newJBool(true))
  if valid_580872 != nil:
    section.add "prettyPrint", valid_580872
  var valid_580873 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580873 = validateParameter(valid_580873, JString, required = false,
                                 default = nil)
  if valid_580873 != nil:
    section.add "ifMetagenerationNotMatch", valid_580873
  var valid_580874 = query.getOrDefault("provisionalUserProject")
  valid_580874 = validateParameter(valid_580874, JString, required = false,
                                 default = nil)
  if valid_580874 != nil:
    section.add "provisionalUserProject", valid_580874
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

proc call*(call_580876: Call_StorageObjectsCopy_580848; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies a source object to a destination object. Optionally overrides metadata.
  ## 
  let valid = call_580876.validator(path, query, header, formData, body)
  let scheme = call_580876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580876.url(scheme.get, call_580876.host, call_580876.base,
                         call_580876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580876, url, valid)

proc call*(call_580877: Call_StorageObjectsCopy_580848; destinationBucket: string;
          destinationObject: string; sourceBucket: string; sourceObject: string;
          ifGenerationMatch: string = ""; ifSourceGenerationMatch: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          ifSourceMetagenerationNotMatch: string = "";
          ifGenerationNotMatch: string = "";
          ifSourceMetagenerationMatch: string = ""; oauthToken: string = "";
          sourceGeneration: string = ""; userIp: string = ""; userProject: string = "";
          key: string = ""; projection: string = "full";
          destinationPredefinedAcl: string = "authenticatedRead";
          ifMetagenerationMatch: string = "";
          ifSourceGenerationNotMatch: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; ifMetagenerationNotMatch: string = "";
          provisionalUserProject: string = ""): Recallable =
  ## storageObjectsCopy
  ## Copies a source object to a destination object. Optionally overrides metadata.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the destination object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifSourceGenerationMatch: string
  ##                          : Makes the operation conditional on whether the source object's current generation matches the given value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifSourceMetagenerationNotMatch: string
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the destination object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   ifSourceMetagenerationMatch: string
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sourceGeneration: string
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   destinationBucket: string (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   destinationObject: string (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   sourceBucket: string (required)
  ##               : Name of the bucket in which to find the source object.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   sourceObject: string (required)
  ##               : Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   destinationPredefinedAcl: string
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   ifSourceGenerationNotMatch: string
  ##                             : Makes the operation conditional on whether the source object's current generation does not match the given value.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580878 = newJObject()
  var query_580879 = newJObject()
  var body_580880 = newJObject()
  add(query_580879, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580879, "ifSourceGenerationMatch", newJString(ifSourceGenerationMatch))
  add(query_580879, "fields", newJString(fields))
  add(query_580879, "quotaUser", newJString(quotaUser))
  add(query_580879, "alt", newJString(alt))
  add(query_580879, "ifSourceMetagenerationNotMatch",
      newJString(ifSourceMetagenerationNotMatch))
  add(query_580879, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580879, "ifSourceMetagenerationMatch",
      newJString(ifSourceMetagenerationMatch))
  add(query_580879, "oauth_token", newJString(oauthToken))
  add(query_580879, "sourceGeneration", newJString(sourceGeneration))
  add(path_580878, "destinationBucket", newJString(destinationBucket))
  add(query_580879, "userIp", newJString(userIp))
  add(path_580878, "destinationObject", newJString(destinationObject))
  add(path_580878, "sourceBucket", newJString(sourceBucket))
  add(query_580879, "userProject", newJString(userProject))
  add(query_580879, "key", newJString(key))
  add(path_580878, "sourceObject", newJString(sourceObject))
  add(query_580879, "projection", newJString(projection))
  add(query_580879, "destinationPredefinedAcl",
      newJString(destinationPredefinedAcl))
  add(query_580879, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580879, "ifSourceGenerationNotMatch",
      newJString(ifSourceGenerationNotMatch))
  if body != nil:
    body_580880 = body
  add(query_580879, "prettyPrint", newJBool(prettyPrint))
  add(query_580879, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580879, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580877.call(path_580878, query_580879, nil, nil, body_580880)

var storageObjectsCopy* = Call_StorageObjectsCopy_580848(
    name: "storageObjectsCopy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{sourceBucket}/o/{sourceObject}/copyTo/b/{destinationBucket}/o/{destinationObject}",
    validator: validate_StorageObjectsCopy_580849, base: "/storage/v1",
    url: url_StorageObjectsCopy_580850, schemes: {Scheme.Https})
type
  Call_StorageObjectsRewrite_580881 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsRewrite_580883(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "sourceBucket" in path, "`sourceBucket` is a required path parameter"
  assert "sourceObject" in path, "`sourceObject` is a required path parameter"
  assert "destinationBucket" in path,
        "`destinationBucket` is a required path parameter"
  assert "destinationObject" in path,
        "`destinationObject` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "sourceBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "sourceObject"),
               (kind: ConstantSegment, value: "/rewriteTo/b/"),
               (kind: VariableSegment, value: "destinationBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "destinationObject")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsRewrite_580882(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rewrites a source object to a destination object. Optionally overrides metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   destinationObject: JString (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   sourceBucket: JString (required)
  ##               : Name of the bucket in which to find the source object.
  ##   sourceObject: JString (required)
  ##               : Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationBucket` field"
  var valid_580884 = path.getOrDefault("destinationBucket")
  valid_580884 = validateParameter(valid_580884, JString, required = true,
                                 default = nil)
  if valid_580884 != nil:
    section.add "destinationBucket", valid_580884
  var valid_580885 = path.getOrDefault("destinationObject")
  valid_580885 = validateParameter(valid_580885, JString, required = true,
                                 default = nil)
  if valid_580885 != nil:
    section.add "destinationObject", valid_580885
  var valid_580886 = path.getOrDefault("sourceBucket")
  valid_580886 = validateParameter(valid_580886, JString, required = true,
                                 default = nil)
  if valid_580886 != nil:
    section.add "sourceBucket", valid_580886
  var valid_580887 = path.getOrDefault("sourceObject")
  valid_580887 = validateParameter(valid_580887, JString, required = true,
                                 default = nil)
  if valid_580887 != nil:
    section.add "sourceObject", valid_580887
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifSourceGenerationMatch: JString
  ##                          : Makes the operation conditional on whether the source object's current generation matches the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifSourceMetagenerationNotMatch: JString
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   ifSourceMetagenerationMatch: JString
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sourceGeneration: JString
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   destinationKmsKeyName: JString
  ##                        : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   destinationPredefinedAcl: JString
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   ifSourceGenerationNotMatch: JString
  ##                             : Makes the operation conditional on whether the source object's current generation does not match the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   rewriteToken: JString
  ##               : Include this field (from the previous rewrite response) on each rewrite request after the first one, until the rewrite response 'done' flag is true. Calls that provide a rewriteToken can omit all other request fields, but if included those fields must match the values provided in the first rewrite request.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   maxBytesRewrittenPerCall: JString
  ##                           : The maximum number of bytes that will be rewritten per rewrite request. Most callers shouldn't need to specify this parameter - it is primarily in place to support testing. If specified the value must be an integral multiple of 1 MiB (1048576). Also, this only applies to requests where the source and destination span locations and/or storage classes. Finally, this value must not change across rewrite calls else you'll get an error that the rewriteToken is invalid.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_580888 = query.getOrDefault("ifGenerationMatch")
  valid_580888 = validateParameter(valid_580888, JString, required = false,
                                 default = nil)
  if valid_580888 != nil:
    section.add "ifGenerationMatch", valid_580888
  var valid_580889 = query.getOrDefault("ifSourceGenerationMatch")
  valid_580889 = validateParameter(valid_580889, JString, required = false,
                                 default = nil)
  if valid_580889 != nil:
    section.add "ifSourceGenerationMatch", valid_580889
  var valid_580890 = query.getOrDefault("fields")
  valid_580890 = validateParameter(valid_580890, JString, required = false,
                                 default = nil)
  if valid_580890 != nil:
    section.add "fields", valid_580890
  var valid_580891 = query.getOrDefault("quotaUser")
  valid_580891 = validateParameter(valid_580891, JString, required = false,
                                 default = nil)
  if valid_580891 != nil:
    section.add "quotaUser", valid_580891
  var valid_580892 = query.getOrDefault("alt")
  valid_580892 = validateParameter(valid_580892, JString, required = false,
                                 default = newJString("json"))
  if valid_580892 != nil:
    section.add "alt", valid_580892
  var valid_580893 = query.getOrDefault("ifSourceMetagenerationNotMatch")
  valid_580893 = validateParameter(valid_580893, JString, required = false,
                                 default = nil)
  if valid_580893 != nil:
    section.add "ifSourceMetagenerationNotMatch", valid_580893
  var valid_580894 = query.getOrDefault("ifGenerationNotMatch")
  valid_580894 = validateParameter(valid_580894, JString, required = false,
                                 default = nil)
  if valid_580894 != nil:
    section.add "ifGenerationNotMatch", valid_580894
  var valid_580895 = query.getOrDefault("ifSourceMetagenerationMatch")
  valid_580895 = validateParameter(valid_580895, JString, required = false,
                                 default = nil)
  if valid_580895 != nil:
    section.add "ifSourceMetagenerationMatch", valid_580895
  var valid_580896 = query.getOrDefault("oauth_token")
  valid_580896 = validateParameter(valid_580896, JString, required = false,
                                 default = nil)
  if valid_580896 != nil:
    section.add "oauth_token", valid_580896
  var valid_580897 = query.getOrDefault("sourceGeneration")
  valid_580897 = validateParameter(valid_580897, JString, required = false,
                                 default = nil)
  if valid_580897 != nil:
    section.add "sourceGeneration", valid_580897
  var valid_580898 = query.getOrDefault("userIp")
  valid_580898 = validateParameter(valid_580898, JString, required = false,
                                 default = nil)
  if valid_580898 != nil:
    section.add "userIp", valid_580898
  var valid_580899 = query.getOrDefault("destinationKmsKeyName")
  valid_580899 = validateParameter(valid_580899, JString, required = false,
                                 default = nil)
  if valid_580899 != nil:
    section.add "destinationKmsKeyName", valid_580899
  var valid_580900 = query.getOrDefault("userProject")
  valid_580900 = validateParameter(valid_580900, JString, required = false,
                                 default = nil)
  if valid_580900 != nil:
    section.add "userProject", valid_580900
  var valid_580901 = query.getOrDefault("key")
  valid_580901 = validateParameter(valid_580901, JString, required = false,
                                 default = nil)
  if valid_580901 != nil:
    section.add "key", valid_580901
  var valid_580902 = query.getOrDefault("projection")
  valid_580902 = validateParameter(valid_580902, JString, required = false,
                                 default = newJString("full"))
  if valid_580902 != nil:
    section.add "projection", valid_580902
  var valid_580903 = query.getOrDefault("destinationPredefinedAcl")
  valid_580903 = validateParameter(valid_580903, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_580903 != nil:
    section.add "destinationPredefinedAcl", valid_580903
  var valid_580904 = query.getOrDefault("ifMetagenerationMatch")
  valid_580904 = validateParameter(valid_580904, JString, required = false,
                                 default = nil)
  if valid_580904 != nil:
    section.add "ifMetagenerationMatch", valid_580904
  var valid_580905 = query.getOrDefault("ifSourceGenerationNotMatch")
  valid_580905 = validateParameter(valid_580905, JString, required = false,
                                 default = nil)
  if valid_580905 != nil:
    section.add "ifSourceGenerationNotMatch", valid_580905
  var valid_580906 = query.getOrDefault("prettyPrint")
  valid_580906 = validateParameter(valid_580906, JBool, required = false,
                                 default = newJBool(true))
  if valid_580906 != nil:
    section.add "prettyPrint", valid_580906
  var valid_580907 = query.getOrDefault("rewriteToken")
  valid_580907 = validateParameter(valid_580907, JString, required = false,
                                 default = nil)
  if valid_580907 != nil:
    section.add "rewriteToken", valid_580907
  var valid_580908 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580908 = validateParameter(valid_580908, JString, required = false,
                                 default = nil)
  if valid_580908 != nil:
    section.add "ifMetagenerationNotMatch", valid_580908
  var valid_580909 = query.getOrDefault("maxBytesRewrittenPerCall")
  valid_580909 = validateParameter(valid_580909, JString, required = false,
                                 default = nil)
  if valid_580909 != nil:
    section.add "maxBytesRewrittenPerCall", valid_580909
  var valid_580910 = query.getOrDefault("provisionalUserProject")
  valid_580910 = validateParameter(valid_580910, JString, required = false,
                                 default = nil)
  if valid_580910 != nil:
    section.add "provisionalUserProject", valid_580910
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

proc call*(call_580912: Call_StorageObjectsRewrite_580881; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rewrites a source object to a destination object. Optionally overrides metadata.
  ## 
  let valid = call_580912.validator(path, query, header, formData, body)
  let scheme = call_580912.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580912.url(scheme.get, call_580912.host, call_580912.base,
                         call_580912.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580912, url, valid)

proc call*(call_580913: Call_StorageObjectsRewrite_580881;
          destinationBucket: string; destinationObject: string;
          sourceBucket: string; sourceObject: string;
          ifGenerationMatch: string = ""; ifSourceGenerationMatch: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          ifSourceMetagenerationNotMatch: string = "";
          ifGenerationNotMatch: string = "";
          ifSourceMetagenerationMatch: string = ""; oauthToken: string = "";
          sourceGeneration: string = ""; userIp: string = "";
          destinationKmsKeyName: string = ""; userProject: string = "";
          key: string = ""; projection: string = "full";
          destinationPredefinedAcl: string = "authenticatedRead";
          ifMetagenerationMatch: string = "";
          ifSourceGenerationNotMatch: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; rewriteToken: string = "";
          ifMetagenerationNotMatch: string = "";
          maxBytesRewrittenPerCall: string = ""; provisionalUserProject: string = ""): Recallable =
  ## storageObjectsRewrite
  ## Rewrites a source object to a destination object. Optionally overrides metadata.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifSourceGenerationMatch: string
  ##                          : Makes the operation conditional on whether the source object's current generation matches the given value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifSourceMetagenerationNotMatch: string
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   ifSourceMetagenerationMatch: string
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sourceGeneration: string
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   destinationBucket: string (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   destinationKmsKeyName: string
  ##                        : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  ##   destinationObject: string (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   sourceBucket: string (required)
  ##               : Name of the bucket in which to find the source object.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   sourceObject: string (required)
  ##               : Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   destinationPredefinedAcl: string
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   ifSourceGenerationNotMatch: string
  ##                             : Makes the operation conditional on whether the source object's current generation does not match the given value.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   rewriteToken: string
  ##               : Include this field (from the previous rewrite response) on each rewrite request after the first one, until the rewrite response 'done' flag is true. Calls that provide a rewriteToken can omit all other request fields, but if included those fields must match the values provided in the first rewrite request.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   maxBytesRewrittenPerCall: string
  ##                           : The maximum number of bytes that will be rewritten per rewrite request. Most callers shouldn't need to specify this parameter - it is primarily in place to support testing. If specified the value must be an integral multiple of 1 MiB (1048576). Also, this only applies to requests where the source and destination span locations and/or storage classes. Finally, this value must not change across rewrite calls else you'll get an error that the rewriteToken is invalid.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_580914 = newJObject()
  var query_580915 = newJObject()
  var body_580916 = newJObject()
  add(query_580915, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580915, "ifSourceGenerationMatch", newJString(ifSourceGenerationMatch))
  add(query_580915, "fields", newJString(fields))
  add(query_580915, "quotaUser", newJString(quotaUser))
  add(query_580915, "alt", newJString(alt))
  add(query_580915, "ifSourceMetagenerationNotMatch",
      newJString(ifSourceMetagenerationNotMatch))
  add(query_580915, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580915, "ifSourceMetagenerationMatch",
      newJString(ifSourceMetagenerationMatch))
  add(query_580915, "oauth_token", newJString(oauthToken))
  add(query_580915, "sourceGeneration", newJString(sourceGeneration))
  add(path_580914, "destinationBucket", newJString(destinationBucket))
  add(query_580915, "userIp", newJString(userIp))
  add(query_580915, "destinationKmsKeyName", newJString(destinationKmsKeyName))
  add(path_580914, "destinationObject", newJString(destinationObject))
  add(path_580914, "sourceBucket", newJString(sourceBucket))
  add(query_580915, "userProject", newJString(userProject))
  add(query_580915, "key", newJString(key))
  add(path_580914, "sourceObject", newJString(sourceObject))
  add(query_580915, "projection", newJString(projection))
  add(query_580915, "destinationPredefinedAcl",
      newJString(destinationPredefinedAcl))
  add(query_580915, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580915, "ifSourceGenerationNotMatch",
      newJString(ifSourceGenerationNotMatch))
  if body != nil:
    body_580916 = body
  add(query_580915, "prettyPrint", newJBool(prettyPrint))
  add(query_580915, "rewriteToken", newJString(rewriteToken))
  add(query_580915, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580915, "maxBytesRewrittenPerCall",
      newJString(maxBytesRewrittenPerCall))
  add(query_580915, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_580913.call(path_580914, query_580915, nil, nil, body_580916)

var storageObjectsRewrite* = Call_StorageObjectsRewrite_580881(
    name: "storageObjectsRewrite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{sourceBucket}/o/{sourceObject}/rewriteTo/b/{destinationBucket}/o/{destinationObject}",
    validator: validate_StorageObjectsRewrite_580882, base: "/storage/v1",
    url: url_StorageObjectsRewrite_580883, schemes: {Scheme.Https})
type
  Call_StorageChannelsStop_580917 = ref object of OpenApiRestCall_579424
proc url_StorageChannelsStop_580919(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StorageChannelsStop_580918(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Stop watching resources through this channel
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  var valid_580920 = query.getOrDefault("fields")
  valid_580920 = validateParameter(valid_580920, JString, required = false,
                                 default = nil)
  if valid_580920 != nil:
    section.add "fields", valid_580920
  var valid_580921 = query.getOrDefault("quotaUser")
  valid_580921 = validateParameter(valid_580921, JString, required = false,
                                 default = nil)
  if valid_580921 != nil:
    section.add "quotaUser", valid_580921
  var valid_580922 = query.getOrDefault("alt")
  valid_580922 = validateParameter(valid_580922, JString, required = false,
                                 default = newJString("json"))
  if valid_580922 != nil:
    section.add "alt", valid_580922
  var valid_580923 = query.getOrDefault("oauth_token")
  valid_580923 = validateParameter(valid_580923, JString, required = false,
                                 default = nil)
  if valid_580923 != nil:
    section.add "oauth_token", valid_580923
  var valid_580924 = query.getOrDefault("userIp")
  valid_580924 = validateParameter(valid_580924, JString, required = false,
                                 default = nil)
  if valid_580924 != nil:
    section.add "userIp", valid_580924
  var valid_580925 = query.getOrDefault("key")
  valid_580925 = validateParameter(valid_580925, JString, required = false,
                                 default = nil)
  if valid_580925 != nil:
    section.add "key", valid_580925
  var valid_580926 = query.getOrDefault("prettyPrint")
  valid_580926 = validateParameter(valid_580926, JBool, required = false,
                                 default = newJBool(true))
  if valid_580926 != nil:
    section.add "prettyPrint", valid_580926
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580928: Call_StorageChannelsStop_580917; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_580928.validator(path, query, header, formData, body)
  let scheme = call_580928.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580928.url(scheme.get, call_580928.host, call_580928.base,
                         call_580928.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580928, url, valid)

proc call*(call_580929: Call_StorageChannelsStop_580917; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; resource: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## storageChannelsStop
  ## Stop watching resources through this channel
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
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
  ##   resource: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580930 = newJObject()
  var body_580931 = newJObject()
  add(query_580930, "fields", newJString(fields))
  add(query_580930, "quotaUser", newJString(quotaUser))
  add(query_580930, "alt", newJString(alt))
  add(query_580930, "oauth_token", newJString(oauthToken))
  add(query_580930, "userIp", newJString(userIp))
  add(query_580930, "key", newJString(key))
  if resource != nil:
    body_580931 = resource
  add(query_580930, "prettyPrint", newJBool(prettyPrint))
  result = call_580929.call(nil, query_580930, nil, nil, body_580931)

var storageChannelsStop* = Call_StorageChannelsStop_580917(
    name: "storageChannelsStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_StorageChannelsStop_580918, base: "/storage/v1",
    url: url_StorageChannelsStop_580919, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysCreate_580952 = ref object of OpenApiRestCall_579424
proc url_StorageProjectsHmacKeysCreate_580954(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysCreate_580953(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new HMAC key for the specified service account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID owning the service account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580955 = path.getOrDefault("projectId")
  valid_580955 = validateParameter(valid_580955, JString, required = true,
                                 default = nil)
  if valid_580955 != nil:
    section.add "projectId", valid_580955
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
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceAccountEmail: JString (required)
  ##                      : Email address of the service account.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580956 = query.getOrDefault("fields")
  valid_580956 = validateParameter(valid_580956, JString, required = false,
                                 default = nil)
  if valid_580956 != nil:
    section.add "fields", valid_580956
  var valid_580957 = query.getOrDefault("quotaUser")
  valid_580957 = validateParameter(valid_580957, JString, required = false,
                                 default = nil)
  if valid_580957 != nil:
    section.add "quotaUser", valid_580957
  var valid_580958 = query.getOrDefault("alt")
  valid_580958 = validateParameter(valid_580958, JString, required = false,
                                 default = newJString("json"))
  if valid_580958 != nil:
    section.add "alt", valid_580958
  var valid_580959 = query.getOrDefault("oauth_token")
  valid_580959 = validateParameter(valid_580959, JString, required = false,
                                 default = nil)
  if valid_580959 != nil:
    section.add "oauth_token", valid_580959
  var valid_580960 = query.getOrDefault("userIp")
  valid_580960 = validateParameter(valid_580960, JString, required = false,
                                 default = nil)
  if valid_580960 != nil:
    section.add "userIp", valid_580960
  var valid_580961 = query.getOrDefault("userProject")
  valid_580961 = validateParameter(valid_580961, JString, required = false,
                                 default = nil)
  if valid_580961 != nil:
    section.add "userProject", valid_580961
  var valid_580962 = query.getOrDefault("key")
  valid_580962 = validateParameter(valid_580962, JString, required = false,
                                 default = nil)
  if valid_580962 != nil:
    section.add "key", valid_580962
  assert query != nil, "query argument is necessary due to required `serviceAccountEmail` field"
  var valid_580963 = query.getOrDefault("serviceAccountEmail")
  valid_580963 = validateParameter(valid_580963, JString, required = true,
                                 default = nil)
  if valid_580963 != nil:
    section.add "serviceAccountEmail", valid_580963
  var valid_580964 = query.getOrDefault("prettyPrint")
  valid_580964 = validateParameter(valid_580964, JBool, required = false,
                                 default = newJBool(true))
  if valid_580964 != nil:
    section.add "prettyPrint", valid_580964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580965: Call_StorageProjectsHmacKeysCreate_580952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new HMAC key for the specified service account.
  ## 
  let valid = call_580965.validator(path, query, header, formData, body)
  let scheme = call_580965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580965.url(scheme.get, call_580965.host, call_580965.base,
                         call_580965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580965, url, valid)

proc call*(call_580966: Call_StorageProjectsHmacKeysCreate_580952;
          serviceAccountEmail: string; projectId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## storageProjectsHmacKeysCreate
  ## Creates a new HMAC key for the specified service account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceAccountEmail: string (required)
  ##                      : Email address of the service account.
  ##   projectId: string (required)
  ##            : Project ID owning the service account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580967 = newJObject()
  var query_580968 = newJObject()
  add(query_580968, "fields", newJString(fields))
  add(query_580968, "quotaUser", newJString(quotaUser))
  add(query_580968, "alt", newJString(alt))
  add(query_580968, "oauth_token", newJString(oauthToken))
  add(query_580968, "userIp", newJString(userIp))
  add(query_580968, "userProject", newJString(userProject))
  add(query_580968, "key", newJString(key))
  add(query_580968, "serviceAccountEmail", newJString(serviceAccountEmail))
  add(path_580967, "projectId", newJString(projectId))
  add(query_580968, "prettyPrint", newJBool(prettyPrint))
  result = call_580966.call(path_580967, query_580968, nil, nil, nil)

var storageProjectsHmacKeysCreate* = Call_StorageProjectsHmacKeysCreate_580952(
    name: "storageProjectsHmacKeysCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/projects/{projectId}/hmacKeys",
    validator: validate_StorageProjectsHmacKeysCreate_580953, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysCreate_580954, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysList_580932 = ref object of OpenApiRestCall_579424
proc url_StorageProjectsHmacKeysList_580934(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysList_580933(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of HMAC keys matching the criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Name of the project in which to look for HMAC keys.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580935 = path.getOrDefault("projectId")
  valid_580935 = validateParameter(valid_580935, JString, required = true,
                                 default = nil)
  if valid_580935 != nil:
    section.add "projectId", valid_580935
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of items to return in a single page of responses. The service uses this parameter or 250 items, whichever is smaller. The max number of items per page will also be limited by the number of distinct service accounts in the response. If the number of service accounts in a single response is too high, the page will truncated and a next page token will be returned.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   showDeletedKeys: JBool
  ##                  : Whether or not to show keys in the DELETED state.
  ##   serviceAccountEmail: JString
  ##                      : If present, only keys for the given service account are returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580936 = query.getOrDefault("fields")
  valid_580936 = validateParameter(valid_580936, JString, required = false,
                                 default = nil)
  if valid_580936 != nil:
    section.add "fields", valid_580936
  var valid_580937 = query.getOrDefault("pageToken")
  valid_580937 = validateParameter(valid_580937, JString, required = false,
                                 default = nil)
  if valid_580937 != nil:
    section.add "pageToken", valid_580937
  var valid_580938 = query.getOrDefault("quotaUser")
  valid_580938 = validateParameter(valid_580938, JString, required = false,
                                 default = nil)
  if valid_580938 != nil:
    section.add "quotaUser", valid_580938
  var valid_580939 = query.getOrDefault("alt")
  valid_580939 = validateParameter(valid_580939, JString, required = false,
                                 default = newJString("json"))
  if valid_580939 != nil:
    section.add "alt", valid_580939
  var valid_580940 = query.getOrDefault("oauth_token")
  valid_580940 = validateParameter(valid_580940, JString, required = false,
                                 default = nil)
  if valid_580940 != nil:
    section.add "oauth_token", valid_580940
  var valid_580941 = query.getOrDefault("userIp")
  valid_580941 = validateParameter(valid_580941, JString, required = false,
                                 default = nil)
  if valid_580941 != nil:
    section.add "userIp", valid_580941
  var valid_580942 = query.getOrDefault("maxResults")
  valid_580942 = validateParameter(valid_580942, JInt, required = false,
                                 default = newJInt(250))
  if valid_580942 != nil:
    section.add "maxResults", valid_580942
  var valid_580943 = query.getOrDefault("userProject")
  valid_580943 = validateParameter(valid_580943, JString, required = false,
                                 default = nil)
  if valid_580943 != nil:
    section.add "userProject", valid_580943
  var valid_580944 = query.getOrDefault("key")
  valid_580944 = validateParameter(valid_580944, JString, required = false,
                                 default = nil)
  if valid_580944 != nil:
    section.add "key", valid_580944
  var valid_580945 = query.getOrDefault("showDeletedKeys")
  valid_580945 = validateParameter(valid_580945, JBool, required = false, default = nil)
  if valid_580945 != nil:
    section.add "showDeletedKeys", valid_580945
  var valid_580946 = query.getOrDefault("serviceAccountEmail")
  valid_580946 = validateParameter(valid_580946, JString, required = false,
                                 default = nil)
  if valid_580946 != nil:
    section.add "serviceAccountEmail", valid_580946
  var valid_580947 = query.getOrDefault("prettyPrint")
  valid_580947 = validateParameter(valid_580947, JBool, required = false,
                                 default = newJBool(true))
  if valid_580947 != nil:
    section.add "prettyPrint", valid_580947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580948: Call_StorageProjectsHmacKeysList_580932; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of HMAC keys matching the criteria.
  ## 
  let valid = call_580948.validator(path, query, header, formData, body)
  let scheme = call_580948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580948.url(scheme.get, call_580948.host, call_580948.base,
                         call_580948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580948, url, valid)

proc call*(call_580949: Call_StorageProjectsHmacKeysList_580932; projectId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 250; userProject: string = ""; key: string = "";
          showDeletedKeys: bool = false; serviceAccountEmail: string = "";
          prettyPrint: bool = true): Recallable =
  ## storageProjectsHmacKeysList
  ## Retrieves a list of HMAC keys matching the criteria.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of items to return in a single page of responses. The service uses this parameter or 250 items, whichever is smaller. The max number of items per page will also be limited by the number of distinct service accounts in the response. If the number of service accounts in a single response is too high, the page will truncated and a next page token will be returned.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   showDeletedKeys: bool
  ##                  : Whether or not to show keys in the DELETED state.
  ##   serviceAccountEmail: string
  ##                      : If present, only keys for the given service account are returned.
  ##   projectId: string (required)
  ##            : Name of the project in which to look for HMAC keys.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580950 = newJObject()
  var query_580951 = newJObject()
  add(query_580951, "fields", newJString(fields))
  add(query_580951, "pageToken", newJString(pageToken))
  add(query_580951, "quotaUser", newJString(quotaUser))
  add(query_580951, "alt", newJString(alt))
  add(query_580951, "oauth_token", newJString(oauthToken))
  add(query_580951, "userIp", newJString(userIp))
  add(query_580951, "maxResults", newJInt(maxResults))
  add(query_580951, "userProject", newJString(userProject))
  add(query_580951, "key", newJString(key))
  add(query_580951, "showDeletedKeys", newJBool(showDeletedKeys))
  add(query_580951, "serviceAccountEmail", newJString(serviceAccountEmail))
  add(path_580950, "projectId", newJString(projectId))
  add(query_580951, "prettyPrint", newJBool(prettyPrint))
  result = call_580949.call(path_580950, query_580951, nil, nil, nil)

var storageProjectsHmacKeysList* = Call_StorageProjectsHmacKeysList_580932(
    name: "storageProjectsHmacKeysList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/projects/{projectId}/hmacKeys",
    validator: validate_StorageProjectsHmacKeysList_580933, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysList_580934, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysUpdate_580986 = ref object of OpenApiRestCall_579424
proc url_StorageProjectsHmacKeysUpdate_580988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "accessId" in path, "`accessId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys/"),
               (kind: VariableSegment, value: "accessId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysUpdate_580987(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the state of an HMAC key. See the HMAC Key resource descriptor for valid states.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID owning the service account of the updated key.
  ##   accessId: JString (required)
  ##           : Name of the HMAC key being updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580989 = path.getOrDefault("projectId")
  valid_580989 = validateParameter(valid_580989, JString, required = true,
                                 default = nil)
  if valid_580989 != nil:
    section.add "projectId", valid_580989
  var valid_580990 = path.getOrDefault("accessId")
  valid_580990 = validateParameter(valid_580990, JString, required = true,
                                 default = nil)
  if valid_580990 != nil:
    section.add "accessId", valid_580990
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
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580991 = query.getOrDefault("fields")
  valid_580991 = validateParameter(valid_580991, JString, required = false,
                                 default = nil)
  if valid_580991 != nil:
    section.add "fields", valid_580991
  var valid_580992 = query.getOrDefault("quotaUser")
  valid_580992 = validateParameter(valid_580992, JString, required = false,
                                 default = nil)
  if valid_580992 != nil:
    section.add "quotaUser", valid_580992
  var valid_580993 = query.getOrDefault("alt")
  valid_580993 = validateParameter(valid_580993, JString, required = false,
                                 default = newJString("json"))
  if valid_580993 != nil:
    section.add "alt", valid_580993
  var valid_580994 = query.getOrDefault("oauth_token")
  valid_580994 = validateParameter(valid_580994, JString, required = false,
                                 default = nil)
  if valid_580994 != nil:
    section.add "oauth_token", valid_580994
  var valid_580995 = query.getOrDefault("userIp")
  valid_580995 = validateParameter(valid_580995, JString, required = false,
                                 default = nil)
  if valid_580995 != nil:
    section.add "userIp", valid_580995
  var valid_580996 = query.getOrDefault("userProject")
  valid_580996 = validateParameter(valid_580996, JString, required = false,
                                 default = nil)
  if valid_580996 != nil:
    section.add "userProject", valid_580996
  var valid_580997 = query.getOrDefault("key")
  valid_580997 = validateParameter(valid_580997, JString, required = false,
                                 default = nil)
  if valid_580997 != nil:
    section.add "key", valid_580997
  var valid_580998 = query.getOrDefault("prettyPrint")
  valid_580998 = validateParameter(valid_580998, JBool, required = false,
                                 default = newJBool(true))
  if valid_580998 != nil:
    section.add "prettyPrint", valid_580998
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

proc call*(call_581000: Call_StorageProjectsHmacKeysUpdate_580986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the state of an HMAC key. See the HMAC Key resource descriptor for valid states.
  ## 
  let valid = call_581000.validator(path, query, header, formData, body)
  let scheme = call_581000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581000.url(scheme.get, call_581000.host, call_581000.base,
                         call_581000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581000, url, valid)

proc call*(call_581001: Call_StorageProjectsHmacKeysUpdate_580986;
          projectId: string; accessId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## storageProjectsHmacKeysUpdate
  ## Updates the state of an HMAC key. See the HMAC Key resource descriptor for valid states.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID owning the service account of the updated key.
  ##   accessId: string (required)
  ##           : Name of the HMAC key being updated.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581002 = newJObject()
  var query_581003 = newJObject()
  var body_581004 = newJObject()
  add(query_581003, "fields", newJString(fields))
  add(query_581003, "quotaUser", newJString(quotaUser))
  add(query_581003, "alt", newJString(alt))
  add(query_581003, "oauth_token", newJString(oauthToken))
  add(query_581003, "userIp", newJString(userIp))
  add(query_581003, "userProject", newJString(userProject))
  add(query_581003, "key", newJString(key))
  add(path_581002, "projectId", newJString(projectId))
  add(path_581002, "accessId", newJString(accessId))
  if body != nil:
    body_581004 = body
  add(query_581003, "prettyPrint", newJBool(prettyPrint))
  result = call_581001.call(path_581002, query_581003, nil, nil, body_581004)

var storageProjectsHmacKeysUpdate* = Call_StorageProjectsHmacKeysUpdate_580986(
    name: "storageProjectsHmacKeysUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/projects/{projectId}/hmacKeys/{accessId}",
    validator: validate_StorageProjectsHmacKeysUpdate_580987, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysUpdate_580988, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysGet_580969 = ref object of OpenApiRestCall_579424
proc url_StorageProjectsHmacKeysGet_580971(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "accessId" in path, "`accessId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys/"),
               (kind: VariableSegment, value: "accessId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysGet_580970(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an HMAC key's metadata
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID owning the service account of the requested key.
  ##   accessId: JString (required)
  ##           : Name of the HMAC key.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580972 = path.getOrDefault("projectId")
  valid_580972 = validateParameter(valid_580972, JString, required = true,
                                 default = nil)
  if valid_580972 != nil:
    section.add "projectId", valid_580972
  var valid_580973 = path.getOrDefault("accessId")
  valid_580973 = validateParameter(valid_580973, JString, required = true,
                                 default = nil)
  if valid_580973 != nil:
    section.add "accessId", valid_580973
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
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580974 = query.getOrDefault("fields")
  valid_580974 = validateParameter(valid_580974, JString, required = false,
                                 default = nil)
  if valid_580974 != nil:
    section.add "fields", valid_580974
  var valid_580975 = query.getOrDefault("quotaUser")
  valid_580975 = validateParameter(valid_580975, JString, required = false,
                                 default = nil)
  if valid_580975 != nil:
    section.add "quotaUser", valid_580975
  var valid_580976 = query.getOrDefault("alt")
  valid_580976 = validateParameter(valid_580976, JString, required = false,
                                 default = newJString("json"))
  if valid_580976 != nil:
    section.add "alt", valid_580976
  var valid_580977 = query.getOrDefault("oauth_token")
  valid_580977 = validateParameter(valid_580977, JString, required = false,
                                 default = nil)
  if valid_580977 != nil:
    section.add "oauth_token", valid_580977
  var valid_580978 = query.getOrDefault("userIp")
  valid_580978 = validateParameter(valid_580978, JString, required = false,
                                 default = nil)
  if valid_580978 != nil:
    section.add "userIp", valid_580978
  var valid_580979 = query.getOrDefault("userProject")
  valid_580979 = validateParameter(valid_580979, JString, required = false,
                                 default = nil)
  if valid_580979 != nil:
    section.add "userProject", valid_580979
  var valid_580980 = query.getOrDefault("key")
  valid_580980 = validateParameter(valid_580980, JString, required = false,
                                 default = nil)
  if valid_580980 != nil:
    section.add "key", valid_580980
  var valid_580981 = query.getOrDefault("prettyPrint")
  valid_580981 = validateParameter(valid_580981, JBool, required = false,
                                 default = newJBool(true))
  if valid_580981 != nil:
    section.add "prettyPrint", valid_580981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580982: Call_StorageProjectsHmacKeysGet_580969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an HMAC key's metadata
  ## 
  let valid = call_580982.validator(path, query, header, formData, body)
  let scheme = call_580982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580982.url(scheme.get, call_580982.host, call_580982.base,
                         call_580982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580982, url, valid)

proc call*(call_580983: Call_StorageProjectsHmacKeysGet_580969; projectId: string;
          accessId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## storageProjectsHmacKeysGet
  ## Retrieves an HMAC key's metadata
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID owning the service account of the requested key.
  ##   accessId: string (required)
  ##           : Name of the HMAC key.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580984 = newJObject()
  var query_580985 = newJObject()
  add(query_580985, "fields", newJString(fields))
  add(query_580985, "quotaUser", newJString(quotaUser))
  add(query_580985, "alt", newJString(alt))
  add(query_580985, "oauth_token", newJString(oauthToken))
  add(query_580985, "userIp", newJString(userIp))
  add(query_580985, "userProject", newJString(userProject))
  add(query_580985, "key", newJString(key))
  add(path_580984, "projectId", newJString(projectId))
  add(path_580984, "accessId", newJString(accessId))
  add(query_580985, "prettyPrint", newJBool(prettyPrint))
  result = call_580983.call(path_580984, query_580985, nil, nil, nil)

var storageProjectsHmacKeysGet* = Call_StorageProjectsHmacKeysGet_580969(
    name: "storageProjectsHmacKeysGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/projects/{projectId}/hmacKeys/{accessId}",
    validator: validate_StorageProjectsHmacKeysGet_580970, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysGet_580971, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysDelete_581005 = ref object of OpenApiRestCall_579424
proc url_StorageProjectsHmacKeysDelete_581007(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "accessId" in path, "`accessId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys/"),
               (kind: VariableSegment, value: "accessId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysDelete_581006(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an HMAC key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID owning the requested key
  ##   accessId: JString (required)
  ##           : Name of the HMAC key to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_581008 = path.getOrDefault("projectId")
  valid_581008 = validateParameter(valid_581008, JString, required = true,
                                 default = nil)
  if valid_581008 != nil:
    section.add "projectId", valid_581008
  var valid_581009 = path.getOrDefault("accessId")
  valid_581009 = validateParameter(valid_581009, JString, required = true,
                                 default = nil)
  if valid_581009 != nil:
    section.add "accessId", valid_581009
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
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581010 = query.getOrDefault("fields")
  valid_581010 = validateParameter(valid_581010, JString, required = false,
                                 default = nil)
  if valid_581010 != nil:
    section.add "fields", valid_581010
  var valid_581011 = query.getOrDefault("quotaUser")
  valid_581011 = validateParameter(valid_581011, JString, required = false,
                                 default = nil)
  if valid_581011 != nil:
    section.add "quotaUser", valid_581011
  var valid_581012 = query.getOrDefault("alt")
  valid_581012 = validateParameter(valid_581012, JString, required = false,
                                 default = newJString("json"))
  if valid_581012 != nil:
    section.add "alt", valid_581012
  var valid_581013 = query.getOrDefault("oauth_token")
  valid_581013 = validateParameter(valid_581013, JString, required = false,
                                 default = nil)
  if valid_581013 != nil:
    section.add "oauth_token", valid_581013
  var valid_581014 = query.getOrDefault("userIp")
  valid_581014 = validateParameter(valid_581014, JString, required = false,
                                 default = nil)
  if valid_581014 != nil:
    section.add "userIp", valid_581014
  var valid_581015 = query.getOrDefault("userProject")
  valid_581015 = validateParameter(valid_581015, JString, required = false,
                                 default = nil)
  if valid_581015 != nil:
    section.add "userProject", valid_581015
  var valid_581016 = query.getOrDefault("key")
  valid_581016 = validateParameter(valid_581016, JString, required = false,
                                 default = nil)
  if valid_581016 != nil:
    section.add "key", valid_581016
  var valid_581017 = query.getOrDefault("prettyPrint")
  valid_581017 = validateParameter(valid_581017, JBool, required = false,
                                 default = newJBool(true))
  if valid_581017 != nil:
    section.add "prettyPrint", valid_581017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581018: Call_StorageProjectsHmacKeysDelete_581005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an HMAC key.
  ## 
  let valid = call_581018.validator(path, query, header, formData, body)
  let scheme = call_581018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581018.url(scheme.get, call_581018.host, call_581018.base,
                         call_581018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581018, url, valid)

proc call*(call_581019: Call_StorageProjectsHmacKeysDelete_581005;
          projectId: string; accessId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## storageProjectsHmacKeysDelete
  ## Deletes an HMAC key.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID owning the requested key
  ##   accessId: string (required)
  ##           : Name of the HMAC key to be deleted.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_581020 = newJObject()
  var query_581021 = newJObject()
  add(query_581021, "fields", newJString(fields))
  add(query_581021, "quotaUser", newJString(quotaUser))
  add(query_581021, "alt", newJString(alt))
  add(query_581021, "oauth_token", newJString(oauthToken))
  add(query_581021, "userIp", newJString(userIp))
  add(query_581021, "userProject", newJString(userProject))
  add(query_581021, "key", newJString(key))
  add(path_581020, "projectId", newJString(projectId))
  add(path_581020, "accessId", newJString(accessId))
  add(query_581021, "prettyPrint", newJBool(prettyPrint))
  result = call_581019.call(path_581020, query_581021, nil, nil, nil)

var storageProjectsHmacKeysDelete* = Call_StorageProjectsHmacKeysDelete_581005(
    name: "storageProjectsHmacKeysDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/projects/{projectId}/hmacKeys/{accessId}",
    validator: validate_StorageProjectsHmacKeysDelete_581006, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysDelete_581007, schemes: {Scheme.Https})
type
  Call_StorageProjectsServiceAccountGet_581022 = ref object of OpenApiRestCall_579424
proc url_StorageProjectsServiceAccountGet_581024(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/serviceAccount")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsServiceAccountGet_581023(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the email address of this project's Google Cloud Storage service account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_581025 = path.getOrDefault("projectId")
  valid_581025 = validateParameter(valid_581025, JString, required = true,
                                 default = nil)
  if valid_581025 != nil:
    section.add "projectId", valid_581025
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
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_581026 = query.getOrDefault("fields")
  valid_581026 = validateParameter(valid_581026, JString, required = false,
                                 default = nil)
  if valid_581026 != nil:
    section.add "fields", valid_581026
  var valid_581027 = query.getOrDefault("quotaUser")
  valid_581027 = validateParameter(valid_581027, JString, required = false,
                                 default = nil)
  if valid_581027 != nil:
    section.add "quotaUser", valid_581027
  var valid_581028 = query.getOrDefault("alt")
  valid_581028 = validateParameter(valid_581028, JString, required = false,
                                 default = newJString("json"))
  if valid_581028 != nil:
    section.add "alt", valid_581028
  var valid_581029 = query.getOrDefault("oauth_token")
  valid_581029 = validateParameter(valid_581029, JString, required = false,
                                 default = nil)
  if valid_581029 != nil:
    section.add "oauth_token", valid_581029
  var valid_581030 = query.getOrDefault("userIp")
  valid_581030 = validateParameter(valid_581030, JString, required = false,
                                 default = nil)
  if valid_581030 != nil:
    section.add "userIp", valid_581030
  var valid_581031 = query.getOrDefault("userProject")
  valid_581031 = validateParameter(valid_581031, JString, required = false,
                                 default = nil)
  if valid_581031 != nil:
    section.add "userProject", valid_581031
  var valid_581032 = query.getOrDefault("key")
  valid_581032 = validateParameter(valid_581032, JString, required = false,
                                 default = nil)
  if valid_581032 != nil:
    section.add "key", valid_581032
  var valid_581033 = query.getOrDefault("prettyPrint")
  valid_581033 = validateParameter(valid_581033, JBool, required = false,
                                 default = newJBool(true))
  if valid_581033 != nil:
    section.add "prettyPrint", valid_581033
  var valid_581034 = query.getOrDefault("provisionalUserProject")
  valid_581034 = validateParameter(valid_581034, JString, required = false,
                                 default = nil)
  if valid_581034 != nil:
    section.add "provisionalUserProject", valid_581034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581035: Call_StorageProjectsServiceAccountGet_581022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the email address of this project's Google Cloud Storage service account.
  ## 
  let valid = call_581035.validator(path, query, header, formData, body)
  let scheme = call_581035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581035.url(scheme.get, call_581035.host, call_581035.base,
                         call_581035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581035, url, valid)

proc call*(call_581036: Call_StorageProjectsServiceAccountGet_581022;
          projectId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageProjectsServiceAccountGet
  ## Get the email address of this project's Google Cloud Storage service account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_581037 = newJObject()
  var query_581038 = newJObject()
  add(query_581038, "fields", newJString(fields))
  add(query_581038, "quotaUser", newJString(quotaUser))
  add(query_581038, "alt", newJString(alt))
  add(query_581038, "oauth_token", newJString(oauthToken))
  add(query_581038, "userIp", newJString(userIp))
  add(query_581038, "userProject", newJString(userProject))
  add(query_581038, "key", newJString(key))
  add(path_581037, "projectId", newJString(projectId))
  add(query_581038, "prettyPrint", newJBool(prettyPrint))
  add(query_581038, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_581036.call(path_581037, query_581038, nil, nil, nil)

var storageProjectsServiceAccountGet* = Call_StorageProjectsServiceAccountGet_581022(
    name: "storageProjectsServiceAccountGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/projects/{projectId}/serviceAccount",
    validator: validate_StorageProjectsServiceAccountGet_581023,
    base: "/storage/v1", url: url_StorageProjectsServiceAccountGet_581024,
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
