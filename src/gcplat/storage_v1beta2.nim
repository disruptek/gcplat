
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Storage
## version: v1beta2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Lets you store and retrieve potentially-large, immutable data objects.
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

  OpenApiRestCall_579380 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579380](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579380): Option[Scheme] {.used.} =
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
  gcpServiceName = "storage"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StorageBucketsInsert_579922 = ref object of OpenApiRestCall_579380
proc url_StorageBucketsInsert_579924(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsInsert_579923(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new bucket.
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
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: JString (required)
  ##          : A valid API project identifier.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579925 = query.getOrDefault("key")
  valid_579925 = validateParameter(valid_579925, JString, required = false,
                                 default = nil)
  if valid_579925 != nil:
    section.add "key", valid_579925
  var valid_579926 = query.getOrDefault("prettyPrint")
  valid_579926 = validateParameter(valid_579926, JBool, required = false,
                                 default = newJBool(true))
  if valid_579926 != nil:
    section.add "prettyPrint", valid_579926
  var valid_579927 = query.getOrDefault("oauth_token")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = nil)
  if valid_579927 != nil:
    section.add "oauth_token", valid_579927
  var valid_579928 = query.getOrDefault("alt")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = newJString("json"))
  if valid_579928 != nil:
    section.add "alt", valid_579928
  var valid_579929 = query.getOrDefault("userIp")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "userIp", valid_579929
  var valid_579930 = query.getOrDefault("quotaUser")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = nil)
  if valid_579930 != nil:
    section.add "quotaUser", valid_579930
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_579931 = query.getOrDefault("project")
  valid_579931 = validateParameter(valid_579931, JString, required = true,
                                 default = nil)
  if valid_579931 != nil:
    section.add "project", valid_579931
  var valid_579932 = query.getOrDefault("projection")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = newJString("full"))
  if valid_579932 != nil:
    section.add "projection", valid_579932
  var valid_579933 = query.getOrDefault("fields")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "fields", valid_579933
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

proc call*(call_579935: Call_StorageBucketsInsert_579922; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new bucket.
  ## 
  let valid = call_579935.validator(path, query, header, formData, body)
  let scheme = call_579935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579935.url(scheme.get, call_579935.host, call_579935.base,
                         call_579935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579935, url, valid)

proc call*(call_579936: Call_StorageBucketsInsert_579922; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; projection: string = "full"; fields: string = ""): Recallable =
  ## storageBucketsInsert
  ## Creates a new bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : A valid API project identifier.
  ##   body: JObject
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579937 = newJObject()
  var body_579938 = newJObject()
  add(query_579937, "key", newJString(key))
  add(query_579937, "prettyPrint", newJBool(prettyPrint))
  add(query_579937, "oauth_token", newJString(oauthToken))
  add(query_579937, "alt", newJString(alt))
  add(query_579937, "userIp", newJString(userIp))
  add(query_579937, "quotaUser", newJString(quotaUser))
  add(query_579937, "project", newJString(project))
  if body != nil:
    body_579938 = body
  add(query_579937, "projection", newJString(projection))
  add(query_579937, "fields", newJString(fields))
  result = call_579936.call(nil, query_579937, nil, nil, body_579938)

var storageBucketsInsert* = Call_StorageBucketsInsert_579922(
    name: "storageBucketsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b",
    validator: validate_StorageBucketsInsert_579923, base: "/storage/v1beta2",
    url: url_StorageBucketsInsert_579924, schemes: {Scheme.Https})
type
  Call_StorageBucketsList_579650 = ref object of OpenApiRestCall_579380
proc url_StorageBucketsList_579652(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsList_579651(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a list of buckets for a given project.
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
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: JString (required)
  ##          : A valid API project identifier.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of buckets to return.
  section = newJObject()
  var valid_579764 = query.getOrDefault("key")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "key", valid_579764
  var valid_579778 = query.getOrDefault("prettyPrint")
  valid_579778 = validateParameter(valid_579778, JBool, required = false,
                                 default = newJBool(true))
  if valid_579778 != nil:
    section.add "prettyPrint", valid_579778
  var valid_579779 = query.getOrDefault("oauth_token")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "oauth_token", valid_579779
  var valid_579780 = query.getOrDefault("alt")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = newJString("json"))
  if valid_579780 != nil:
    section.add "alt", valid_579780
  var valid_579781 = query.getOrDefault("userIp")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "userIp", valid_579781
  var valid_579782 = query.getOrDefault("quotaUser")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "quotaUser", valid_579782
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_579783 = query.getOrDefault("project")
  valid_579783 = validateParameter(valid_579783, JString, required = true,
                                 default = nil)
  if valid_579783 != nil:
    section.add "project", valid_579783
  var valid_579784 = query.getOrDefault("pageToken")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "pageToken", valid_579784
  var valid_579785 = query.getOrDefault("projection")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = newJString("full"))
  if valid_579785 != nil:
    section.add "projection", valid_579785
  var valid_579786 = query.getOrDefault("fields")
  valid_579786 = validateParameter(valid_579786, JString, required = false,
                                 default = nil)
  if valid_579786 != nil:
    section.add "fields", valid_579786
  var valid_579787 = query.getOrDefault("maxResults")
  valid_579787 = validateParameter(valid_579787, JInt, required = false, default = nil)
  if valid_579787 != nil:
    section.add "maxResults", valid_579787
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579810: Call_StorageBucketsList_579650; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of buckets for a given project.
  ## 
  let valid = call_579810.validator(path, query, header, formData, body)
  let scheme = call_579810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579810.url(scheme.get, call_579810.host, call_579810.base,
                         call_579810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579810, url, valid)

proc call*(call_579881: Call_StorageBucketsList_579650; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; projection: string = "full"; fields: string = "";
          maxResults: int = 0): Recallable =
  ## storageBucketsList
  ## Retrieves a list of buckets for a given project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : A valid API project identifier.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of buckets to return.
  var query_579882 = newJObject()
  add(query_579882, "key", newJString(key))
  add(query_579882, "prettyPrint", newJBool(prettyPrint))
  add(query_579882, "oauth_token", newJString(oauthToken))
  add(query_579882, "alt", newJString(alt))
  add(query_579882, "userIp", newJString(userIp))
  add(query_579882, "quotaUser", newJString(quotaUser))
  add(query_579882, "project", newJString(project))
  add(query_579882, "pageToken", newJString(pageToken))
  add(query_579882, "projection", newJString(projection))
  add(query_579882, "fields", newJString(fields))
  add(query_579882, "maxResults", newJInt(maxResults))
  result = call_579881.call(nil, query_579882, nil, nil, nil)

var storageBucketsList* = Call_StorageBucketsList_579650(
    name: "storageBucketsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b", validator: validate_StorageBucketsList_579651,
    base: "/storage/v1beta2", url: url_StorageBucketsList_579652,
    schemes: {Scheme.Https})
type
  Call_StorageBucketsUpdate_579971 = ref object of OpenApiRestCall_579380
proc url_StorageBucketsUpdate_579973(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketsUpdate_579972(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579974 = path.getOrDefault("bucket")
  valid_579974 = validateParameter(valid_579974, JString, required = true,
                                 default = nil)
  if valid_579974 != nil:
    section.add "bucket", valid_579974
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579975 = query.getOrDefault("key")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "key", valid_579975
  var valid_579976 = query.getOrDefault("prettyPrint")
  valid_579976 = validateParameter(valid_579976, JBool, required = false,
                                 default = newJBool(true))
  if valid_579976 != nil:
    section.add "prettyPrint", valid_579976
  var valid_579977 = query.getOrDefault("oauth_token")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "oauth_token", valid_579977
  var valid_579978 = query.getOrDefault("alt")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("json"))
  if valid_579978 != nil:
    section.add "alt", valid_579978
  var valid_579979 = query.getOrDefault("userIp")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "userIp", valid_579979
  var valid_579980 = query.getOrDefault("quotaUser")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "quotaUser", valid_579980
  var valid_579981 = query.getOrDefault("ifMetagenerationMatch")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "ifMetagenerationMatch", valid_579981
  var valid_579982 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "ifMetagenerationNotMatch", valid_579982
  var valid_579983 = query.getOrDefault("projection")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = newJString("full"))
  if valid_579983 != nil:
    section.add "projection", valid_579983
  var valid_579984 = query.getOrDefault("fields")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "fields", valid_579984
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

proc call*(call_579986: Call_StorageBucketsUpdate_579971; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket.
  ## 
  let valid = call_579986.validator(path, query, header, formData, body)
  let scheme = call_579986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579986.url(scheme.get, call_579986.host, call_579986.base,
                         call_579986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579986, url, valid)

proc call*(call_579987: Call_StorageBucketsUpdate_579971; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageBucketsUpdate
  ## Updates a bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579988 = newJObject()
  var query_579989 = newJObject()
  var body_579990 = newJObject()
  add(query_579989, "key", newJString(key))
  add(query_579989, "prettyPrint", newJBool(prettyPrint))
  add(query_579989, "oauth_token", newJString(oauthToken))
  add(query_579989, "alt", newJString(alt))
  add(query_579989, "userIp", newJString(userIp))
  add(query_579989, "quotaUser", newJString(quotaUser))
  add(query_579989, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579988, "bucket", newJString(bucket))
  if body != nil:
    body_579990 = body
  add(query_579989, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579989, "projection", newJString(projection))
  add(query_579989, "fields", newJString(fields))
  result = call_579987.call(path_579988, query_579989, nil, nil, body_579990)

var storageBucketsUpdate* = Call_StorageBucketsUpdate_579971(
    name: "storageBucketsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsUpdate_579972, base: "/storage/v1beta2",
    url: url_StorageBucketsUpdate_579973, schemes: {Scheme.Https})
type
  Call_StorageBucketsGet_579939 = ref object of OpenApiRestCall_579380
proc url_StorageBucketsGet_579941(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketsGet_579940(path: JsonNode; query: JsonNode;
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
  var valid_579956 = path.getOrDefault("bucket")
  valid_579956 = validateParameter(valid_579956, JString, required = true,
                                 default = nil)
  if valid_579956 != nil:
    section.add "bucket", valid_579956
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579957 = query.getOrDefault("key")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "key", valid_579957
  var valid_579958 = query.getOrDefault("prettyPrint")
  valid_579958 = validateParameter(valid_579958, JBool, required = false,
                                 default = newJBool(true))
  if valid_579958 != nil:
    section.add "prettyPrint", valid_579958
  var valid_579959 = query.getOrDefault("oauth_token")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "oauth_token", valid_579959
  var valid_579960 = query.getOrDefault("alt")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = newJString("json"))
  if valid_579960 != nil:
    section.add "alt", valid_579960
  var valid_579961 = query.getOrDefault("userIp")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "userIp", valid_579961
  var valid_579962 = query.getOrDefault("quotaUser")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "quotaUser", valid_579962
  var valid_579963 = query.getOrDefault("ifMetagenerationMatch")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "ifMetagenerationMatch", valid_579963
  var valid_579964 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "ifMetagenerationNotMatch", valid_579964
  var valid_579965 = query.getOrDefault("projection")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = newJString("full"))
  if valid_579965 != nil:
    section.add "projection", valid_579965
  var valid_579966 = query.getOrDefault("fields")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "fields", valid_579966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579967: Call_StorageBucketsGet_579939; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata for the specified bucket.
  ## 
  let valid = call_579967.validator(path, query, header, formData, body)
  let scheme = call_579967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579967.url(scheme.get, call_579967.host, call_579967.base,
                         call_579967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579967, url, valid)

proc call*(call_579968: Call_StorageBucketsGet_579939; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; ifMetagenerationNotMatch: string = "";
          projection: string = "full"; fields: string = ""): Recallable =
  ## storageBucketsGet
  ## Returns metadata for the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579969 = newJObject()
  var query_579970 = newJObject()
  add(query_579970, "key", newJString(key))
  add(query_579970, "prettyPrint", newJBool(prettyPrint))
  add(query_579970, "oauth_token", newJString(oauthToken))
  add(query_579970, "alt", newJString(alt))
  add(query_579970, "userIp", newJString(userIp))
  add(query_579970, "quotaUser", newJString(quotaUser))
  add(query_579970, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579969, "bucket", newJString(bucket))
  add(query_579970, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579970, "projection", newJString(projection))
  add(query_579970, "fields", newJString(fields))
  result = call_579968.call(path_579969, query_579970, nil, nil, nil)

var storageBucketsGet* = Call_StorageBucketsGet_579939(name: "storageBucketsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsGet_579940, base: "/storage/v1beta2",
    url: url_StorageBucketsGet_579941, schemes: {Scheme.Https})
type
  Call_StorageBucketsPatch_580008 = ref object of OpenApiRestCall_579380
proc url_StorageBucketsPatch_580010(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketsPatch_580009(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a bucket. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580011 = path.getOrDefault("bucket")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "bucket", valid_580011
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580012 = query.getOrDefault("key")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "key", valid_580012
  var valid_580013 = query.getOrDefault("prettyPrint")
  valid_580013 = validateParameter(valid_580013, JBool, required = false,
                                 default = newJBool(true))
  if valid_580013 != nil:
    section.add "prettyPrint", valid_580013
  var valid_580014 = query.getOrDefault("oauth_token")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "oauth_token", valid_580014
  var valid_580015 = query.getOrDefault("alt")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("json"))
  if valid_580015 != nil:
    section.add "alt", valid_580015
  var valid_580016 = query.getOrDefault("userIp")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "userIp", valid_580016
  var valid_580017 = query.getOrDefault("quotaUser")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "quotaUser", valid_580017
  var valid_580018 = query.getOrDefault("ifMetagenerationMatch")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "ifMetagenerationMatch", valid_580018
  var valid_580019 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "ifMetagenerationNotMatch", valid_580019
  var valid_580020 = query.getOrDefault("projection")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = newJString("full"))
  if valid_580020 != nil:
    section.add "projection", valid_580020
  var valid_580021 = query.getOrDefault("fields")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "fields", valid_580021
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

proc call*(call_580023: Call_StorageBucketsPatch_580008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket. This method supports patch semantics.
  ## 
  let valid = call_580023.validator(path, query, header, formData, body)
  let scheme = call_580023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580023.url(scheme.get, call_580023.host, call_580023.base,
                         call_580023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580023, url, valid)

proc call*(call_580024: Call_StorageBucketsPatch_580008; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageBucketsPatch
  ## Updates a bucket. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580025 = newJObject()
  var query_580026 = newJObject()
  var body_580027 = newJObject()
  add(query_580026, "key", newJString(key))
  add(query_580026, "prettyPrint", newJBool(prettyPrint))
  add(query_580026, "oauth_token", newJString(oauthToken))
  add(query_580026, "alt", newJString(alt))
  add(query_580026, "userIp", newJString(userIp))
  add(query_580026, "quotaUser", newJString(quotaUser))
  add(query_580026, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580025, "bucket", newJString(bucket))
  if body != nil:
    body_580027 = body
  add(query_580026, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580026, "projection", newJString(projection))
  add(query_580026, "fields", newJString(fields))
  result = call_580024.call(path_580025, query_580026, nil, nil, body_580027)

var storageBucketsPatch* = Call_StorageBucketsPatch_580008(
    name: "storageBucketsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsPatch_580009, base: "/storage/v1beta2",
    url: url_StorageBucketsPatch_580010, schemes: {Scheme.Https})
type
  Call_StorageBucketsDelete_579991 = ref object of OpenApiRestCall_579380
proc url_StorageBucketsDelete_579993(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketsDelete_579992(path: JsonNode; query: JsonNode;
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
  var valid_579994 = path.getOrDefault("bucket")
  valid_579994 = validateParameter(valid_579994, JString, required = true,
                                 default = nil)
  if valid_579994 != nil:
    section.add "bucket", valid_579994
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579995 = query.getOrDefault("key")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "key", valid_579995
  var valid_579996 = query.getOrDefault("prettyPrint")
  valid_579996 = validateParameter(valid_579996, JBool, required = false,
                                 default = newJBool(true))
  if valid_579996 != nil:
    section.add "prettyPrint", valid_579996
  var valid_579997 = query.getOrDefault("oauth_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "oauth_token", valid_579997
  var valid_579998 = query.getOrDefault("alt")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = newJString("json"))
  if valid_579998 != nil:
    section.add "alt", valid_579998
  var valid_579999 = query.getOrDefault("userIp")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "userIp", valid_579999
  var valid_580000 = query.getOrDefault("quotaUser")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "quotaUser", valid_580000
  var valid_580001 = query.getOrDefault("ifMetagenerationMatch")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "ifMetagenerationMatch", valid_580001
  var valid_580002 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "ifMetagenerationNotMatch", valid_580002
  var valid_580003 = query.getOrDefault("fields")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "fields", valid_580003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580004: Call_StorageBucketsDelete_579991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes an empty bucket.
  ## 
  let valid = call_580004.validator(path, query, header, formData, body)
  let scheme = call_580004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580004.url(scheme.get, call_580004.host, call_580004.base,
                         call_580004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580004, url, valid)

proc call*(call_580005: Call_StorageBucketsDelete_579991; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; ifMetagenerationNotMatch: string = "";
          fields: string = ""): Recallable =
  ## storageBucketsDelete
  ## Permanently deletes an empty bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580006 = newJObject()
  var query_580007 = newJObject()
  add(query_580007, "key", newJString(key))
  add(query_580007, "prettyPrint", newJBool(prettyPrint))
  add(query_580007, "oauth_token", newJString(oauthToken))
  add(query_580007, "alt", newJString(alt))
  add(query_580007, "userIp", newJString(userIp))
  add(query_580007, "quotaUser", newJString(quotaUser))
  add(query_580007, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580006, "bucket", newJString(bucket))
  add(query_580007, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580007, "fields", newJString(fields))
  result = call_580005.call(path_580006, query_580007, nil, nil, nil)

var storageBucketsDelete* = Call_StorageBucketsDelete_579991(
    name: "storageBucketsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsDelete_579992, base: "/storage/v1beta2",
    url: url_StorageBucketsDelete_579993, schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsInsert_580043 = ref object of OpenApiRestCall_579380
proc url_StorageBucketAccessControlsInsert_580045(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsInsert_580044(path: JsonNode;
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
  var valid_580046 = path.getOrDefault("bucket")
  valid_580046 = validateParameter(valid_580046, JString, required = true,
                                 default = nil)
  if valid_580046 != nil:
    section.add "bucket", valid_580046
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580047 = query.getOrDefault("key")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "key", valid_580047
  var valid_580048 = query.getOrDefault("prettyPrint")
  valid_580048 = validateParameter(valid_580048, JBool, required = false,
                                 default = newJBool(true))
  if valid_580048 != nil:
    section.add "prettyPrint", valid_580048
  var valid_580049 = query.getOrDefault("oauth_token")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "oauth_token", valid_580049
  var valid_580050 = query.getOrDefault("alt")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = newJString("json"))
  if valid_580050 != nil:
    section.add "alt", valid_580050
  var valid_580051 = query.getOrDefault("userIp")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "userIp", valid_580051
  var valid_580052 = query.getOrDefault("quotaUser")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "quotaUser", valid_580052
  var valid_580053 = query.getOrDefault("fields")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "fields", valid_580053
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

proc call*(call_580055: Call_StorageBucketAccessControlsInsert_580043;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified bucket.
  ## 
  let valid = call_580055.validator(path, query, header, formData, body)
  let scheme = call_580055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580055.url(scheme.get, call_580055.host, call_580055.base,
                         call_580055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580055, url, valid)

proc call*(call_580056: Call_StorageBucketAccessControlsInsert_580043;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageBucketAccessControlsInsert
  ## Creates a new ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580057 = newJObject()
  var query_580058 = newJObject()
  var body_580059 = newJObject()
  add(query_580058, "key", newJString(key))
  add(query_580058, "prettyPrint", newJBool(prettyPrint))
  add(query_580058, "oauth_token", newJString(oauthToken))
  add(query_580058, "alt", newJString(alt))
  add(query_580058, "userIp", newJString(userIp))
  add(query_580058, "quotaUser", newJString(quotaUser))
  add(path_580057, "bucket", newJString(bucket))
  if body != nil:
    body_580059 = body
  add(query_580058, "fields", newJString(fields))
  result = call_580056.call(path_580057, query_580058, nil, nil, body_580059)

var storageBucketAccessControlsInsert* = Call_StorageBucketAccessControlsInsert_580043(
    name: "storageBucketAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsInsert_580044,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsInsert_580045,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsList_580028 = ref object of OpenApiRestCall_579380
proc url_StorageBucketAccessControlsList_580030(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsList_580029(path: JsonNode;
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
  var valid_580031 = path.getOrDefault("bucket")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "bucket", valid_580031
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580032 = query.getOrDefault("key")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "key", valid_580032
  var valid_580033 = query.getOrDefault("prettyPrint")
  valid_580033 = validateParameter(valid_580033, JBool, required = false,
                                 default = newJBool(true))
  if valid_580033 != nil:
    section.add "prettyPrint", valid_580033
  var valid_580034 = query.getOrDefault("oauth_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "oauth_token", valid_580034
  var valid_580035 = query.getOrDefault("alt")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("json"))
  if valid_580035 != nil:
    section.add "alt", valid_580035
  var valid_580036 = query.getOrDefault("userIp")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "userIp", valid_580036
  var valid_580037 = query.getOrDefault("quotaUser")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "quotaUser", valid_580037
  var valid_580038 = query.getOrDefault("fields")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "fields", valid_580038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580039: Call_StorageBucketAccessControlsList_580028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified bucket.
  ## 
  let valid = call_580039.validator(path, query, header, formData, body)
  let scheme = call_580039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580039.url(scheme.get, call_580039.host, call_580039.base,
                         call_580039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580039, url, valid)

proc call*(call_580040: Call_StorageBucketAccessControlsList_580028;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsList
  ## Retrieves ACL entries on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580041 = newJObject()
  var query_580042 = newJObject()
  add(query_580042, "key", newJString(key))
  add(query_580042, "prettyPrint", newJBool(prettyPrint))
  add(query_580042, "oauth_token", newJString(oauthToken))
  add(query_580042, "alt", newJString(alt))
  add(query_580042, "userIp", newJString(userIp))
  add(query_580042, "quotaUser", newJString(quotaUser))
  add(path_580041, "bucket", newJString(bucket))
  add(query_580042, "fields", newJString(fields))
  result = call_580040.call(path_580041, query_580042, nil, nil, nil)

var storageBucketAccessControlsList* = Call_StorageBucketAccessControlsList_580028(
    name: "storageBucketAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsList_580029,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsList_580030,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsUpdate_580076 = ref object of OpenApiRestCall_579380
proc url_StorageBucketAccessControlsUpdate_580078(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsUpdate_580077(path: JsonNode;
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
  var valid_580079 = path.getOrDefault("bucket")
  valid_580079 = validateParameter(valid_580079, JString, required = true,
                                 default = nil)
  if valid_580079 != nil:
    section.add "bucket", valid_580079
  var valid_580080 = path.getOrDefault("entity")
  valid_580080 = validateParameter(valid_580080, JString, required = true,
                                 default = nil)
  if valid_580080 != nil:
    section.add "entity", valid_580080
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580081 = query.getOrDefault("key")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "key", valid_580081
  var valid_580082 = query.getOrDefault("prettyPrint")
  valid_580082 = validateParameter(valid_580082, JBool, required = false,
                                 default = newJBool(true))
  if valid_580082 != nil:
    section.add "prettyPrint", valid_580082
  var valid_580083 = query.getOrDefault("oauth_token")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "oauth_token", valid_580083
  var valid_580084 = query.getOrDefault("alt")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = newJString("json"))
  if valid_580084 != nil:
    section.add "alt", valid_580084
  var valid_580085 = query.getOrDefault("userIp")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "userIp", valid_580085
  var valid_580086 = query.getOrDefault("quotaUser")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "quotaUser", valid_580086
  var valid_580087 = query.getOrDefault("fields")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "fields", valid_580087
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

proc call*(call_580089: Call_StorageBucketAccessControlsUpdate_580076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket.
  ## 
  let valid = call_580089.validator(path, query, header, formData, body)
  let scheme = call_580089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580089.url(scheme.get, call_580089.host, call_580089.base,
                         call_580089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580089, url, valid)

proc call*(call_580090: Call_StorageBucketAccessControlsUpdate_580076;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageBucketAccessControlsUpdate
  ## Updates an ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580091 = newJObject()
  var query_580092 = newJObject()
  var body_580093 = newJObject()
  add(query_580092, "key", newJString(key))
  add(query_580092, "prettyPrint", newJBool(prettyPrint))
  add(query_580092, "oauth_token", newJString(oauthToken))
  add(query_580092, "alt", newJString(alt))
  add(query_580092, "userIp", newJString(userIp))
  add(query_580092, "quotaUser", newJString(quotaUser))
  add(path_580091, "bucket", newJString(bucket))
  if body != nil:
    body_580093 = body
  add(path_580091, "entity", newJString(entity))
  add(query_580092, "fields", newJString(fields))
  result = call_580090.call(path_580091, query_580092, nil, nil, body_580093)

var storageBucketAccessControlsUpdate* = Call_StorageBucketAccessControlsUpdate_580076(
    name: "storageBucketAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsUpdate_580077,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsUpdate_580078,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsGet_580060 = ref object of OpenApiRestCall_579380
proc url_StorageBucketAccessControlsGet_580062(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsGet_580061(path: JsonNode;
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
  var valid_580063 = path.getOrDefault("bucket")
  valid_580063 = validateParameter(valid_580063, JString, required = true,
                                 default = nil)
  if valid_580063 != nil:
    section.add "bucket", valid_580063
  var valid_580064 = path.getOrDefault("entity")
  valid_580064 = validateParameter(valid_580064, JString, required = true,
                                 default = nil)
  if valid_580064 != nil:
    section.add "entity", valid_580064
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580065 = query.getOrDefault("key")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "key", valid_580065
  var valid_580066 = query.getOrDefault("prettyPrint")
  valid_580066 = validateParameter(valid_580066, JBool, required = false,
                                 default = newJBool(true))
  if valid_580066 != nil:
    section.add "prettyPrint", valid_580066
  var valid_580067 = query.getOrDefault("oauth_token")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "oauth_token", valid_580067
  var valid_580068 = query.getOrDefault("alt")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = newJString("json"))
  if valid_580068 != nil:
    section.add "alt", valid_580068
  var valid_580069 = query.getOrDefault("userIp")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "userIp", valid_580069
  var valid_580070 = query.getOrDefault("quotaUser")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "quotaUser", valid_580070
  var valid_580071 = query.getOrDefault("fields")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "fields", valid_580071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580072: Call_StorageBucketAccessControlsGet_580060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580072.validator(path, query, header, formData, body)
  let scheme = call_580072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580072.url(scheme.get, call_580072.host, call_580072.base,
                         call_580072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580072, url, valid)

proc call*(call_580073: Call_StorageBucketAccessControlsGet_580060; bucket: string;
          entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsGet
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580074 = newJObject()
  var query_580075 = newJObject()
  add(query_580075, "key", newJString(key))
  add(query_580075, "prettyPrint", newJBool(prettyPrint))
  add(query_580075, "oauth_token", newJString(oauthToken))
  add(query_580075, "alt", newJString(alt))
  add(query_580075, "userIp", newJString(userIp))
  add(query_580075, "quotaUser", newJString(quotaUser))
  add(path_580074, "bucket", newJString(bucket))
  add(path_580074, "entity", newJString(entity))
  add(query_580075, "fields", newJString(fields))
  result = call_580073.call(path_580074, query_580075, nil, nil, nil)

var storageBucketAccessControlsGet* = Call_StorageBucketAccessControlsGet_580060(
    name: "storageBucketAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsGet_580061,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsGet_580062,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsPatch_580110 = ref object of OpenApiRestCall_579380
proc url_StorageBucketAccessControlsPatch_580112(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsPatch_580111(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an ACL entry on the specified bucket. This method supports patch semantics.
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
  var valid_580113 = path.getOrDefault("bucket")
  valid_580113 = validateParameter(valid_580113, JString, required = true,
                                 default = nil)
  if valid_580113 != nil:
    section.add "bucket", valid_580113
  var valid_580114 = path.getOrDefault("entity")
  valid_580114 = validateParameter(valid_580114, JString, required = true,
                                 default = nil)
  if valid_580114 != nil:
    section.add "entity", valid_580114
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580115 = query.getOrDefault("key")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "key", valid_580115
  var valid_580116 = query.getOrDefault("prettyPrint")
  valid_580116 = validateParameter(valid_580116, JBool, required = false,
                                 default = newJBool(true))
  if valid_580116 != nil:
    section.add "prettyPrint", valid_580116
  var valid_580117 = query.getOrDefault("oauth_token")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "oauth_token", valid_580117
  var valid_580118 = query.getOrDefault("alt")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = newJString("json"))
  if valid_580118 != nil:
    section.add "alt", valid_580118
  var valid_580119 = query.getOrDefault("userIp")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "userIp", valid_580119
  var valid_580120 = query.getOrDefault("quotaUser")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "quotaUser", valid_580120
  var valid_580121 = query.getOrDefault("fields")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "fields", valid_580121
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

proc call*(call_580123: Call_StorageBucketAccessControlsPatch_580110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket. This method supports patch semantics.
  ## 
  let valid = call_580123.validator(path, query, header, formData, body)
  let scheme = call_580123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580123.url(scheme.get, call_580123.host, call_580123.base,
                         call_580123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580123, url, valid)

proc call*(call_580124: Call_StorageBucketAccessControlsPatch_580110;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageBucketAccessControlsPatch
  ## Updates an ACL entry on the specified bucket. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580125 = newJObject()
  var query_580126 = newJObject()
  var body_580127 = newJObject()
  add(query_580126, "key", newJString(key))
  add(query_580126, "prettyPrint", newJBool(prettyPrint))
  add(query_580126, "oauth_token", newJString(oauthToken))
  add(query_580126, "alt", newJString(alt))
  add(query_580126, "userIp", newJString(userIp))
  add(query_580126, "quotaUser", newJString(quotaUser))
  add(path_580125, "bucket", newJString(bucket))
  if body != nil:
    body_580127 = body
  add(path_580125, "entity", newJString(entity))
  add(query_580126, "fields", newJString(fields))
  result = call_580124.call(path_580125, query_580126, nil, nil, body_580127)

var storageBucketAccessControlsPatch* = Call_StorageBucketAccessControlsPatch_580110(
    name: "storageBucketAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsPatch_580111,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsPatch_580112,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsDelete_580094 = ref object of OpenApiRestCall_579380
proc url_StorageBucketAccessControlsDelete_580096(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsDelete_580095(path: JsonNode;
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
  var valid_580097 = path.getOrDefault("bucket")
  valid_580097 = validateParameter(valid_580097, JString, required = true,
                                 default = nil)
  if valid_580097 != nil:
    section.add "bucket", valid_580097
  var valid_580098 = path.getOrDefault("entity")
  valid_580098 = validateParameter(valid_580098, JString, required = true,
                                 default = nil)
  if valid_580098 != nil:
    section.add "entity", valid_580098
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580099 = query.getOrDefault("key")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "key", valid_580099
  var valid_580100 = query.getOrDefault("prettyPrint")
  valid_580100 = validateParameter(valid_580100, JBool, required = false,
                                 default = newJBool(true))
  if valid_580100 != nil:
    section.add "prettyPrint", valid_580100
  var valid_580101 = query.getOrDefault("oauth_token")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "oauth_token", valid_580101
  var valid_580102 = query.getOrDefault("alt")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = newJString("json"))
  if valid_580102 != nil:
    section.add "alt", valid_580102
  var valid_580103 = query.getOrDefault("userIp")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "userIp", valid_580103
  var valid_580104 = query.getOrDefault("quotaUser")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "quotaUser", valid_580104
  var valid_580105 = query.getOrDefault("fields")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "fields", valid_580105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580106: Call_StorageBucketAccessControlsDelete_580094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580106.validator(path, query, header, formData, body)
  let scheme = call_580106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580106.url(scheme.get, call_580106.host, call_580106.base,
                         call_580106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580106, url, valid)

proc call*(call_580107: Call_StorageBucketAccessControlsDelete_580094;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsDelete
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580108 = newJObject()
  var query_580109 = newJObject()
  add(query_580109, "key", newJString(key))
  add(query_580109, "prettyPrint", newJBool(prettyPrint))
  add(query_580109, "oauth_token", newJString(oauthToken))
  add(query_580109, "alt", newJString(alt))
  add(query_580109, "userIp", newJString(userIp))
  add(query_580109, "quotaUser", newJString(quotaUser))
  add(path_580108, "bucket", newJString(bucket))
  add(path_580108, "entity", newJString(entity))
  add(query_580109, "fields", newJString(fields))
  result = call_580107.call(path_580108, query_580109, nil, nil, nil)

var storageBucketAccessControlsDelete* = Call_StorageBucketAccessControlsDelete_580094(
    name: "storageBucketAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsDelete_580095,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsDelete_580096,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsInsert_580145 = ref object of OpenApiRestCall_579380
proc url_StorageDefaultObjectAccessControlsInsert_580147(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsInsert_580146(path: JsonNode;
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
  var valid_580148 = path.getOrDefault("bucket")
  valid_580148 = validateParameter(valid_580148, JString, required = true,
                                 default = nil)
  if valid_580148 != nil:
    section.add "bucket", valid_580148
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580149 = query.getOrDefault("key")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "key", valid_580149
  var valid_580150 = query.getOrDefault("prettyPrint")
  valid_580150 = validateParameter(valid_580150, JBool, required = false,
                                 default = newJBool(true))
  if valid_580150 != nil:
    section.add "prettyPrint", valid_580150
  var valid_580151 = query.getOrDefault("oauth_token")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "oauth_token", valid_580151
  var valid_580152 = query.getOrDefault("alt")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = newJString("json"))
  if valid_580152 != nil:
    section.add "alt", valid_580152
  var valid_580153 = query.getOrDefault("userIp")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "userIp", valid_580153
  var valid_580154 = query.getOrDefault("quotaUser")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "quotaUser", valid_580154
  var valid_580155 = query.getOrDefault("fields")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "fields", valid_580155
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

proc call*(call_580157: Call_StorageDefaultObjectAccessControlsInsert_580145;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new default object ACL entry on the specified bucket.
  ## 
  let valid = call_580157.validator(path, query, header, formData, body)
  let scheme = call_580157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580157.url(scheme.get, call_580157.host, call_580157.base,
                         call_580157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580157, url, valid)

proc call*(call_580158: Call_StorageDefaultObjectAccessControlsInsert_580145;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsInsert
  ## Creates a new default object ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580159 = newJObject()
  var query_580160 = newJObject()
  var body_580161 = newJObject()
  add(query_580160, "key", newJString(key))
  add(query_580160, "prettyPrint", newJBool(prettyPrint))
  add(query_580160, "oauth_token", newJString(oauthToken))
  add(query_580160, "alt", newJString(alt))
  add(query_580160, "userIp", newJString(userIp))
  add(query_580160, "quotaUser", newJString(quotaUser))
  add(path_580159, "bucket", newJString(bucket))
  if body != nil:
    body_580161 = body
  add(query_580160, "fields", newJString(fields))
  result = call_580158.call(path_580159, query_580160, nil, nil, body_580161)

var storageDefaultObjectAccessControlsInsert* = Call_StorageDefaultObjectAccessControlsInsert_580145(
    name: "storageDefaultObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsInsert_580146,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsInsert_580147,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsList_580128 = ref object of OpenApiRestCall_579380
proc url_StorageDefaultObjectAccessControlsList_580130(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsList_580129(path: JsonNode;
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
  var valid_580131 = path.getOrDefault("bucket")
  valid_580131 = validateParameter(valid_580131, JString, required = true,
                                 default = nil)
  if valid_580131 != nil:
    section.add "bucket", valid_580131
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : If present, only return default ACL listing if the bucket's current metageneration matches this value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : If present, only return default ACL listing if the bucket's current metageneration does not match the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580132 = query.getOrDefault("key")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "key", valid_580132
  var valid_580133 = query.getOrDefault("prettyPrint")
  valid_580133 = validateParameter(valid_580133, JBool, required = false,
                                 default = newJBool(true))
  if valid_580133 != nil:
    section.add "prettyPrint", valid_580133
  var valid_580134 = query.getOrDefault("oauth_token")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "oauth_token", valid_580134
  var valid_580135 = query.getOrDefault("alt")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = newJString("json"))
  if valid_580135 != nil:
    section.add "alt", valid_580135
  var valid_580136 = query.getOrDefault("userIp")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "userIp", valid_580136
  var valid_580137 = query.getOrDefault("quotaUser")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "quotaUser", valid_580137
  var valid_580138 = query.getOrDefault("ifMetagenerationMatch")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "ifMetagenerationMatch", valid_580138
  var valid_580139 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "ifMetagenerationNotMatch", valid_580139
  var valid_580140 = query.getOrDefault("fields")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "fields", valid_580140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580141: Call_StorageDefaultObjectAccessControlsList_580128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves default object ACL entries on the specified bucket.
  ## 
  let valid = call_580141.validator(path, query, header, formData, body)
  let scheme = call_580141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580141.url(scheme.get, call_580141.host, call_580141.base,
                         call_580141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580141, url, valid)

proc call*(call_580142: Call_StorageDefaultObjectAccessControlsList_580128;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; ifMetagenerationMatch: string = "";
          ifMetagenerationNotMatch: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsList
  ## Retrieves default object ACL entries on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : If present, only return default ACL listing if the bucket's current metageneration matches this value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : If present, only return default ACL listing if the bucket's current metageneration does not match the given value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580143 = newJObject()
  var query_580144 = newJObject()
  add(query_580144, "key", newJString(key))
  add(query_580144, "prettyPrint", newJBool(prettyPrint))
  add(query_580144, "oauth_token", newJString(oauthToken))
  add(query_580144, "alt", newJString(alt))
  add(query_580144, "userIp", newJString(userIp))
  add(query_580144, "quotaUser", newJString(quotaUser))
  add(query_580144, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580143, "bucket", newJString(bucket))
  add(query_580144, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580144, "fields", newJString(fields))
  result = call_580142.call(path_580143, query_580144, nil, nil, nil)

var storageDefaultObjectAccessControlsList* = Call_StorageDefaultObjectAccessControlsList_580128(
    name: "storageDefaultObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsList_580129,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsList_580130,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsUpdate_580178 = ref object of OpenApiRestCall_579380
proc url_StorageDefaultObjectAccessControlsUpdate_580180(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsUpdate_580179(path: JsonNode;
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
  var valid_580181 = path.getOrDefault("bucket")
  valid_580181 = validateParameter(valid_580181, JString, required = true,
                                 default = nil)
  if valid_580181 != nil:
    section.add "bucket", valid_580181
  var valid_580182 = path.getOrDefault("entity")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "entity", valid_580182
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580183 = query.getOrDefault("key")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "key", valid_580183
  var valid_580184 = query.getOrDefault("prettyPrint")
  valid_580184 = validateParameter(valid_580184, JBool, required = false,
                                 default = newJBool(true))
  if valid_580184 != nil:
    section.add "prettyPrint", valid_580184
  var valid_580185 = query.getOrDefault("oauth_token")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "oauth_token", valid_580185
  var valid_580186 = query.getOrDefault("alt")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("json"))
  if valid_580186 != nil:
    section.add "alt", valid_580186
  var valid_580187 = query.getOrDefault("userIp")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "userIp", valid_580187
  var valid_580188 = query.getOrDefault("quotaUser")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "quotaUser", valid_580188
  var valid_580189 = query.getOrDefault("fields")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "fields", valid_580189
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

proc call*(call_580191: Call_StorageDefaultObjectAccessControlsUpdate_580178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a default object ACL entry on the specified bucket.
  ## 
  let valid = call_580191.validator(path, query, header, formData, body)
  let scheme = call_580191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580191.url(scheme.get, call_580191.host, call_580191.base,
                         call_580191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580191, url, valid)

proc call*(call_580192: Call_StorageDefaultObjectAccessControlsUpdate_580178;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsUpdate
  ## Updates a default object ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580193 = newJObject()
  var query_580194 = newJObject()
  var body_580195 = newJObject()
  add(query_580194, "key", newJString(key))
  add(query_580194, "prettyPrint", newJBool(prettyPrint))
  add(query_580194, "oauth_token", newJString(oauthToken))
  add(query_580194, "alt", newJString(alt))
  add(query_580194, "userIp", newJString(userIp))
  add(query_580194, "quotaUser", newJString(quotaUser))
  add(path_580193, "bucket", newJString(bucket))
  if body != nil:
    body_580195 = body
  add(path_580193, "entity", newJString(entity))
  add(query_580194, "fields", newJString(fields))
  result = call_580192.call(path_580193, query_580194, nil, nil, body_580195)

var storageDefaultObjectAccessControlsUpdate* = Call_StorageDefaultObjectAccessControlsUpdate_580178(
    name: "storageDefaultObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsUpdate_580179,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsUpdate_580180,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsGet_580162 = ref object of OpenApiRestCall_579380
proc url_StorageDefaultObjectAccessControlsGet_580164(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsGet_580163(path: JsonNode;
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
  var valid_580165 = path.getOrDefault("bucket")
  valid_580165 = validateParameter(valid_580165, JString, required = true,
                                 default = nil)
  if valid_580165 != nil:
    section.add "bucket", valid_580165
  var valid_580166 = path.getOrDefault("entity")
  valid_580166 = validateParameter(valid_580166, JString, required = true,
                                 default = nil)
  if valid_580166 != nil:
    section.add "entity", valid_580166
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580167 = query.getOrDefault("key")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "key", valid_580167
  var valid_580168 = query.getOrDefault("prettyPrint")
  valid_580168 = validateParameter(valid_580168, JBool, required = false,
                                 default = newJBool(true))
  if valid_580168 != nil:
    section.add "prettyPrint", valid_580168
  var valid_580169 = query.getOrDefault("oauth_token")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "oauth_token", valid_580169
  var valid_580170 = query.getOrDefault("alt")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("json"))
  if valid_580170 != nil:
    section.add "alt", valid_580170
  var valid_580171 = query.getOrDefault("userIp")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "userIp", valid_580171
  var valid_580172 = query.getOrDefault("quotaUser")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "quotaUser", valid_580172
  var valid_580173 = query.getOrDefault("fields")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "fields", valid_580173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580174: Call_StorageDefaultObjectAccessControlsGet_580162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580174.validator(path, query, header, formData, body)
  let scheme = call_580174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580174.url(scheme.get, call_580174.host, call_580174.base,
                         call_580174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580174, url, valid)

proc call*(call_580175: Call_StorageDefaultObjectAccessControlsGet_580162;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsGet
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580176 = newJObject()
  var query_580177 = newJObject()
  add(query_580177, "key", newJString(key))
  add(query_580177, "prettyPrint", newJBool(prettyPrint))
  add(query_580177, "oauth_token", newJString(oauthToken))
  add(query_580177, "alt", newJString(alt))
  add(query_580177, "userIp", newJString(userIp))
  add(query_580177, "quotaUser", newJString(quotaUser))
  add(path_580176, "bucket", newJString(bucket))
  add(path_580176, "entity", newJString(entity))
  add(query_580177, "fields", newJString(fields))
  result = call_580175.call(path_580176, query_580177, nil, nil, nil)

var storageDefaultObjectAccessControlsGet* = Call_StorageDefaultObjectAccessControlsGet_580162(
    name: "storageDefaultObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsGet_580163,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsGet_580164,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsPatch_580212 = ref object of OpenApiRestCall_579380
proc url_StorageDefaultObjectAccessControlsPatch_580214(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsPatch_580213(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a default object ACL entry on the specified bucket. This method supports patch semantics.
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
  var valid_580215 = path.getOrDefault("bucket")
  valid_580215 = validateParameter(valid_580215, JString, required = true,
                                 default = nil)
  if valid_580215 != nil:
    section.add "bucket", valid_580215
  var valid_580216 = path.getOrDefault("entity")
  valid_580216 = validateParameter(valid_580216, JString, required = true,
                                 default = nil)
  if valid_580216 != nil:
    section.add "entity", valid_580216
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580217 = query.getOrDefault("key")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "key", valid_580217
  var valid_580218 = query.getOrDefault("prettyPrint")
  valid_580218 = validateParameter(valid_580218, JBool, required = false,
                                 default = newJBool(true))
  if valid_580218 != nil:
    section.add "prettyPrint", valid_580218
  var valid_580219 = query.getOrDefault("oauth_token")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "oauth_token", valid_580219
  var valid_580220 = query.getOrDefault("alt")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = newJString("json"))
  if valid_580220 != nil:
    section.add "alt", valid_580220
  var valid_580221 = query.getOrDefault("userIp")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "userIp", valid_580221
  var valid_580222 = query.getOrDefault("quotaUser")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "quotaUser", valid_580222
  var valid_580223 = query.getOrDefault("fields")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "fields", valid_580223
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

proc call*(call_580225: Call_StorageDefaultObjectAccessControlsPatch_580212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a default object ACL entry on the specified bucket. This method supports patch semantics.
  ## 
  let valid = call_580225.validator(path, query, header, formData, body)
  let scheme = call_580225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580225.url(scheme.get, call_580225.host, call_580225.base,
                         call_580225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580225, url, valid)

proc call*(call_580226: Call_StorageDefaultObjectAccessControlsPatch_580212;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsPatch
  ## Updates a default object ACL entry on the specified bucket. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580227 = newJObject()
  var query_580228 = newJObject()
  var body_580229 = newJObject()
  add(query_580228, "key", newJString(key))
  add(query_580228, "prettyPrint", newJBool(prettyPrint))
  add(query_580228, "oauth_token", newJString(oauthToken))
  add(query_580228, "alt", newJString(alt))
  add(query_580228, "userIp", newJString(userIp))
  add(query_580228, "quotaUser", newJString(quotaUser))
  add(path_580227, "bucket", newJString(bucket))
  if body != nil:
    body_580229 = body
  add(path_580227, "entity", newJString(entity))
  add(query_580228, "fields", newJString(fields))
  result = call_580226.call(path_580227, query_580228, nil, nil, body_580229)

var storageDefaultObjectAccessControlsPatch* = Call_StorageDefaultObjectAccessControlsPatch_580212(
    name: "storageDefaultObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsPatch_580213,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsPatch_580214,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsDelete_580196 = ref object of OpenApiRestCall_579380
proc url_StorageDefaultObjectAccessControlsDelete_580198(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsDelete_580197(path: JsonNode;
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
  var valid_580199 = path.getOrDefault("bucket")
  valid_580199 = validateParameter(valid_580199, JString, required = true,
                                 default = nil)
  if valid_580199 != nil:
    section.add "bucket", valid_580199
  var valid_580200 = path.getOrDefault("entity")
  valid_580200 = validateParameter(valid_580200, JString, required = true,
                                 default = nil)
  if valid_580200 != nil:
    section.add "entity", valid_580200
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580201 = query.getOrDefault("key")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "key", valid_580201
  var valid_580202 = query.getOrDefault("prettyPrint")
  valid_580202 = validateParameter(valid_580202, JBool, required = false,
                                 default = newJBool(true))
  if valid_580202 != nil:
    section.add "prettyPrint", valid_580202
  var valid_580203 = query.getOrDefault("oauth_token")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "oauth_token", valid_580203
  var valid_580204 = query.getOrDefault("alt")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = newJString("json"))
  if valid_580204 != nil:
    section.add "alt", valid_580204
  var valid_580205 = query.getOrDefault("userIp")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "userIp", valid_580205
  var valid_580206 = query.getOrDefault("quotaUser")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "quotaUser", valid_580206
  var valid_580207 = query.getOrDefault("fields")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "fields", valid_580207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580208: Call_StorageDefaultObjectAccessControlsDelete_580196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580208.validator(path, query, header, formData, body)
  let scheme = call_580208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580208.url(scheme.get, call_580208.host, call_580208.base,
                         call_580208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580208, url, valid)

proc call*(call_580209: Call_StorageDefaultObjectAccessControlsDelete_580196;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsDelete
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580210 = newJObject()
  var query_580211 = newJObject()
  add(query_580211, "key", newJString(key))
  add(query_580211, "prettyPrint", newJBool(prettyPrint))
  add(query_580211, "oauth_token", newJString(oauthToken))
  add(query_580211, "alt", newJString(alt))
  add(query_580211, "userIp", newJString(userIp))
  add(query_580211, "quotaUser", newJString(quotaUser))
  add(path_580210, "bucket", newJString(bucket))
  add(path_580210, "entity", newJString(entity))
  add(query_580211, "fields", newJString(fields))
  result = call_580209.call(path_580210, query_580211, nil, nil, nil)

var storageDefaultObjectAccessControlsDelete* = Call_StorageDefaultObjectAccessControlsDelete_580196(
    name: "storageDefaultObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsDelete_580197,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsDelete_580198,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsInsert_580251 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsInsert_580253(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsInsert_580252(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stores new data blobs and associated metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580254 = path.getOrDefault("bucket")
  valid_580254 = validateParameter(valid_580254, JString, required = true,
                                 default = nil)
  if valid_580254 != nil:
    section.add "bucket", valid_580254
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : Name of the object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580255 = query.getOrDefault("key")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "key", valid_580255
  var valid_580256 = query.getOrDefault("prettyPrint")
  valid_580256 = validateParameter(valid_580256, JBool, required = false,
                                 default = newJBool(true))
  if valid_580256 != nil:
    section.add "prettyPrint", valid_580256
  var valid_580257 = query.getOrDefault("oauth_token")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "oauth_token", valid_580257
  var valid_580258 = query.getOrDefault("name")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "name", valid_580258
  var valid_580259 = query.getOrDefault("ifGenerationMatch")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "ifGenerationMatch", valid_580259
  var valid_580260 = query.getOrDefault("ifGenerationNotMatch")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "ifGenerationNotMatch", valid_580260
  var valid_580261 = query.getOrDefault("alt")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = newJString("json"))
  if valid_580261 != nil:
    section.add "alt", valid_580261
  var valid_580262 = query.getOrDefault("userIp")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "userIp", valid_580262
  var valid_580263 = query.getOrDefault("quotaUser")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "quotaUser", valid_580263
  var valid_580264 = query.getOrDefault("ifMetagenerationMatch")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "ifMetagenerationMatch", valid_580264
  var valid_580265 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "ifMetagenerationNotMatch", valid_580265
  var valid_580266 = query.getOrDefault("projection")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = newJString("full"))
  if valid_580266 != nil:
    section.add "projection", valid_580266
  var valid_580267 = query.getOrDefault("fields")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "fields", valid_580267
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

proc call*(call_580269: Call_StorageObjectsInsert_580251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stores new data blobs and associated metadata.
  ## 
  let valid = call_580269.validator(path, query, header, formData, body)
  let scheme = call_580269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580269.url(scheme.get, call_580269.host, call_580269.base,
                         call_580269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580269, url, valid)

proc call*(call_580270: Call_StorageObjectsInsert_580251; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          name: string = ""; ifGenerationMatch: string = "";
          ifGenerationNotMatch: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; ifMetagenerationMatch: string = "";
          body: JsonNode = nil; ifMetagenerationNotMatch: string = "";
          projection: string = "full"; fields: string = ""): Recallable =
  ## storageObjectsInsert
  ## Stores new data blobs and associated metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : Name of the object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   body: JObject
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580271 = newJObject()
  var query_580272 = newJObject()
  var body_580273 = newJObject()
  add(query_580272, "key", newJString(key))
  add(query_580272, "prettyPrint", newJBool(prettyPrint))
  add(query_580272, "oauth_token", newJString(oauthToken))
  add(query_580272, "name", newJString(name))
  add(query_580272, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580272, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580272, "alt", newJString(alt))
  add(query_580272, "userIp", newJString(userIp))
  add(query_580272, "quotaUser", newJString(quotaUser))
  add(query_580272, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580271, "bucket", newJString(bucket))
  if body != nil:
    body_580273 = body
  add(query_580272, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580272, "projection", newJString(projection))
  add(query_580272, "fields", newJString(fields))
  result = call_580270.call(path_580271, query_580272, nil, nil, body_580273)

var storageObjectsInsert* = Call_StorageObjectsInsert_580251(
    name: "storageObjectsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsInsert_580252, base: "/storage/v1beta2",
    url: url_StorageObjectsInsert_580253, schemes: {Scheme.Https})
type
  Call_StorageObjectsList_580230 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsList_580232(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsList_580231(path: JsonNode; query: JsonNode;
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
  var valid_580233 = path.getOrDefault("bucket")
  valid_580233 = validateParameter(valid_580233, JString, required = true,
                                 default = nil)
  if valid_580233 != nil:
    section.add "bucket", valid_580233
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   prefix: JString
  ##         : Filter results to objects whose names begin with this prefix.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: JString
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   maxResults: JInt
  ##             : Maximum number of items plus prefixes to return. As duplicate prefixes are omitted, fewer total results may be returned than requested.
  ##   versions: JBool
  ##           : If true, lists all versions of a file as distinct results.
  section = newJObject()
  var valid_580234 = query.getOrDefault("key")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "key", valid_580234
  var valid_580235 = query.getOrDefault("prettyPrint")
  valid_580235 = validateParameter(valid_580235, JBool, required = false,
                                 default = newJBool(true))
  if valid_580235 != nil:
    section.add "prettyPrint", valid_580235
  var valid_580236 = query.getOrDefault("oauth_token")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "oauth_token", valid_580236
  var valid_580237 = query.getOrDefault("prefix")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "prefix", valid_580237
  var valid_580238 = query.getOrDefault("alt")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = newJString("json"))
  if valid_580238 != nil:
    section.add "alt", valid_580238
  var valid_580239 = query.getOrDefault("userIp")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "userIp", valid_580239
  var valid_580240 = query.getOrDefault("quotaUser")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "quotaUser", valid_580240
  var valid_580241 = query.getOrDefault("pageToken")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "pageToken", valid_580241
  var valid_580242 = query.getOrDefault("projection")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = newJString("full"))
  if valid_580242 != nil:
    section.add "projection", valid_580242
  var valid_580243 = query.getOrDefault("fields")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "fields", valid_580243
  var valid_580244 = query.getOrDefault("delimiter")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "delimiter", valid_580244
  var valid_580245 = query.getOrDefault("maxResults")
  valid_580245 = validateParameter(valid_580245, JInt, required = false, default = nil)
  if valid_580245 != nil:
    section.add "maxResults", valid_580245
  var valid_580246 = query.getOrDefault("versions")
  valid_580246 = validateParameter(valid_580246, JBool, required = false, default = nil)
  if valid_580246 != nil:
    section.add "versions", valid_580246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580247: Call_StorageObjectsList_580230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of objects matching the criteria.
  ## 
  let valid = call_580247.validator(path, query, header, formData, body)
  let scheme = call_580247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580247.url(scheme.get, call_580247.host, call_580247.base,
                         call_580247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580247, url, valid)

proc call*(call_580248: Call_StorageObjectsList_580230; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          prefix: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; projection: string = "full";
          fields: string = ""; delimiter: string = ""; maxResults: int = 0;
          versions: bool = false): Recallable =
  ## storageObjectsList
  ## Retrieves a list of objects matching the criteria.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   prefix: string
  ##         : Filter results to objects whose names begin with this prefix.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   bucket: string (required)
  ##         : Name of the bucket in which to look for objects.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: string
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   maxResults: int
  ##             : Maximum number of items plus prefixes to return. As duplicate prefixes are omitted, fewer total results may be returned than requested.
  ##   versions: bool
  ##           : If true, lists all versions of a file as distinct results.
  var path_580249 = newJObject()
  var query_580250 = newJObject()
  add(query_580250, "key", newJString(key))
  add(query_580250, "prettyPrint", newJBool(prettyPrint))
  add(query_580250, "oauth_token", newJString(oauthToken))
  add(query_580250, "prefix", newJString(prefix))
  add(query_580250, "alt", newJString(alt))
  add(query_580250, "userIp", newJString(userIp))
  add(query_580250, "quotaUser", newJString(quotaUser))
  add(query_580250, "pageToken", newJString(pageToken))
  add(path_580249, "bucket", newJString(bucket))
  add(query_580250, "projection", newJString(projection))
  add(query_580250, "fields", newJString(fields))
  add(query_580250, "delimiter", newJString(delimiter))
  add(query_580250, "maxResults", newJInt(maxResults))
  add(query_580250, "versions", newJBool(versions))
  result = call_580248.call(path_580249, query_580250, nil, nil, nil)

var storageObjectsList* = Call_StorageObjectsList_580230(
    name: "storageObjectsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsList_580231, base: "/storage/v1beta2",
    url: url_StorageObjectsList_580232, schemes: {Scheme.Https})
type
  Call_StorageObjectsWatchAll_580274 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsWatchAll_580276(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsWatchAll_580275(path: JsonNode; query: JsonNode;
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
  var valid_580277 = path.getOrDefault("bucket")
  valid_580277 = validateParameter(valid_580277, JString, required = true,
                                 default = nil)
  if valid_580277 != nil:
    section.add "bucket", valid_580277
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   prefix: JString
  ##         : Filter results to objects whose names begin with this prefix.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: JString
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   maxResults: JInt
  ##             : Maximum number of items plus prefixes to return. As duplicate prefixes are omitted, fewer total results may be returned than requested.
  ##   versions: JBool
  ##           : If true, lists all versions of a file as distinct results.
  section = newJObject()
  var valid_580278 = query.getOrDefault("key")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "key", valid_580278
  var valid_580279 = query.getOrDefault("prettyPrint")
  valid_580279 = validateParameter(valid_580279, JBool, required = false,
                                 default = newJBool(true))
  if valid_580279 != nil:
    section.add "prettyPrint", valid_580279
  var valid_580280 = query.getOrDefault("oauth_token")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "oauth_token", valid_580280
  var valid_580281 = query.getOrDefault("prefix")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "prefix", valid_580281
  var valid_580282 = query.getOrDefault("alt")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = newJString("json"))
  if valid_580282 != nil:
    section.add "alt", valid_580282
  var valid_580283 = query.getOrDefault("userIp")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "userIp", valid_580283
  var valid_580284 = query.getOrDefault("quotaUser")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "quotaUser", valid_580284
  var valid_580285 = query.getOrDefault("pageToken")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "pageToken", valid_580285
  var valid_580286 = query.getOrDefault("projection")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = newJString("full"))
  if valid_580286 != nil:
    section.add "projection", valid_580286
  var valid_580287 = query.getOrDefault("fields")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "fields", valid_580287
  var valid_580288 = query.getOrDefault("delimiter")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "delimiter", valid_580288
  var valid_580289 = query.getOrDefault("maxResults")
  valid_580289 = validateParameter(valid_580289, JInt, required = false, default = nil)
  if valid_580289 != nil:
    section.add "maxResults", valid_580289
  var valid_580290 = query.getOrDefault("versions")
  valid_580290 = validateParameter(valid_580290, JBool, required = false, default = nil)
  if valid_580290 != nil:
    section.add "versions", valid_580290
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

proc call*(call_580292: Call_StorageObjectsWatchAll_580274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes on all objects in a bucket.
  ## 
  let valid = call_580292.validator(path, query, header, formData, body)
  let scheme = call_580292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580292.url(scheme.get, call_580292.host, call_580292.base,
                         call_580292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580292, url, valid)

proc call*(call_580293: Call_StorageObjectsWatchAll_580274; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          prefix: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; resource: JsonNode = nil;
          projection: string = "full"; fields: string = ""; delimiter: string = "";
          maxResults: int = 0; versions: bool = false): Recallable =
  ## storageObjectsWatchAll
  ## Watch for changes on all objects in a bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   prefix: string
  ##         : Filter results to objects whose names begin with this prefix.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   bucket: string (required)
  ##         : Name of the bucket in which to look for objects.
  ##   resource: JObject
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: string
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   maxResults: int
  ##             : Maximum number of items plus prefixes to return. As duplicate prefixes are omitted, fewer total results may be returned than requested.
  ##   versions: bool
  ##           : If true, lists all versions of a file as distinct results.
  var path_580294 = newJObject()
  var query_580295 = newJObject()
  var body_580296 = newJObject()
  add(query_580295, "key", newJString(key))
  add(query_580295, "prettyPrint", newJBool(prettyPrint))
  add(query_580295, "oauth_token", newJString(oauthToken))
  add(query_580295, "prefix", newJString(prefix))
  add(query_580295, "alt", newJString(alt))
  add(query_580295, "userIp", newJString(userIp))
  add(query_580295, "quotaUser", newJString(quotaUser))
  add(query_580295, "pageToken", newJString(pageToken))
  add(path_580294, "bucket", newJString(bucket))
  if resource != nil:
    body_580296 = resource
  add(query_580295, "projection", newJString(projection))
  add(query_580295, "fields", newJString(fields))
  add(query_580295, "delimiter", newJString(delimiter))
  add(query_580295, "maxResults", newJInt(maxResults))
  add(query_580295, "versions", newJBool(versions))
  result = call_580293.call(path_580294, query_580295, nil, nil, body_580296)

var storageObjectsWatchAll* = Call_StorageObjectsWatchAll_580274(
    name: "storageObjectsWatchAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o/watch",
    validator: validate_StorageObjectsWatchAll_580275, base: "/storage/v1beta2",
    url: url_StorageObjectsWatchAll_580276, schemes: {Scheme.Https})
type
  Call_StorageObjectsUpdate_580319 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsUpdate_580321(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsUpdate_580320(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a data blob's associated metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580322 = path.getOrDefault("bucket")
  valid_580322 = validateParameter(valid_580322, JString, required = true,
                                 default = nil)
  if valid_580322 != nil:
    section.add "bucket", valid_580322
  var valid_580323 = path.getOrDefault("object")
  valid_580323 = validateParameter(valid_580323, JString, required = true,
                                 default = nil)
  if valid_580323 != nil:
    section.add "object", valid_580323
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580324 = query.getOrDefault("key")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "key", valid_580324
  var valid_580325 = query.getOrDefault("prettyPrint")
  valid_580325 = validateParameter(valid_580325, JBool, required = false,
                                 default = newJBool(true))
  if valid_580325 != nil:
    section.add "prettyPrint", valid_580325
  var valid_580326 = query.getOrDefault("oauth_token")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "oauth_token", valid_580326
  var valid_580327 = query.getOrDefault("generation")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "generation", valid_580327
  var valid_580328 = query.getOrDefault("ifGenerationMatch")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "ifGenerationMatch", valid_580328
  var valid_580329 = query.getOrDefault("ifGenerationNotMatch")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "ifGenerationNotMatch", valid_580329
  var valid_580330 = query.getOrDefault("alt")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = newJString("json"))
  if valid_580330 != nil:
    section.add "alt", valid_580330
  var valid_580331 = query.getOrDefault("userIp")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "userIp", valid_580331
  var valid_580332 = query.getOrDefault("quotaUser")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "quotaUser", valid_580332
  var valid_580333 = query.getOrDefault("ifMetagenerationMatch")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "ifMetagenerationMatch", valid_580333
  var valid_580334 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "ifMetagenerationNotMatch", valid_580334
  var valid_580335 = query.getOrDefault("projection")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = newJString("full"))
  if valid_580335 != nil:
    section.add "projection", valid_580335
  var valid_580336 = query.getOrDefault("fields")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "fields", valid_580336
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

proc call*(call_580338: Call_StorageObjectsUpdate_580319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a data blob's associated metadata.
  ## 
  let valid = call_580338.validator(path, query, header, formData, body)
  let scheme = call_580338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580338.url(scheme.get, call_580338.host, call_580338.base,
                         call_580338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580338, url, valid)

proc call*(call_580339: Call_StorageObjectsUpdate_580319; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = "";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsUpdate
  ## Updates a data blob's associated metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   body: JObject
  ##   object: string (required)
  ##         : Name of the object.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580340 = newJObject()
  var query_580341 = newJObject()
  var body_580342 = newJObject()
  add(query_580341, "key", newJString(key))
  add(query_580341, "prettyPrint", newJBool(prettyPrint))
  add(query_580341, "oauth_token", newJString(oauthToken))
  add(query_580341, "generation", newJString(generation))
  add(query_580341, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580341, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580341, "alt", newJString(alt))
  add(query_580341, "userIp", newJString(userIp))
  add(query_580341, "quotaUser", newJString(quotaUser))
  add(query_580341, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580340, "bucket", newJString(bucket))
  if body != nil:
    body_580342 = body
  add(path_580340, "object", newJString(`object`))
  add(query_580341, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580341, "projection", newJString(projection))
  add(query_580341, "fields", newJString(fields))
  result = call_580339.call(path_580340, query_580341, nil, nil, body_580342)

var storageObjectsUpdate* = Call_StorageObjectsUpdate_580319(
    name: "storageObjectsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsUpdate_580320, base: "/storage/v1beta2",
    url: url_StorageObjectsUpdate_580321, schemes: {Scheme.Https})
type
  Call_StorageObjectsGet_580297 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsGet_580299(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsGet_580298(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves objects or their associated metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580300 = path.getOrDefault("bucket")
  valid_580300 = validateParameter(valid_580300, JString, required = true,
                                 default = nil)
  if valid_580300 != nil:
    section.add "bucket", valid_580300
  var valid_580301 = path.getOrDefault("object")
  valid_580301 = validateParameter(valid_580301, JString, required = true,
                                 default = nil)
  if valid_580301 != nil:
    section.add "object", valid_580301
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's generation matches the given value.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's generation does not match the given value.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580302 = query.getOrDefault("key")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "key", valid_580302
  var valid_580303 = query.getOrDefault("prettyPrint")
  valid_580303 = validateParameter(valid_580303, JBool, required = false,
                                 default = newJBool(true))
  if valid_580303 != nil:
    section.add "prettyPrint", valid_580303
  var valid_580304 = query.getOrDefault("oauth_token")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "oauth_token", valid_580304
  var valid_580305 = query.getOrDefault("generation")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "generation", valid_580305
  var valid_580306 = query.getOrDefault("ifGenerationMatch")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "ifGenerationMatch", valid_580306
  var valid_580307 = query.getOrDefault("ifGenerationNotMatch")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "ifGenerationNotMatch", valid_580307
  var valid_580308 = query.getOrDefault("alt")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = newJString("json"))
  if valid_580308 != nil:
    section.add "alt", valid_580308
  var valid_580309 = query.getOrDefault("userIp")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "userIp", valid_580309
  var valid_580310 = query.getOrDefault("quotaUser")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "quotaUser", valid_580310
  var valid_580311 = query.getOrDefault("ifMetagenerationMatch")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "ifMetagenerationMatch", valid_580311
  var valid_580312 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "ifMetagenerationNotMatch", valid_580312
  var valid_580313 = query.getOrDefault("projection")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = newJString("full"))
  if valid_580313 != nil:
    section.add "projection", valid_580313
  var valid_580314 = query.getOrDefault("fields")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "fields", valid_580314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580315: Call_StorageObjectsGet_580297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves objects or their associated metadata.
  ## 
  let valid = call_580315.validator(path, query, header, formData, body)
  let scheme = call_580315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580315.url(scheme.get, call_580315.host, call_580315.base,
                         call_580315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580315, url, valid)

proc call*(call_580316: Call_StorageObjectsGet_580297; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = "";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; ifMetagenerationNotMatch: string = "";
          projection: string = "full"; fields: string = ""): Recallable =
  ## storageObjectsGet
  ## Retrieves objects or their associated metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's generation matches the given value.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's generation does not match the given value.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: string (required)
  ##         : Name of the object.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580317 = newJObject()
  var query_580318 = newJObject()
  add(query_580318, "key", newJString(key))
  add(query_580318, "prettyPrint", newJBool(prettyPrint))
  add(query_580318, "oauth_token", newJString(oauthToken))
  add(query_580318, "generation", newJString(generation))
  add(query_580318, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580318, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580318, "alt", newJString(alt))
  add(query_580318, "userIp", newJString(userIp))
  add(query_580318, "quotaUser", newJString(quotaUser))
  add(query_580318, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580317, "bucket", newJString(bucket))
  add(path_580317, "object", newJString(`object`))
  add(query_580318, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580318, "projection", newJString(projection))
  add(query_580318, "fields", newJString(fields))
  result = call_580316.call(path_580317, query_580318, nil, nil, nil)

var storageObjectsGet* = Call_StorageObjectsGet_580297(name: "storageObjectsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/b/{bucket}/o/{object}", validator: validate_StorageObjectsGet_580298,
    base: "/storage/v1beta2", url: url_StorageObjectsGet_580299,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsPatch_580364 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsPatch_580366(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsPatch_580365(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a data blob's associated metadata. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580367 = path.getOrDefault("bucket")
  valid_580367 = validateParameter(valid_580367, JString, required = true,
                                 default = nil)
  if valid_580367 != nil:
    section.add "bucket", valid_580367
  var valid_580368 = path.getOrDefault("object")
  valid_580368 = validateParameter(valid_580368, JString, required = true,
                                 default = nil)
  if valid_580368 != nil:
    section.add "object", valid_580368
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580369 = query.getOrDefault("key")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "key", valid_580369
  var valid_580370 = query.getOrDefault("prettyPrint")
  valid_580370 = validateParameter(valid_580370, JBool, required = false,
                                 default = newJBool(true))
  if valid_580370 != nil:
    section.add "prettyPrint", valid_580370
  var valid_580371 = query.getOrDefault("oauth_token")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "oauth_token", valid_580371
  var valid_580372 = query.getOrDefault("generation")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "generation", valid_580372
  var valid_580373 = query.getOrDefault("ifGenerationMatch")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "ifGenerationMatch", valid_580373
  var valid_580374 = query.getOrDefault("ifGenerationNotMatch")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "ifGenerationNotMatch", valid_580374
  var valid_580375 = query.getOrDefault("alt")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = newJString("json"))
  if valid_580375 != nil:
    section.add "alt", valid_580375
  var valid_580376 = query.getOrDefault("userIp")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "userIp", valid_580376
  var valid_580377 = query.getOrDefault("quotaUser")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "quotaUser", valid_580377
  var valid_580378 = query.getOrDefault("ifMetagenerationMatch")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "ifMetagenerationMatch", valid_580378
  var valid_580379 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "ifMetagenerationNotMatch", valid_580379
  var valid_580380 = query.getOrDefault("projection")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = newJString("full"))
  if valid_580380 != nil:
    section.add "projection", valid_580380
  var valid_580381 = query.getOrDefault("fields")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "fields", valid_580381
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

proc call*(call_580383: Call_StorageObjectsPatch_580364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a data blob's associated metadata. This method supports patch semantics.
  ## 
  let valid = call_580383.validator(path, query, header, formData, body)
  let scheme = call_580383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580383.url(scheme.get, call_580383.host, call_580383.base,
                         call_580383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580383, url, valid)

proc call*(call_580384: Call_StorageObjectsPatch_580364; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = "";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsPatch
  ## Updates a data blob's associated metadata. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   body: JObject
  ##   object: string (required)
  ##         : Name of the object.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580385 = newJObject()
  var query_580386 = newJObject()
  var body_580387 = newJObject()
  add(query_580386, "key", newJString(key))
  add(query_580386, "prettyPrint", newJBool(prettyPrint))
  add(query_580386, "oauth_token", newJString(oauthToken))
  add(query_580386, "generation", newJString(generation))
  add(query_580386, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580386, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580386, "alt", newJString(alt))
  add(query_580386, "userIp", newJString(userIp))
  add(query_580386, "quotaUser", newJString(quotaUser))
  add(query_580386, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580385, "bucket", newJString(bucket))
  if body != nil:
    body_580387 = body
  add(path_580385, "object", newJString(`object`))
  add(query_580386, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580386, "projection", newJString(projection))
  add(query_580386, "fields", newJString(fields))
  result = call_580384.call(path_580385, query_580386, nil, nil, body_580387)

var storageObjectsPatch* = Call_StorageObjectsPatch_580364(
    name: "storageObjectsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsPatch_580365, base: "/storage/v1beta2",
    url: url_StorageObjectsPatch_580366, schemes: {Scheme.Https})
type
  Call_StorageObjectsDelete_580343 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsDelete_580345(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsDelete_580344(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes data blobs and associated metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580346 = path.getOrDefault("bucket")
  valid_580346 = validateParameter(valid_580346, JString, required = true,
                                 default = nil)
  if valid_580346 != nil:
    section.add "bucket", valid_580346
  var valid_580347 = path.getOrDefault("object")
  valid_580347 = validateParameter(valid_580347, JString, required = true,
                                 default = nil)
  if valid_580347 != nil:
    section.add "object", valid_580347
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, permanently deletes a specific revision of this object (as opposed to the latest version, the default).
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580348 = query.getOrDefault("key")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "key", valid_580348
  var valid_580349 = query.getOrDefault("prettyPrint")
  valid_580349 = validateParameter(valid_580349, JBool, required = false,
                                 default = newJBool(true))
  if valid_580349 != nil:
    section.add "prettyPrint", valid_580349
  var valid_580350 = query.getOrDefault("oauth_token")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "oauth_token", valid_580350
  var valid_580351 = query.getOrDefault("generation")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "generation", valid_580351
  var valid_580352 = query.getOrDefault("ifGenerationMatch")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "ifGenerationMatch", valid_580352
  var valid_580353 = query.getOrDefault("ifGenerationNotMatch")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "ifGenerationNotMatch", valid_580353
  var valid_580354 = query.getOrDefault("alt")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = newJString("json"))
  if valid_580354 != nil:
    section.add "alt", valid_580354
  var valid_580355 = query.getOrDefault("userIp")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "userIp", valid_580355
  var valid_580356 = query.getOrDefault("quotaUser")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "quotaUser", valid_580356
  var valid_580357 = query.getOrDefault("ifMetagenerationMatch")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "ifMetagenerationMatch", valid_580357
  var valid_580358 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "ifMetagenerationNotMatch", valid_580358
  var valid_580359 = query.getOrDefault("fields")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "fields", valid_580359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580360: Call_StorageObjectsDelete_580343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes data blobs and associated metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ## 
  let valid = call_580360.validator(path, query, header, formData, body)
  let scheme = call_580360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580360.url(scheme.get, call_580360.host, call_580360.base,
                         call_580360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580360, url, valid)

proc call*(call_580361: Call_StorageObjectsDelete_580343; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = "";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; ifMetagenerationNotMatch: string = "";
          fields: string = ""): Recallable =
  ## storageObjectsDelete
  ## Deletes data blobs and associated metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, permanently deletes a specific revision of this object (as opposed to the latest version, the default).
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: string (required)
  ##         : Name of the object.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580362 = newJObject()
  var query_580363 = newJObject()
  add(query_580363, "key", newJString(key))
  add(query_580363, "prettyPrint", newJBool(prettyPrint))
  add(query_580363, "oauth_token", newJString(oauthToken))
  add(query_580363, "generation", newJString(generation))
  add(query_580363, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580363, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580363, "alt", newJString(alt))
  add(query_580363, "userIp", newJString(userIp))
  add(query_580363, "quotaUser", newJString(quotaUser))
  add(query_580363, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_580362, "bucket", newJString(bucket))
  add(path_580362, "object", newJString(`object`))
  add(query_580363, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580363, "fields", newJString(fields))
  result = call_580361.call(path_580362, query_580363, nil, nil, nil)

var storageObjectsDelete* = Call_StorageObjectsDelete_580343(
    name: "storageObjectsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsDelete_580344, base: "/storage/v1beta2",
    url: url_StorageObjectsDelete_580345, schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsInsert_580405 = ref object of OpenApiRestCall_579380
proc url_StorageObjectAccessControlsInsert_580407(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsInsert_580406(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new ACL entry on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580408 = path.getOrDefault("bucket")
  valid_580408 = validateParameter(valid_580408, JString, required = true,
                                 default = nil)
  if valid_580408 != nil:
    section.add "bucket", valid_580408
  var valid_580409 = path.getOrDefault("object")
  valid_580409 = validateParameter(valid_580409, JString, required = true,
                                 default = nil)
  if valid_580409 != nil:
    section.add "object", valid_580409
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580410 = query.getOrDefault("key")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "key", valid_580410
  var valid_580411 = query.getOrDefault("prettyPrint")
  valid_580411 = validateParameter(valid_580411, JBool, required = false,
                                 default = newJBool(true))
  if valid_580411 != nil:
    section.add "prettyPrint", valid_580411
  var valid_580412 = query.getOrDefault("oauth_token")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "oauth_token", valid_580412
  var valid_580413 = query.getOrDefault("generation")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "generation", valid_580413
  var valid_580414 = query.getOrDefault("alt")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = newJString("json"))
  if valid_580414 != nil:
    section.add "alt", valid_580414
  var valid_580415 = query.getOrDefault("userIp")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "userIp", valid_580415
  var valid_580416 = query.getOrDefault("quotaUser")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "quotaUser", valid_580416
  var valid_580417 = query.getOrDefault("fields")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "fields", valid_580417
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

proc call*(call_580419: Call_StorageObjectAccessControlsInsert_580405;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified object.
  ## 
  let valid = call_580419.validator(path, query, header, formData, body)
  let scheme = call_580419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580419.url(scheme.get, call_580419.host, call_580419.base,
                         call_580419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580419, url, valid)

proc call*(call_580420: Call_StorageObjectAccessControlsInsert_580405;
          bucket: string; `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## storageObjectAccessControlsInsert
  ## Creates a new ACL entry on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   object: string (required)
  ##         : Name of the object.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580421 = newJObject()
  var query_580422 = newJObject()
  var body_580423 = newJObject()
  add(query_580422, "key", newJString(key))
  add(query_580422, "prettyPrint", newJBool(prettyPrint))
  add(query_580422, "oauth_token", newJString(oauthToken))
  add(query_580422, "generation", newJString(generation))
  add(query_580422, "alt", newJString(alt))
  add(query_580422, "userIp", newJString(userIp))
  add(query_580422, "quotaUser", newJString(quotaUser))
  add(path_580421, "bucket", newJString(bucket))
  if body != nil:
    body_580423 = body
  add(path_580421, "object", newJString(`object`))
  add(query_580422, "fields", newJString(fields))
  result = call_580420.call(path_580421, query_580422, nil, nil, body_580423)

var storageObjectAccessControlsInsert* = Call_StorageObjectAccessControlsInsert_580405(
    name: "storageObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsInsert_580406,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsInsert_580407,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsList_580388 = ref object of OpenApiRestCall_579380
proc url_StorageObjectAccessControlsList_580390(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsList_580389(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves ACL entries on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580391 = path.getOrDefault("bucket")
  valid_580391 = validateParameter(valid_580391, JString, required = true,
                                 default = nil)
  if valid_580391 != nil:
    section.add "bucket", valid_580391
  var valid_580392 = path.getOrDefault("object")
  valid_580392 = validateParameter(valid_580392, JString, required = true,
                                 default = nil)
  if valid_580392 != nil:
    section.add "object", valid_580392
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580393 = query.getOrDefault("key")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "key", valid_580393
  var valid_580394 = query.getOrDefault("prettyPrint")
  valid_580394 = validateParameter(valid_580394, JBool, required = false,
                                 default = newJBool(true))
  if valid_580394 != nil:
    section.add "prettyPrint", valid_580394
  var valid_580395 = query.getOrDefault("oauth_token")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "oauth_token", valid_580395
  var valid_580396 = query.getOrDefault("generation")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "generation", valid_580396
  var valid_580397 = query.getOrDefault("alt")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = newJString("json"))
  if valid_580397 != nil:
    section.add "alt", valid_580397
  var valid_580398 = query.getOrDefault("userIp")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "userIp", valid_580398
  var valid_580399 = query.getOrDefault("quotaUser")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "quotaUser", valid_580399
  var valid_580400 = query.getOrDefault("fields")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "fields", valid_580400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580401: Call_StorageObjectAccessControlsList_580388;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified object.
  ## 
  let valid = call_580401.validator(path, query, header, formData, body)
  let scheme = call_580401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580401.url(scheme.get, call_580401.host, call_580401.base,
                         call_580401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580401, url, valid)

proc call*(call_580402: Call_StorageObjectAccessControlsList_580388;
          bucket: string; `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageObjectAccessControlsList
  ## Retrieves ACL entries on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   object: string (required)
  ##         : Name of the object.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580403 = newJObject()
  var query_580404 = newJObject()
  add(query_580404, "key", newJString(key))
  add(query_580404, "prettyPrint", newJBool(prettyPrint))
  add(query_580404, "oauth_token", newJString(oauthToken))
  add(query_580404, "generation", newJString(generation))
  add(query_580404, "alt", newJString(alt))
  add(query_580404, "userIp", newJString(userIp))
  add(query_580404, "quotaUser", newJString(quotaUser))
  add(path_580403, "bucket", newJString(bucket))
  add(path_580403, "object", newJString(`object`))
  add(query_580404, "fields", newJString(fields))
  result = call_580402.call(path_580403, query_580404, nil, nil, nil)

var storageObjectAccessControlsList* = Call_StorageObjectAccessControlsList_580388(
    name: "storageObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsList_580389,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsList_580390,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsUpdate_580442 = ref object of OpenApiRestCall_579380
proc url_StorageObjectAccessControlsUpdate_580444(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsUpdate_580443(path: JsonNode;
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
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580445 = path.getOrDefault("bucket")
  valid_580445 = validateParameter(valid_580445, JString, required = true,
                                 default = nil)
  if valid_580445 != nil:
    section.add "bucket", valid_580445
  var valid_580446 = path.getOrDefault("entity")
  valid_580446 = validateParameter(valid_580446, JString, required = true,
                                 default = nil)
  if valid_580446 != nil:
    section.add "entity", valid_580446
  var valid_580447 = path.getOrDefault("object")
  valid_580447 = validateParameter(valid_580447, JString, required = true,
                                 default = nil)
  if valid_580447 != nil:
    section.add "object", valid_580447
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580448 = query.getOrDefault("key")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "key", valid_580448
  var valid_580449 = query.getOrDefault("prettyPrint")
  valid_580449 = validateParameter(valid_580449, JBool, required = false,
                                 default = newJBool(true))
  if valid_580449 != nil:
    section.add "prettyPrint", valid_580449
  var valid_580450 = query.getOrDefault("oauth_token")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "oauth_token", valid_580450
  var valid_580451 = query.getOrDefault("generation")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "generation", valid_580451
  var valid_580452 = query.getOrDefault("alt")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = newJString("json"))
  if valid_580452 != nil:
    section.add "alt", valid_580452
  var valid_580453 = query.getOrDefault("userIp")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "userIp", valid_580453
  var valid_580454 = query.getOrDefault("quotaUser")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "quotaUser", valid_580454
  var valid_580455 = query.getOrDefault("fields")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "fields", valid_580455
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

proc call*(call_580457: Call_StorageObjectAccessControlsUpdate_580442;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object.
  ## 
  let valid = call_580457.validator(path, query, header, formData, body)
  let scheme = call_580457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580457.url(scheme.get, call_580457.host, call_580457.base,
                         call_580457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580457, url, valid)

proc call*(call_580458: Call_StorageObjectAccessControlsUpdate_580442;
          bucket: string; entity: string; `object`: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; generation: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageObjectAccessControlsUpdate
  ## Updates an ACL entry on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580459 = newJObject()
  var query_580460 = newJObject()
  var body_580461 = newJObject()
  add(query_580460, "key", newJString(key))
  add(query_580460, "prettyPrint", newJBool(prettyPrint))
  add(query_580460, "oauth_token", newJString(oauthToken))
  add(query_580460, "generation", newJString(generation))
  add(query_580460, "alt", newJString(alt))
  add(query_580460, "userIp", newJString(userIp))
  add(query_580460, "quotaUser", newJString(quotaUser))
  add(path_580459, "bucket", newJString(bucket))
  if body != nil:
    body_580461 = body
  add(path_580459, "entity", newJString(entity))
  add(path_580459, "object", newJString(`object`))
  add(query_580460, "fields", newJString(fields))
  result = call_580458.call(path_580459, query_580460, nil, nil, body_580461)

var storageObjectAccessControlsUpdate* = Call_StorageObjectAccessControlsUpdate_580442(
    name: "storageObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsUpdate_580443,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsUpdate_580444,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsGet_580424 = ref object of OpenApiRestCall_579380
proc url_StorageObjectAccessControlsGet_580426(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsGet_580425(path: JsonNode;
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
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580427 = path.getOrDefault("bucket")
  valid_580427 = validateParameter(valid_580427, JString, required = true,
                                 default = nil)
  if valid_580427 != nil:
    section.add "bucket", valid_580427
  var valid_580428 = path.getOrDefault("entity")
  valid_580428 = validateParameter(valid_580428, JString, required = true,
                                 default = nil)
  if valid_580428 != nil:
    section.add "entity", valid_580428
  var valid_580429 = path.getOrDefault("object")
  valid_580429 = validateParameter(valid_580429, JString, required = true,
                                 default = nil)
  if valid_580429 != nil:
    section.add "object", valid_580429
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580430 = query.getOrDefault("key")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "key", valid_580430
  var valid_580431 = query.getOrDefault("prettyPrint")
  valid_580431 = validateParameter(valid_580431, JBool, required = false,
                                 default = newJBool(true))
  if valid_580431 != nil:
    section.add "prettyPrint", valid_580431
  var valid_580432 = query.getOrDefault("oauth_token")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "oauth_token", valid_580432
  var valid_580433 = query.getOrDefault("generation")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "generation", valid_580433
  var valid_580434 = query.getOrDefault("alt")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = newJString("json"))
  if valid_580434 != nil:
    section.add "alt", valid_580434
  var valid_580435 = query.getOrDefault("userIp")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "userIp", valid_580435
  var valid_580436 = query.getOrDefault("quotaUser")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "quotaUser", valid_580436
  var valid_580437 = query.getOrDefault("fields")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "fields", valid_580437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580438: Call_StorageObjectAccessControlsGet_580424; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_580438.validator(path, query, header, formData, body)
  let scheme = call_580438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580438.url(scheme.get, call_580438.host, call_580438.base,
                         call_580438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580438, url, valid)

proc call*(call_580439: Call_StorageObjectAccessControlsGet_580424; bucket: string;
          entity: string; `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageObjectAccessControlsGet
  ## Returns the ACL entry for the specified entity on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580440 = newJObject()
  var query_580441 = newJObject()
  add(query_580441, "key", newJString(key))
  add(query_580441, "prettyPrint", newJBool(prettyPrint))
  add(query_580441, "oauth_token", newJString(oauthToken))
  add(query_580441, "generation", newJString(generation))
  add(query_580441, "alt", newJString(alt))
  add(query_580441, "userIp", newJString(userIp))
  add(query_580441, "quotaUser", newJString(quotaUser))
  add(path_580440, "bucket", newJString(bucket))
  add(path_580440, "entity", newJString(entity))
  add(path_580440, "object", newJString(`object`))
  add(query_580441, "fields", newJString(fields))
  result = call_580439.call(path_580440, query_580441, nil, nil, nil)

var storageObjectAccessControlsGet* = Call_StorageObjectAccessControlsGet_580424(
    name: "storageObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsGet_580425,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsGet_580426,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsPatch_580480 = ref object of OpenApiRestCall_579380
proc url_StorageObjectAccessControlsPatch_580482(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsPatch_580481(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an ACL entry on the specified object. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580483 = path.getOrDefault("bucket")
  valid_580483 = validateParameter(valid_580483, JString, required = true,
                                 default = nil)
  if valid_580483 != nil:
    section.add "bucket", valid_580483
  var valid_580484 = path.getOrDefault("entity")
  valid_580484 = validateParameter(valid_580484, JString, required = true,
                                 default = nil)
  if valid_580484 != nil:
    section.add "entity", valid_580484
  var valid_580485 = path.getOrDefault("object")
  valid_580485 = validateParameter(valid_580485, JString, required = true,
                                 default = nil)
  if valid_580485 != nil:
    section.add "object", valid_580485
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580486 = query.getOrDefault("key")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "key", valid_580486
  var valid_580487 = query.getOrDefault("prettyPrint")
  valid_580487 = validateParameter(valid_580487, JBool, required = false,
                                 default = newJBool(true))
  if valid_580487 != nil:
    section.add "prettyPrint", valid_580487
  var valid_580488 = query.getOrDefault("oauth_token")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "oauth_token", valid_580488
  var valid_580489 = query.getOrDefault("generation")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "generation", valid_580489
  var valid_580490 = query.getOrDefault("alt")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = newJString("json"))
  if valid_580490 != nil:
    section.add "alt", valid_580490
  var valid_580491 = query.getOrDefault("userIp")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "userIp", valid_580491
  var valid_580492 = query.getOrDefault("quotaUser")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = nil)
  if valid_580492 != nil:
    section.add "quotaUser", valid_580492
  var valid_580493 = query.getOrDefault("fields")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = nil)
  if valid_580493 != nil:
    section.add "fields", valid_580493
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

proc call*(call_580495: Call_StorageObjectAccessControlsPatch_580480;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object. This method supports patch semantics.
  ## 
  let valid = call_580495.validator(path, query, header, formData, body)
  let scheme = call_580495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580495.url(scheme.get, call_580495.host, call_580495.base,
                         call_580495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580495, url, valid)

proc call*(call_580496: Call_StorageObjectAccessControlsPatch_580480;
          bucket: string; entity: string; `object`: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; generation: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageObjectAccessControlsPatch
  ## Updates an ACL entry on the specified object. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580497 = newJObject()
  var query_580498 = newJObject()
  var body_580499 = newJObject()
  add(query_580498, "key", newJString(key))
  add(query_580498, "prettyPrint", newJBool(prettyPrint))
  add(query_580498, "oauth_token", newJString(oauthToken))
  add(query_580498, "generation", newJString(generation))
  add(query_580498, "alt", newJString(alt))
  add(query_580498, "userIp", newJString(userIp))
  add(query_580498, "quotaUser", newJString(quotaUser))
  add(path_580497, "bucket", newJString(bucket))
  if body != nil:
    body_580499 = body
  add(path_580497, "entity", newJString(entity))
  add(path_580497, "object", newJString(`object`))
  add(query_580498, "fields", newJString(fields))
  result = call_580496.call(path_580497, query_580498, nil, nil, body_580499)

var storageObjectAccessControlsPatch* = Call_StorageObjectAccessControlsPatch_580480(
    name: "storageObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsPatch_580481,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsPatch_580482,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsDelete_580462 = ref object of OpenApiRestCall_579380
proc url_StorageObjectAccessControlsDelete_580464(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsDelete_580463(path: JsonNode;
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
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580465 = path.getOrDefault("bucket")
  valid_580465 = validateParameter(valid_580465, JString, required = true,
                                 default = nil)
  if valid_580465 != nil:
    section.add "bucket", valid_580465
  var valid_580466 = path.getOrDefault("entity")
  valid_580466 = validateParameter(valid_580466, JString, required = true,
                                 default = nil)
  if valid_580466 != nil:
    section.add "entity", valid_580466
  var valid_580467 = path.getOrDefault("object")
  valid_580467 = validateParameter(valid_580467, JString, required = true,
                                 default = nil)
  if valid_580467 != nil:
    section.add "object", valid_580467
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580468 = query.getOrDefault("key")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "key", valid_580468
  var valid_580469 = query.getOrDefault("prettyPrint")
  valid_580469 = validateParameter(valid_580469, JBool, required = false,
                                 default = newJBool(true))
  if valid_580469 != nil:
    section.add "prettyPrint", valid_580469
  var valid_580470 = query.getOrDefault("oauth_token")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "oauth_token", valid_580470
  var valid_580471 = query.getOrDefault("generation")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "generation", valid_580471
  var valid_580472 = query.getOrDefault("alt")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = newJString("json"))
  if valid_580472 != nil:
    section.add "alt", valid_580472
  var valid_580473 = query.getOrDefault("userIp")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "userIp", valid_580473
  var valid_580474 = query.getOrDefault("quotaUser")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "quotaUser", valid_580474
  var valid_580475 = query.getOrDefault("fields")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "fields", valid_580475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580476: Call_StorageObjectAccessControlsDelete_580462;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_580476.validator(path, query, header, formData, body)
  let scheme = call_580476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580476.url(scheme.get, call_580476.host, call_580476.base,
                         call_580476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580476, url, valid)

proc call*(call_580477: Call_StorageObjectAccessControlsDelete_580462;
          bucket: string; entity: string; `object`: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; generation: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## storageObjectAccessControlsDelete
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580478 = newJObject()
  var query_580479 = newJObject()
  add(query_580479, "key", newJString(key))
  add(query_580479, "prettyPrint", newJBool(prettyPrint))
  add(query_580479, "oauth_token", newJString(oauthToken))
  add(query_580479, "generation", newJString(generation))
  add(query_580479, "alt", newJString(alt))
  add(query_580479, "userIp", newJString(userIp))
  add(query_580479, "quotaUser", newJString(quotaUser))
  add(path_580478, "bucket", newJString(bucket))
  add(path_580478, "entity", newJString(entity))
  add(path_580478, "object", newJString(`object`))
  add(query_580479, "fields", newJString(fields))
  result = call_580477.call(path_580478, query_580479, nil, nil, nil)

var storageObjectAccessControlsDelete* = Call_StorageObjectAccessControlsDelete_580462(
    name: "storageObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsDelete_580463,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsDelete_580464,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsCompose_580500 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsCompose_580502(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsCompose_580501(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationObject: JString (required)
  ##                    : Name of the new object.
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket containing the source objects. The destination object is stored in this bucket.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationObject` field"
  var valid_580503 = path.getOrDefault("destinationObject")
  valid_580503 = validateParameter(valid_580503, JString, required = true,
                                 default = nil)
  if valid_580503 != nil:
    section.add "destinationObject", valid_580503
  var valid_580504 = path.getOrDefault("destinationBucket")
  valid_580504 = validateParameter(valid_580504, JString, required = true,
                                 default = nil)
  if valid_580504 != nil:
    section.add "destinationBucket", valid_580504
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580505 = query.getOrDefault("key")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "key", valid_580505
  var valid_580506 = query.getOrDefault("prettyPrint")
  valid_580506 = validateParameter(valid_580506, JBool, required = false,
                                 default = newJBool(true))
  if valid_580506 != nil:
    section.add "prettyPrint", valid_580506
  var valid_580507 = query.getOrDefault("oauth_token")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = nil)
  if valid_580507 != nil:
    section.add "oauth_token", valid_580507
  var valid_580508 = query.getOrDefault("ifGenerationMatch")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "ifGenerationMatch", valid_580508
  var valid_580509 = query.getOrDefault("alt")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = newJString("json"))
  if valid_580509 != nil:
    section.add "alt", valid_580509
  var valid_580510 = query.getOrDefault("userIp")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "userIp", valid_580510
  var valid_580511 = query.getOrDefault("quotaUser")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "quotaUser", valid_580511
  var valid_580512 = query.getOrDefault("ifMetagenerationMatch")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = nil)
  if valid_580512 != nil:
    section.add "ifMetagenerationMatch", valid_580512
  var valid_580513 = query.getOrDefault("fields")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "fields", valid_580513
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

proc call*(call_580515: Call_StorageObjectsCompose_580500; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ## 
  let valid = call_580515.validator(path, query, header, formData, body)
  let scheme = call_580515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580515.url(scheme.get, call_580515.host, call_580515.base,
                         call_580515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580515, url, valid)

proc call*(call_580516: Call_StorageObjectsCompose_580500;
          destinationObject: string; destinationBucket: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          ifGenerationMatch: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; ifMetagenerationMatch: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageObjectsCompose
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   destinationObject: string (required)
  ##                    : Name of the new object.
  ##   destinationBucket: string (required)
  ##                    : Name of the bucket containing the source objects. The destination object is stored in this bucket.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580517 = newJObject()
  var query_580518 = newJObject()
  var body_580519 = newJObject()
  add(query_580518, "key", newJString(key))
  add(query_580518, "prettyPrint", newJBool(prettyPrint))
  add(query_580518, "oauth_token", newJString(oauthToken))
  add(path_580517, "destinationObject", newJString(destinationObject))
  add(path_580517, "destinationBucket", newJString(destinationBucket))
  add(query_580518, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580518, "alt", newJString(alt))
  add(query_580518, "userIp", newJString(userIp))
  add(query_580518, "quotaUser", newJString(quotaUser))
  add(query_580518, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_580519 = body
  add(query_580518, "fields", newJString(fields))
  result = call_580516.call(path_580517, query_580518, nil, nil, body_580519)

var storageObjectsCompose* = Call_StorageObjectsCompose_580500(
    name: "storageObjectsCompose", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/b/{destinationBucket}/o/{destinationObject}/compose",
    validator: validate_StorageObjectsCompose_580501, base: "/storage/v1beta2",
    url: url_StorageObjectsCompose_580502, schemes: {Scheme.Https})
type
  Call_StorageObjectsCopy_580520 = ref object of OpenApiRestCall_579380
proc url_StorageObjectsCopy_580522(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StorageObjectsCopy_580521(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Copies an object to a destination in the same location. Optionally overrides metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationObject: JString (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   sourceObject: JString (required)
  ##               : Name of the source object.
  ##   sourceBucket: JString (required)
  ##               : Name of the bucket in which to find the source object.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationObject` field"
  var valid_580523 = path.getOrDefault("destinationObject")
  valid_580523 = validateParameter(valid_580523, JString, required = true,
                                 default = nil)
  if valid_580523 != nil:
    section.add "destinationObject", valid_580523
  var valid_580524 = path.getOrDefault("destinationBucket")
  valid_580524 = validateParameter(valid_580524, JString, required = true,
                                 default = nil)
  if valid_580524 != nil:
    section.add "destinationBucket", valid_580524
  var valid_580525 = path.getOrDefault("sourceObject")
  valid_580525 = validateParameter(valid_580525, JString, required = true,
                                 default = nil)
  if valid_580525 != nil:
    section.add "sourceObject", valid_580525
  var valid_580526 = path.getOrDefault("sourceBucket")
  valid_580526 = validateParameter(valid_580526, JString, required = true,
                                 default = nil)
  if valid_580526 != nil:
    section.add "sourceBucket", valid_580526
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifSourceGenerationMatch: JString
  ##                          : Makes the operation conditional on whether the source object's generation matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   ifSourceMetagenerationNotMatch: JString
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the destination object's current generation matches the given value.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the destination object's current generation does not match the given value.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifSourceGenerationNotMatch: JString
  ##                             : Makes the operation conditional on whether the source object's generation does not match the given value.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   sourceGeneration: JString
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   ifSourceMetagenerationMatch: JString
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580527 = query.getOrDefault("key")
  valid_580527 = validateParameter(valid_580527, JString, required = false,
                                 default = nil)
  if valid_580527 != nil:
    section.add "key", valid_580527
  var valid_580528 = query.getOrDefault("ifSourceGenerationMatch")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = nil)
  if valid_580528 != nil:
    section.add "ifSourceGenerationMatch", valid_580528
  var valid_580529 = query.getOrDefault("prettyPrint")
  valid_580529 = validateParameter(valid_580529, JBool, required = false,
                                 default = newJBool(true))
  if valid_580529 != nil:
    section.add "prettyPrint", valid_580529
  var valid_580530 = query.getOrDefault("oauth_token")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "oauth_token", valid_580530
  var valid_580531 = query.getOrDefault("ifSourceMetagenerationNotMatch")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "ifSourceMetagenerationNotMatch", valid_580531
  var valid_580532 = query.getOrDefault("ifGenerationMatch")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "ifGenerationMatch", valid_580532
  var valid_580533 = query.getOrDefault("alt")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = newJString("json"))
  if valid_580533 != nil:
    section.add "alt", valid_580533
  var valid_580534 = query.getOrDefault("userIp")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "userIp", valid_580534
  var valid_580535 = query.getOrDefault("ifGenerationNotMatch")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "ifGenerationNotMatch", valid_580535
  var valid_580536 = query.getOrDefault("quotaUser")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "quotaUser", valid_580536
  var valid_580537 = query.getOrDefault("ifSourceGenerationNotMatch")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "ifSourceGenerationNotMatch", valid_580537
  var valid_580538 = query.getOrDefault("ifMetagenerationMatch")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "ifMetagenerationMatch", valid_580538
  var valid_580539 = query.getOrDefault("sourceGeneration")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "sourceGeneration", valid_580539
  var valid_580540 = query.getOrDefault("ifSourceMetagenerationMatch")
  valid_580540 = validateParameter(valid_580540, JString, required = false,
                                 default = nil)
  if valid_580540 != nil:
    section.add "ifSourceMetagenerationMatch", valid_580540
  var valid_580541 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = nil)
  if valid_580541 != nil:
    section.add "ifMetagenerationNotMatch", valid_580541
  var valid_580542 = query.getOrDefault("projection")
  valid_580542 = validateParameter(valid_580542, JString, required = false,
                                 default = newJString("full"))
  if valid_580542 != nil:
    section.add "projection", valid_580542
  var valid_580543 = query.getOrDefault("fields")
  valid_580543 = validateParameter(valid_580543, JString, required = false,
                                 default = nil)
  if valid_580543 != nil:
    section.add "fields", valid_580543
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

proc call*(call_580545: Call_StorageObjectsCopy_580520; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies an object to a destination in the same location. Optionally overrides metadata.
  ## 
  let valid = call_580545.validator(path, query, header, formData, body)
  let scheme = call_580545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580545.url(scheme.get, call_580545.host, call_580545.base,
                         call_580545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580545, url, valid)

proc call*(call_580546: Call_StorageObjectsCopy_580520; destinationObject: string;
          destinationBucket: string; sourceObject: string; sourceBucket: string;
          key: string = ""; ifSourceGenerationMatch: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          ifSourceMetagenerationNotMatch: string = "";
          ifGenerationMatch: string = ""; alt: string = "json"; userIp: string = "";
          ifGenerationNotMatch: string = ""; quotaUser: string = "";
          ifSourceGenerationNotMatch: string = "";
          ifMetagenerationMatch: string = ""; sourceGeneration: string = "";
          ifSourceMetagenerationMatch: string = ""; body: JsonNode = nil;
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsCopy
  ## Copies an object to a destination in the same location. Optionally overrides metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifSourceGenerationMatch: string
  ##                          : Makes the operation conditional on whether the source object's generation matches the given value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   destinationObject: string (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   ifSourceMetagenerationNotMatch: string
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   destinationBucket: string (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the destination object's current generation matches the given value.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the destination object's current generation does not match the given value.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifSourceGenerationNotMatch: string
  ##                             : Makes the operation conditional on whether the source object's generation does not match the given value.
  ##   sourceObject: string (required)
  ##               : Name of the source object.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   sourceGeneration: string
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   ifSourceMetagenerationMatch: string
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   sourceBucket: string (required)
  ##               : Name of the bucket in which to find the source object.
  ##   body: JObject
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580547 = newJObject()
  var query_580548 = newJObject()
  var body_580549 = newJObject()
  add(query_580548, "key", newJString(key))
  add(query_580548, "ifSourceGenerationMatch", newJString(ifSourceGenerationMatch))
  add(query_580548, "prettyPrint", newJBool(prettyPrint))
  add(query_580548, "oauth_token", newJString(oauthToken))
  add(path_580547, "destinationObject", newJString(destinationObject))
  add(query_580548, "ifSourceMetagenerationNotMatch",
      newJString(ifSourceMetagenerationNotMatch))
  add(path_580547, "destinationBucket", newJString(destinationBucket))
  add(query_580548, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580548, "alt", newJString(alt))
  add(query_580548, "userIp", newJString(userIp))
  add(query_580548, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580548, "quotaUser", newJString(quotaUser))
  add(query_580548, "ifSourceGenerationNotMatch",
      newJString(ifSourceGenerationNotMatch))
  add(path_580547, "sourceObject", newJString(sourceObject))
  add(query_580548, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580548, "sourceGeneration", newJString(sourceGeneration))
  add(query_580548, "ifSourceMetagenerationMatch",
      newJString(ifSourceMetagenerationMatch))
  add(path_580547, "sourceBucket", newJString(sourceBucket))
  if body != nil:
    body_580549 = body
  add(query_580548, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_580548, "projection", newJString(projection))
  add(query_580548, "fields", newJString(fields))
  result = call_580546.call(path_580547, query_580548, nil, nil, body_580549)

var storageObjectsCopy* = Call_StorageObjectsCopy_580520(
    name: "storageObjectsCopy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{sourceBucket}/o/{sourceObject}/copyTo/b/{destinationBucket}/o/{destinationObject}",
    validator: validate_StorageObjectsCopy_580521, base: "/storage/v1beta2",
    url: url_StorageObjectsCopy_580522, schemes: {Scheme.Https})
type
  Call_StorageChannelsStop_580550 = ref object of OpenApiRestCall_579380
proc url_StorageChannelsStop_580552(protocol: Scheme; host: string; base: string;
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

proc validate_StorageChannelsStop_580551(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Stop watching resources through this channel
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
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580553 = query.getOrDefault("key")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "key", valid_580553
  var valid_580554 = query.getOrDefault("prettyPrint")
  valid_580554 = validateParameter(valid_580554, JBool, required = false,
                                 default = newJBool(true))
  if valid_580554 != nil:
    section.add "prettyPrint", valid_580554
  var valid_580555 = query.getOrDefault("oauth_token")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "oauth_token", valid_580555
  var valid_580556 = query.getOrDefault("alt")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = newJString("json"))
  if valid_580556 != nil:
    section.add "alt", valid_580556
  var valid_580557 = query.getOrDefault("userIp")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = nil)
  if valid_580557 != nil:
    section.add "userIp", valid_580557
  var valid_580558 = query.getOrDefault("quotaUser")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = nil)
  if valid_580558 != nil:
    section.add "quotaUser", valid_580558
  var valid_580559 = query.getOrDefault("fields")
  valid_580559 = validateParameter(valid_580559, JString, required = false,
                                 default = nil)
  if valid_580559 != nil:
    section.add "fields", valid_580559
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

proc call*(call_580561: Call_StorageChannelsStop_580550; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_580561.validator(path, query, header, formData, body)
  let scheme = call_580561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580561.url(scheme.get, call_580561.host, call_580561.base,
                         call_580561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580561, url, valid)

proc call*(call_580562: Call_StorageChannelsStop_580550; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; resource: JsonNode = nil;
          fields: string = ""): Recallable =
  ## storageChannelsStop
  ## Stop watching resources through this channel
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   resource: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580563 = newJObject()
  var body_580564 = newJObject()
  add(query_580563, "key", newJString(key))
  add(query_580563, "prettyPrint", newJBool(prettyPrint))
  add(query_580563, "oauth_token", newJString(oauthToken))
  add(query_580563, "alt", newJString(alt))
  add(query_580563, "userIp", newJString(userIp))
  add(query_580563, "quotaUser", newJString(quotaUser))
  if resource != nil:
    body_580564 = resource
  add(query_580563, "fields", newJString(fields))
  result = call_580562.call(nil, query_580563, nil, nil, body_580564)

var storageChannelsStop* = Call_StorageChannelsStop_580550(
    name: "storageChannelsStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_StorageChannelsStop_580551, base: "/storage/v1beta2",
    url: url_StorageChannelsStop_580552, schemes: {Scheme.Https})
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
